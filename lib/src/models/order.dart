import 'package:food_delivery_app/src/models/address.dart';
import 'package:food_delivery_app/src/models/food_order.dart';
import 'package:food_delivery_app/src/models/order_status.dart';
import 'package:food_delivery_app/src/models/payment.dart';
import 'package:food_delivery_app/src/models/user.dart';

class Order {
  String id;
  List<FoodOrder> foodOrders;
  OrderStatus orderStatus;
  double tax;
  String hint;
  String restaurantId;
  DateTime dateTime;
  int userId;
  Payment payment;
  int table;

  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
    hint = jsonMap['hint'] != null ? jsonMap['hint'].toString() : "";
    orderStatus = jsonMap['order_status'] != null ? OrderStatus.fromJSON(jsonMap['order_status']) : new OrderStatus(1.toString(), 'Received');;
    print(jsonMap['datetime']);
    dateTime = DateTime.parse(jsonMap['datetime']) ?? DateTime.now() ;
    userId = jsonMap['user_id'] != null ? jsonMap['user_id'] : 0;
    table =
        jsonMap['table'] != null ? (jsonMap['table']) : 1;
    foodOrders = jsonMap['food'] != null
        ? List.from(jsonMap['food']).map((element) => FoodOrder.fromJSON(element)).toList()
        : [];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = userId;
    map["order_status_id"] = orderStatus?.id;
    map["tax"] = tax;
    map["restaurant_id"] = restaurantId;
    map["foods"] = foodOrders.map((element) => element.toMap()).toList();
    map["table"] = table;
    return map;
  }
}
