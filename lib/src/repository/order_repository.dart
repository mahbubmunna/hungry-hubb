import 'dart:convert';
import 'dart:io';

import 'package:food_delivery_app/src/helpers/helper.dart';
import 'package:food_delivery_app/src/models/credit_card.dart';
import 'package:food_delivery_app/src/models/order.dart';
import 'package:food_delivery_app/src/models/order_status.dart';
import 'package:food_delivery_app/src/models/payment.dart';
import 'package:food_delivery_app/src/models/user.dart';
import 'package:food_delivery_app/src/repository/user_repository.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

Future<Stream<Order>> getOrders() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'Token ${_user.apiToken}';
  final String _restaurantId = '3';
  print((_user.apiToken));
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}order-list/$_restaurantId';

  final client = new http.Client();
  http.MultipartRequest request =
  http.MultipartRequest('get', Uri.parse(url));
  request.headers['authorization'] = _apiToken;
  final streamedRest = await client.send(request);

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    var test = Order.fromJSON(data);
    return Order.fromJSON(data);
  });
}

Future<Stream<Order>> getOrder(orderId) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'Token ${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}order-single/$orderId';

  final client = new http.Client();
  http.MultipartRequest request =
  http.MultipartRequest('get', Uri.parse(url));
  request.headers['authorization'] = _apiToken;
  final streamedRest = await client.send(request);

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<Order>> getRecentOrders() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=3';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<OrderStatus>> getOrderStatus() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'Token ${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}order_statuses/';

  final client = new http.Client();
  http.MultipartRequest request =
  http.MultipartRequest('get', Uri.parse(url));
  request.headers['authorization'] = _apiToken;
  final streamedRest = await client.send(request);

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return OrderStatus.fromJSON(data);
  });
}

Future<Order> addOrder(Order order, Payment payment) async {
  User _user = await getCurrentUser();
  CreditCard _creditCard = await getCreditCard();
  order.userId = order.userId;
  order.payment = payment;
  final String _apiToken = 'Token ${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}new-order/';
  final client = new http.Client();
  var orderDataCheck = order;
  Map params = order.toMap();
  //params.addAll(_creditCard.toMap());
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: _apiToken},
    body: json.encode(params),
  );
 // var testOrder = Order.fromJSON(json.decode(response.body)['data']);
  print('object');
  return Order.fromJSON(json.decode(response.body)['data']);
}
