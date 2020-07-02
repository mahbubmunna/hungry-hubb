import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:food_delivery_app/src/helpers/helper.dart';
import 'package:food_delivery_app/src/models/address.dart';
import 'package:food_delivery_app/src/models/credit_card.dart';
import 'package:food_delivery_app/src/models/user.dart';
import 'package:food_delivery_app/src/pages/splash_screen.dart';
import 'package:food_delivery_app/src/repository/user_repository.dart' as userRepo;
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import '../../main.dart';

User currentUser = new User();
User defaultUser = new User();
Map jsonUser;
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
  final String url = '${GlobalConfiguration().getString('api_base_url')}registration';
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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var registrationResponse = await registerUser();
  var loginResponse = await loginForToken();

  print('register_response: $registrationResponse login_response = $loginResponse');
  Map registerMap = json.decode(registrationResponse);
  Map loginMap = json.decode(loginResponse)['data'];

  defaultUser.deviceId = registerMap['device_id'];
  defaultUser.id = registerMap['id'].toString();
  defaultUser.apiToken = loginMap['api_token'];
  defaultUser.deviceToken = await _firebaseMessaging.getToken();
  print(defaultUser.deviceToken);

  var fcmTokenResponse = registerFcmToken();



  if (!prefs.containsKey('current_user')) {
    var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkZXZpY2VfaWQiOiI1NjM4NDMzZGQwNTZmZTgxMTM0NTU2NyIsImV4cCI6MTU5NDI0MjMxOCwidG9rZW5fdHlwZSI6InRva2VuIn0.y3W8IRfea0NJyi_IBrP6QdKPAXPo2S0byUOLyv4DbDw";
    await prefs.setString('current_user', '{"id":2, "api_token":"$token","device_token":"$token", "device_id": $deviceId}');
  }
  print(prefs.getString('current_user'));
  if (prefs.containsKey('current_user')) {
    currentUser = User.fromJSON(json.decode(await prefs.get('current_user')));
  }

  return currentUser;
}

registerFcmToken() async{
//  String os = Platform.operatingSystem; //in your code
//  print(os);
////  prefs.clear();
//  final String registrationUrl = '${GlobalConfiguration().getString('api_base_url')}registration/';
//  final client = new http.Client();
//  final response = await client.post(
//    registrationUrl,
//    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
//    body: json.encode(user.toMap()),
//  );
//  if (response.statusCode == 200) {
//    print(json.decode(response.body));
//  }
//  return response.body;
}

registerUser() async{
  String os = Platform.operatingSystem; //in your code
  print(os);
//  prefs.clear();
  final String registrationUrl = '${GlobalConfiguration().getString('api_base_url')}registration/';
  User user = User();
  user.deviceId = deviceId;
  user.deviceType = os;
  final client = new http.Client();
  final response = await client.post(
    registrationUrl,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body));
  }
  return response.body;
}

loginForToken() async{
  final String loginUrl = '${GlobalConfiguration().getString('api_base_url')}login/?device_id=$deviceId';
  final loginClient = new http.Client();
  final loginResponse = await loginClient.get(
    loginUrl,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  if (loginResponse.statusCode == 200) {
    print(json.decode(loginResponse.body));
  }
  return loginResponse.body;
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