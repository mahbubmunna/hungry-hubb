import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/lib_generated_i18n.dart';
import 'package:food_delivery_app/src/elements/DrawerWidget.dart';
import 'package:food_delivery_app/src/models/route_argument.dart';
import 'package:food_delivery_app/src/pages/call_staff.dart';
import 'package:food_delivery_app/src/pages/cart.dart';
import 'package:food_delivery_app/src/pages/favorites.dart';
import 'package:food_delivery_app/src/pages/history.dart';
import 'package:food_delivery_app/src/pages/home.dart';
import 'package:food_delivery_app/src/pages/pay.dart';


// ignore: must_be_immutable
class PagesTestWidget extends StatefulWidget {
  int currentTab;
  RouteArgument routeArgument;
  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesTestWidget({
    Key key,
    this.currentTab,
    this.routeArgument
  }) {
    currentTab = routeArgument.param != null ? routeArgument.param as int : 0;
  }

  @override
  _PagesTestWidgetState createState() {
    return _PagesTestWidgetState();
  }
}

class _PagesTestWidgetState extends State<PagesTestWidget> {
  initState() {
    super.initState();
    print(widget.currentTab);
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesTestWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = HomeWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 1:
          widget.currentPage = FavoritesWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 2:
          widget.currentPage = CallStaff(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 3:
          widget.currentPage = CartWidget();
          break;
        case 4:
          widget.currentPage = HistoryWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 5:
          widget.currentPage = PayWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: widget.scaffoldKey,
        endDrawer: DrawerWidget(),
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(size: 28),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: widget.currentTab,
          onTap: (int i) {
            this._selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
                title: Text(S.of(context).home),
                icon: Icon(Icons.home)
//                Container(
//                  width: 42,
//                  height: 42,
//                  decoration: BoxDecoration(
//                    color: Theme.of(context).accentColor,
//                    borderRadius: BorderRadius.all(
//                      Radius.circular(50),
//                    ),
//                    boxShadow: [
//                      BoxShadow(
//                          color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
//                      BoxShadow(
//                          color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
//                    ],
//                  ),
//                  child: new Icon(Icons.home, color: Theme.of(context).primaryColor),
//                )
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text(S.of(context).top),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.phonelink_ring),
              title: new Text(S.of(context).call_staff),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.border_color),
              title: Text(S.of(context).order),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.history),
              title: Text(S.of(context).history),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text(S.of(context).pay),
            ),
          ],
        ),
      ),
    );
  }
}
