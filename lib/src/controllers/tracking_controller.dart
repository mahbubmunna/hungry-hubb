import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:food_delivery_app/generated/lib_generated_i18n.dart';
import 'package:food_delivery_app/src/helpers/helper.dart';
import 'package:food_delivery_app/src/models/order.dart';
import 'package:food_delivery_app/src/models/order_status.dart';
import 'package:food_delivery_app/src/repository/order_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingController extends ControllerMVC {
  Order order;

  List<OrderStatus> orderStatus = <OrderStatus>[
    OrderStatus(1.toString(), 'Received'),
    OrderStatus(2.toString(), 'In Kitchen'),
    OrderStatus(3.toString(), 'Ready'),
    OrderStatus(4.toString(), 'In Waiter Hand'),
    OrderStatus(5.toString(), 'Delivered'),
  ];
  GlobalKey<ScaffoldState> scaffoldKey;

  TrackingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForOrder({String orderId, String message}) async {
    final Stream<Order> stream = await getOrder(orderId);
    stream.listen((Order _order) {
      setState(() {
        order = _order;
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      //listenForOrderStatus();
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForOrderStatus() async {
    final Stream<OrderStatus> stream = await getOrderStatus();
    stream.listen((OrderStatus _orderStatus) {
      setState(() {
        orderStatus.add(_orderStatus);
      });
    }, onError: (a) {}, onDone: () {});
  }

  List<Step> getTrackingSteps(BuildContext context, String currentState, DateTime stateTime, String orderId) {
    List<Step> _orderStatusSteps = [];
    //if ()
    this.orderStatus.forEach((OrderStatus _orderStatus) {
      _orderStatusSteps.add(Step(
        state: StepState.complete,
        title: Text(
          _orderStatus.status,
          style: Theme.of(context).textTheme.subhead,
        ),
        subtitle: currentState == _orderStatus.id
            ? Text(
                '${DateFormat('HH:mm | yyyy-MM-dd').format(stateTime)}',
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              )
            : SizedBox(height: 0),
        content: SizedBox(
            width: double.infinity,
            child: Text(
              '${Helper.skipHtml(order.hint)}',
            )),
        isActive: (int.tryParse(currentState)) >= (int.tryParse(_orderStatus.id))
      ));
    });
    return _orderStatusSteps;
  }

  Future<void> refreshOrders() async {
    order = new Order();
    listenForOrder(message: S.current.tracking_refreshed_successfuly);
  }

  saveOrderStatus(String orderState, String orderId) async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(orderId, orderState);
  }

  getSavedOrderStatus(String orderId) async{
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(orderId);
  }

}
