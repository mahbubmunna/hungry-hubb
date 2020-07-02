class Token {
  String fcmToken;
  String customer;
  String deviceName;
  String isCustomer;

  Token({this.fcmToken, this.customer, this.deviceName, this.isCustomer});

  Token.fromJson(Map<String, dynamic> json) {
    fcmToken = json['fcm_token'];
    customer = json['customer'];
    deviceName = json['device_name'];
    isCustomer = json['is_customer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fcm_token'] = this.fcmToken;
    data['customer'] = this.customer;
    data['device_name'] = this.deviceName;
    data['is_customer'] = this.isCustomer;
    return data;
  }
}