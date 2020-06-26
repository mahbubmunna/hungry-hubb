

class RestaurantTable {
  String restaurantId;
  String  tableId;

  RestaurantTable.fromJson(Map json) {
    restaurantId = json['res_no'];
    tableId = json['table_no'];
  }

}