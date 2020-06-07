import 'dart:convert';
import 'dart:io';

import 'package:food_delivery_app/src/helpers/helper.dart';
import 'package:food_delivery_app/src/models/address.dart';
import 'package:food_delivery_app/src/models/credit_card.dart';
import 'package:food_delivery_app/src/models/user.dart';
import 'package:food_delivery_app/src/repository/user_repository.dart' as userRepo;
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

User currentUser = new User();
Address deliveryAddress = new Address();

Future<User> login(User user) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}login';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    currentUser = User.fromJSON(json.decode(response.body)['data']);
  }
  return currentUser;
}

Future<User> register(User user) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}register';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    currentUser = User.fromJSON(json.decode(response.body)['data']);
  }
  return currentUser;
}

Future<bool> resetPassword(User user) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}send_reset_link_email';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body)['data']);
    return true;
  } else {
    return false;
  }
}

Future<void> logout() async {
  currentUser = new User();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

void setCurrentUser(jsonString) async {
  if (json.decode(jsonString)['data'] != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', json.encode(json.decode(jsonString)['data']));
  }
}

Future<void> setCreditCard(CreditCard creditCard) async {
  if (creditCard != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('credit_card', json.encode(creditCard.toMap()));
  }
}

Future<User> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
//  prefs.clear();
  if (!prefs.containsKey('current_user')) {
    //await prefs.setString('current_user', '{"id":28,"name":"Mahbub Munnna","email":"mahbub@gmail.com","api_token":"4MKsFSQfBND0PFL6yEskbtBegMqQA9P597y2Wu0FYAQ6lmTK2i03OPeWX0xm","created_at":"2020-02-16 12:18:28","updated_at":"2020-05-13 23:36:44","braintree_id":null,"paypal_email":null,"stripe_id":null,"card_brand":null,"card_last_four":null,"trial_ends_at":null,"device_token":"fqc0SrGK38M:APA91bHjdedlNXRZoYWsEnfGYmvHzqW0I8s7TUMbEaHEaU8vUdrLIIxvXc-NBR1hLB6aHanMz2v5lkJsi31vVN-p3CEgedB7slAe5BQTzmuJk6is5Ds-K9L9f3DZHFbT9E8IJZE1x7Ju","custom_fields":[],"has_media":true,"media":[{"id":157,"name":"api","created_at":"2020-02-16 12:18:29","updated_at":"2020-02-16 12:18:29","url":"https://smartfood.aapbd.com/storage/app/public/157/api.png","thumb":"https://smartfood.aapbd.com/storage/app/public/157/conversions/api-thumb.jpg","icon":"https://smartfood.aapbd.com/storage/app/public/157/conversions/api-icon.jpg","formated_size":"817 B"}]} ');
    await prefs.setString('current_user', '{"id":28, "api_token":"4MKsFSQfBND0PFL6yEskbtBegMqQA9P597y2Wu0FYAQ6lmTK2i03OPeWX0xm","device_token":"fqc0SrGK38M:APA91bHjdedlNXRZoYWsEnfGYmvHzqW0I8s7TUMbEaHEaU8vUdrLIIxvXc-NBR1hLB6aHanMz2v5lkJsi31vVN-p3CEgedB7slAe5BQTzmuJk6is5Ds-K9L9f3DZHFbT9E8IJZE1x7Ju"}');
  }
  print(prefs.getString('current_user'));
  if (prefs.containsKey('current_user')) {
    currentUser = User.fromJSON(json.decode(await prefs.get('current_user')));
  }

  return currentUser;
}

Future<CreditCard> getCreditCard() async {
  CreditCard _creditCard = new CreditCard();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('credit_card')) {
    _creditCard = CreditCard.fromJSON(json.decode(await prefs.get('credit_card')));
  }
  return _creditCard;
}

Future<User> update(User user) async {
  final String _apiToken = 'api_token=${currentUser.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}users/${currentUser.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  setCurrentUser(response.body);
  currentUser = User.fromJSON(json.decode(response.body)['data']);
  return currentUser;
}

Future<Stream<Address>> getAddresses() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}delivery_addresses?$_apiToken&search=user_id:${_user.id}&searchFields=user_id:=&orderBy=is_default&sortedBy=desc';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Address.fromJSON(data);
  });
}

Future<Address> addAddress(Address address) async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(address.toMap()),
  );
  return Address.fromJSON(json.decode(response.body)['data']);
}

Future<Address> updateAddress(Address address) async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(address.toMap()),
  );
  return Address.fromJSON(json.decode(response.body)['data']);
}

Future<Address> removeDeliveryAddress(Address address) async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Address.fromJSON(json.decode(response.body)['data']);
}
