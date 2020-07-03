import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/lib_generated_i18n.dart';
import 'package:food_delivery_app/src/controllers/tracking_controller.dart';
import 'package:food_delivery_app/src/elements/CircularLoadingWidget.dart';
import 'package:food_delivery_app/src/elements/OrderItemWidget.dart';
import 'package:food_delivery_app/src/elements/ShoppingCartButtonWidget.dart';
import 'package:food_delivery_app/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
var fcmToken;
class TrackingWidget extends StatefulWidget {
  RouteArgument routeArgument;

  TrackingWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _TrackingWidgetState createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends StateMVC<TrackingWidget> {
  TrackingController _con;
  bool showCalc = true;
  double dividedPrice;
  double totalPrice;
  String currentState = '1';
  DateTime stateTime = DateTime.now();

  TextEditingController _totalPeopleCon;

  _TrackingWidgetState() : super(TrackingController()) {
    _con = controller;
    _totalPeopleCon = TextEditingController();
  }

  @override
  void initState() {
    _con.listenForOrder(orderId: widget.routeArgument.id);
    dividedPrice = 0.0;
    totalPrice = 0.0;

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      print('device token' + _deviceToken);
      fcmToken = _deviceToken;
      //user.deviceToken = '123456';
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          currentState = message['notification']['body'];
          stateTime = DateTime.parse(message['notification']['title']);
        });
 //       print('current step: '+currentState);
//        showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//            content: ListTile(
//              title: Text(message['notification']['title']),
//              subtitle: Text(message['notification']['body']),
//            ),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('Ok'),
//                onPressed: () => Navigator.of(context).pop(),
//              ),
//            ],
//          ),
//        );
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).copyWith(dividerColor: Colors.transparent, accentColor: Theme.of(context).accentColor);
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).tracking_order,
            style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 7),
          child: _con.order == null || _con.orderStatus.isEmpty
              ? CircularLoadingWidget(height: 300)
              : Column(
                  children: <Widget>[
                    Theme(
                      data: theme,
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: Row(
                          children: <Widget>[
                            Expanded(child: Text('${S.of(context).order_id}: #${_con.order.id}')),
                            Text(
                              '${_con.order.orderStatus.status}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        children: List.generate(_con.order.foodOrders.length, (indexFood) {
                          return OrderItemWidget(
                              heroTag: 'tracking_orders',
                              order: _con.order,
                              foodOrder: _con.order.foodOrders.elementAt(indexFood));
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Theme.of(context).accentColor,
                        ),
                        child: Stepper(
                          physics: ClampingScrollPhysics(),
                          controlsBuilder: (BuildContext context,
                              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                            return SizedBox(height: 0);
                          },
                          steps: _con.getTrackingSteps(context, currentState, stateTime),
                          currentStep: int.tryParse(currentState) - 1,
                        ),
                      ),
                    ),
                    showCalc ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(

                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Total Peoples',
                              hintText: 'number of people you are',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                )
                              )
                            ),
                            controller: _totalPeopleCon,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 12,),
                          MaterialButton(
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                _con.order.foodOrders.forEach((element) {totalPrice += element.price;});
                                dividedPrice = totalPrice / double.parse(_totalPeopleCon.text);
                                showCalc = false;});
                            },
                            child: Text('Calculate'),
                          )
                        ],
                      ),
                    ) : Text('Per Person $dividedPrice Yen', textScaleFactor: 2,)
//                    Container(
//                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                      decoration: BoxDecoration(
//                        color: Theme.of(context).primaryColor,
//                      ),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
//                          Container(
//                            height: 55,
//                            width: 55,
//                            decoration: BoxDecoration(
//                                borderRadius: BorderRadius.all(Radius.circular(5)),
//                                color: Theme.of(context).brightness == Brightness.light
//                                    ? Colors.black38
//                                    : Theme.of(context).backgroundColor),
//                            child: Icon(
//                              Icons.place,
//                              color: Theme.of(context).primaryColor,
//                              size: 38,
//                            ),
//                          ),
//                          SizedBox(width: 15),
//                          Flexible(
//                            child: Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Text(
//                                      _con.order.deliveryAddress.description,
//                                      overflow: TextOverflow.fade,
//                                      softWrap: false,
//                                      style: Theme.of(context).textTheme.subhead,
//                                    ),
//                                    Text(
//                                      _con.order.deliveryAddress.address,
//                                      overflow: TextOverflow.ellipsis,
//                                      maxLines: 2,
//                                      style: Theme.of(context).textTheme.caption,
//                                    ),
//                                  ],
//                                ),
//                              ],
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
                  ],
                ),
        ));
  }
}
