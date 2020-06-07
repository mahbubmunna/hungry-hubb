import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:food_delivery_app/generated/lib_generated_i18n.dart';
import 'package:food_delivery_app/src/controllers/home_controller.dart';
import 'package:food_delivery_app/src/elements/CardsCarouselWidget.dart';
import 'package:food_delivery_app/src/elements/CaregoriesCarouselWidget.dart';
import 'package:food_delivery_app/src/elements/FoodsCarouselWidget.dart';
import 'package:food_delivery_app/src/elements/GridWidget.dart';
import 'package:food_delivery_app/src/elements/ReviewsListWidget.dart';
import 'package:food_delivery_app/src/elements/SearchBarWidget.dart';
import 'package:food_delivery_app/src/elements/ShoppingCartButtonWidget.dart';
import 'package:food_delivery_app/src/repository/settings_repository.dart'
    as settingsRepo;

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget>
    with SingleTickerProviderStateMixin {
  HomeController _con;

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/img/japan_resturant.png'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          //settingsRepo.setting?.appName ?? S.of(context).home,
          S.of(context).momos_cafe,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: Column(
            children: <Widget>[
              Text(
                S.of(context).slogan,
                textScaleFactor: 1.5,
              ),
              SizedBox(
                height: 14,
              ),
              TabBar(
                labelPadding: EdgeInsets.all(0),
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: <Widget>[
                  Tab(
                    text: S.of(context).food,
                  ),
                  Tab(
                    text: S.of(context).drink,
                  ),
                  Tab(
                    text: S.of(context).desert,
                  ),
                  Tab(
                    text: S.of(context).recommended,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () =>
                widget.parentScaffoldKey.currentState.openEndDrawer(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshHome,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.category,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).food_categories,
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
              ),
              CategoriesCarouselWidget(
                categories: _con.categories,
              ),

//              Padding(
//                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
//                child: ListTile(
//                  dense: true,
//                  contentPadding: EdgeInsets.symmetric(vertical: 0),
//                  leading: Icon(
//                    Icons.stars,
//                    color: Theme.of(context).hintColor,
//                  ),
//                  title: Text(
//                    S.of(context).top_restaurants,
//                    style: Theme.of(context).textTheme.display1,
//                  ),
//                  subtitle: Text(
//                    S.of(context).ordered_by_nearby_first,
//                    style: Theme.of(context).textTheme.caption,
//                  ),
//                ),
//              ),
//              CardsCarouselWidget(restaurantsList: _con.topRestaurants, heroTag: 'home_top_restaurants'),
//              ListTile(
//                dense: true,
//                contentPadding: EdgeInsets.symmetric(horizontal: 20),
////                leading: Icon(
////                  Icons.trending_up,
////                  color: Theme.of(context).hintColor,
////                ),
//                title: Text(
//                  S.of(context).break_fast,
//                  style: Theme.of(context).textTheme.display1,
//                ),
////                subtitle: Text(
////                  S.of(context).double_click_on_the_food_to_add_it_to_the,
////                  style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11)),
////                ),
//              ),
//              FoodsCarouselWidget(
//                  foodsList: _con.trendingFoods, heroTag: 'breakfast_carousel'),
//              ListTile(
//                dense: true,
//                contentPadding: EdgeInsets.symmetric(horizontal: 20),
////                leading: Icon(
////                  Icons.trending_up,
////                  color: Theme.of(context).hintColor,
////                ),
//                title: Text(
//                  S.of(context).lunch,
//                  style: Theme.of(context).textTheme.display1,
//                ),
////                subtitle: Text(
////                  S.of(context).double_click_on_the_food_to_add_it_to_the,
////                  style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11)),
////                ),
//              ),
//              FoodsCarouselWidget(
//                  foodsList: _con.trendingFoods, heroTag: 'lunch_carousel'),
//              ListTile(
//                dense: true,
//                contentPadding: EdgeInsets.symmetric(horizontal: 20),
////                leading: Icon(
////                  Icons.trending_up,
////                  color: Theme.of(context).hintColor,
////                ),
//                title: Text(
//                  S.of(context).dinner,
//                  style: Theme.of(context).textTheme.display1,
//                ),
////                subtitle: Text(
////                  S.of(context).double_click_on_the_food_to_add_it_to_the,
////                  style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11)),
////                ),
//              ),
//              FoodsCarouselWidget(
//                  foodsList: _con.trendingFoods, heroTag: 'dinner_carousel'),
//
//
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 20),
//                child: ListTile(
//                  dense: true,
//                  contentPadding: EdgeInsets.symmetric(vertical: 20),
//                  leading: Icon(
//                    Icons.recent_actors,
//                    color: Theme.of(context).hintColor,
//                  ),
//                  title: Text(
//                    S.of(context).recent_reviews,
//                    style: Theme.of(context).textTheme.display1,
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 20),
//                child: ReviewsListWidget(reviewsList: _con.recentReviews),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
