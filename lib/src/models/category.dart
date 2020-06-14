import 'package:global_configuration/global_configuration.dart';

class Category {
  String id;
  String name;
  String image;

  Category();

  Category.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    name = jsonMap['name'];
    image = "http://icons.iconarchive.com/icons/aha-soft/desktop-buffet/256/Steak-icon.png";
   // image = jsonMap['media'] != null ? GlobalConfiguration().getString('image_base_url')+jsonMap['media'] : "https://picsum.photos/200/300/?blur";
   // image = jsonMap['media'] =! null ? GlobalConfiguration().getString('image_base_url') + jsonMap['media'] : "http://icons.iconarchive.com/icons/aha-soft/desktop-buffet/256/Steak-icon.png";
    print(image);
  }

}
