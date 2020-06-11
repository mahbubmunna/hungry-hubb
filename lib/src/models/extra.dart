import 'package:food_delivery_app/src/models/media.dart';
import 'package:global_configuration/global_configuration.dart';

class Extra {
  String id;
  String name;
  double price;
  String image;
  String description;
  bool checked;

  Extra();

  Extra.fromJSON(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'].toString(),
        name = jsonMap['name'],
        price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : null,
        description = jsonMap['description'],
        checked = false,
        image = '${GlobalConfiguration().getString('image_base_url')}${jsonMap['media']}' ?? "";

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["description"] = description;
    return map;
  }
}
