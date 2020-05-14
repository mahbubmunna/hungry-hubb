import 'package:flutter/material.dart';

class StaffConfirmation extends StatelessWidget {
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
          Center(child: Text('Just wait a moment, a staff is comming for you', textScaleFactor: 2, textAlign: TextAlign.center,))
        ],
      ),
    );
  }
}
