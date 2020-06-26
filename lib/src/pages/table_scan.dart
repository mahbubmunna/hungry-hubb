import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/src/models/restaurant_table.dart';
import 'package:food_delivery_app/src/models/route_argument.dart';
import 'dart:convert';

var barcode;
RestaurantTable restaurantTable;
class TableScan extends StatefulWidget {
  @override
  _TableScanState createState() => _TableScanState();
}

class _TableScanState extends State<TableScan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text('First Step is scaning a table', textScaleFactor: 2,)),
          SizedBox(height: 20,),
          MaterialButton(
            textColor: Colors.white,
            color: Theme.of(context).accentColor,
            shape: StadiumBorder(),
            onPressed: () async{
              _startScan();
            },
            child: Text('Scan Table', textScaleFactor: 1.5, ),
          ),
        ],
      )
    );
  }

  _startScan() async {
    try {
      barcode = await BarcodeScanner.scan();
      
      restaurantTable = RestaurantTable.fromJson(json.decode(barcode));
      print('restaurant and table id: ');
      print(restaurantTable.restaurantId);
      print(restaurantTable.tableId);

      AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          btnOk: MaterialButton(
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
            textColor: Colors.white,
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/Pages', ModalRoute.withName('/Splash'), arguments: RouteArgument(param: 0)),
            child: Text('Scan Completed, Now order'),
          ),
          body: Text(barcode.toString()))
          .show();

//      setState(() {
//        this.barcode = barcode;
//        print(barcode);
//        AwesomeDialog(
//            context: context,
//            dialogType: DialogType.SUCCES,
//            body: Text(barcode.toString()))
//            .show();
//      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => barcode =
      'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => barcode = 'Unknown error: $e');
    }
  }
}

