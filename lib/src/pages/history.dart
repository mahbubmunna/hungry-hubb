import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/lib_generated_i18n.dart';
import 'package:food_delivery_app/src/controllers/notification_controller.dart';
import 'package:food_delivery_app/src/elements/EmptyHistoryWidget.dart';
import 'package:food_delivery_app/src/elements/EmptyNotificationsWidget.dart';
import 'package:food_delivery_app/src/elements/NotificationItemWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class HistoryWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HistoryWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HistoryWidgetState createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends StateMVC<HistoryWidget> {
  NotificationController _con;

  _HistoryWidgetState() : super(NotificationController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
          leading: Image.asset('assets/img/japan_resturant.png'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).history,
            style: Theme.of(context)
                .textTheme
                .title
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
              onPressed: () =>
                  widget.parentScaffoldKey.currentState.openEndDrawer(),
            )
          ]),
      body: RefreshIndicator(
        onRefresh: _con.refreshNotifications,
        child: _con.notifications.isEmpty
            ? EmptyHistoryWidget()
            : SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.notifications,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).notifications,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
              ),
              ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 15),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: _con.notifications.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  return NotificationItemWidget(
                      notification: _con.notifications.elementAt(index));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
