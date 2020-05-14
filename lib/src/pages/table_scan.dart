import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/src/models/route_argument.dart';


class TableScan extends StatefulWidget {
  @override
  _TableScanState createState() => _TableScanState();
}

class _TableScanState extends State<TableScan> {
  var barcode;
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
              Navigator.of(context).pushNamedAndRemoveUntil('/Pages', ModalRoute.withName('/Splash'), arguments: RouteArgument(param: 0));
            },
            child: Text('Scan Table', textScaleFactor: 1.5, ),
          ),
        ],
      )
    );
  }

  _startScan() async {
    try {
      var barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
        AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            body: Text(barcode.toString()))
            .show();
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
      'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}

