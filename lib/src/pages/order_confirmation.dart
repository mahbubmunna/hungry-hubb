import 'package:flutter/material.dart';

class SuccessfulOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.check_circle_outline, size: 100, color: Theme.of(context).accentColor,),
          Center(child: Text('Coming Soon', textScaleFactor: 2, textAlign: TextAlign.center,))
        ],
      ),
    );
  }
}
