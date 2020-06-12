import 'package:food_delivery_app/src/models/media.dart';

class Restaurant {
  String id;
  String name;
  String image;
  String rate;
  String address;
  String description;
  String phone;
  String mobile;
  String information;
  String latitude;
  String longitude;
  double distance;

  Restaurant();

  Restaurant.fromJSON(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'].toString()??"",
        name = jsonMap['name']??"",
        image = jsonMap['image'] != null ? jsonMap['image'] : "",
        rate = jsonMap['rate'] ?? '0',
        address = jsonMap['table'].toString()??"",
        description = jsonMap['description']??"",
        phone = jsonMap['mobile_no']??"",
        mobile = jsonMap['mobile_no']??"",
        information = jsonMap['information']??"",
        latitude = jsonMap['latitude']??"",
        longitude = jsonMap['longitude']??"",
        distance = jsonMap['distance'] != null ? double.parse(jsonMap['distance'].toString()) : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
    };
  }
}
