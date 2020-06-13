import 'dart:convert';

import 'package:food_delivery_app/src/helpers/helper.dart';
import 'package:food_delivery_app/src/models/category.dart';
import 'package:food_delivery_app/src/models/user.dart';
import 'package:food_delivery_app/src/repository/user_repository.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

Future<Stream<Category>> getCategories() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  int restaurantId = 3;
  String categoryName = "Food";
  final String url = '${GlobalConfiguration().getString('api_base_url')}$restaurantId/categories?category_name=$categoryName';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) => Category.fromJSON(data));
}

Future<Stream<Category>> getCategory(String id) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';
  int catId = int.parse(id);
  final String url = '${GlobalConfiguration().getString('api_base_url')}category/$catId';
  print(url);

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) => Category.fromJSON(data));
}
