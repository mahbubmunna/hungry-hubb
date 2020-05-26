import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/lib_generated_i18n.dart';

class CallStaff extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  CallStaff({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _CallStaffState createState() => _CallStaffState();
}

class _CallStaffState extends State<CallStaff> {
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
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Text(S.of(context).slogan, textScaleFactor: 1.5,),
        ),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () => widget.parentScaffoldKey.currentState.openEndDrawer(),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Text(S.of(context).call_staff_detail, textScaleFactor: 2, textAlign: TextAlign.center,),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                height: 40,
                minWidth: 200,
                textColor: Colors.white,
                color: Theme.of(context).accentColor,
                shape: StadiumBorder(),
                child: Text(S.of(context).call_staff, textScaleFactor: 2,),
                onPressed: (){
                  Navigator.of(context).pushNamed('/StaffConfirmation');
                },
              )
            ),
          )
        ],
      ),
    );
  }
}
