import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'numberpad.dart';
import 'widgets/scaleroute.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = const MethodChannel('uk.spiralarm.watchtips/tipinfo');
  static const stream = const EventChannel('uk.spiralarm.watchtips/tipinfo/watchdata');
  StreamSubscription tipSubscription;

  NumberFormat formatter = NumberFormat("##0.00");
  TextEditingController billTotalController = TextEditingController();
  int tipPercent = 10, tipSplit = 1;
  double billTotal = 0.0;
  double tip = 0.0;
  double totalWithTip = 0.0;
  double totalEach = 0.0;

  @override
  void initState() {
    super.initState();
    setupDeviceLocale();
    if(Platform.isIOS){
      activateWatchConnection();
    }
  }

  @override
  void dispose() {
    if (tipSubscription != null) {
      tipSubscription.cancel();
      tipSubscription = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          "Tip Calculator",
          style: Theme.of(context).primaryTextTheme.display1,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                RaisedButton(
                  elevation: 0.0,
                  onPressed: () async {
                    var value = await Navigator.push(
                      context,
                      ScaleRoute(widget:  NumberPad(
                        billTotal,
                        normalStyle: Theme.of(context).textTheme.display2,
                        errorStyle: Theme.of(context).accentTextTheme.display2,
                      )),
                    );
                    if(value != null){
                      calculateBill(value);
                    }
                  },
                  color: Colors.orange,
                  child: Text(
                    "Bill Total",
                    style: Theme.of(context).primaryTextTheme.headline,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
 
                Text(
                  "${formatter.format(billTotal)}",
                  style: Theme.of(context).primaryTextTheme.headline,
                  textAlign: TextAlign.right,
                ),
              ],
            ),

            SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "tip @ $tipPercent%",
                  style: Theme.of(context).textTheme.headline,                  
                ),
                Text(
                  "${formatter.format(tip)}",
                  style: Theme.of(context).primaryTextTheme.headline,
                  textAlign: TextAlign.right,
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Total with tip",
                  style: Theme.of(context).textTheme.headline,                  
                ),
                Text(
                  "${formatter.format(totalWithTip)}",
                  style: Theme.of(context).primaryTextTheme.headline,
                  textAlign: TextAlign.right,
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.all(15.0),
              height: 1.0,
              color: Theme.of(context).textTheme.headline.color
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Split between",
                  style: Theme.of(context).textTheme.headline,                  
                ),
                Text(
                  "$tipSplit",
                  style: Theme.of(context).primaryTextTheme.headline,
                  textAlign: TextAlign.right,
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Cost each",
                  style: Theme.of(context).textTheme.headline,                  
                ),
                Text(
                  "${formatter.format(totalEach)}",
                  style: Theme.of(context).primaryTextTheme.headline,
                  textAlign: TextAlign.right,
                ),
              ],
            ),


            Container(
              margin: EdgeInsets.all(15.0),
              height: 1.0,
              color: Theme.of(context).textTheme.headline.color
            ),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[


            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
               Text(
                  "Tip Percentage",
                  style: Theme.of(context).primaryTextTheme.title,
                  textAlign: TextAlign.right,
                ),

                IconButton(
                  iconSize: 50.0,
                  onPressed: () {
                    if (tipPercent > 0) {
                      tipPercent--;
                      calculateBill(null);
                    }
                  },
                  icon: Icon(
                    Icons.remove_circle,
                  ),
                ),

                IconButton(  
                  iconSize: 50.0,
                onPressed: () {
                  if (tipPercent < 100) {
                    tipPercent++;
                    calculateBill(null);
                  }
                },                         
                icon: Icon(
                  Icons.add_circle,
                ),
              ), 
 
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Split between",
                  style: Theme.of(context).primaryTextTheme.title,
                  textAlign: TextAlign.right,
                ),
                IconButton(
                  iconSize: 50.0,
                  onPressed: () {
                    if (tipSplit > 1) {
                      tipSplit--;
                      calculateBill(null);
                    }
                  },
                  icon: Icon(
                    Icons.remove_circle,
                  ),
                ), 

                IconButton(
                  iconSize: 50.0,
                  onPressed: () {
                    if (tipSplit < 50) {
                      tipSplit++;
                      calculateBill(null);
                    }
                  },
                  icon: Icon(
                    Icons.add_circle,
                  ),
                ), 

              ],
            ),

                  ],
                ),
              ),
            ),

          ],
        ),

      ),
    );
  }

  /// Simple calculation of bill amounts
  calculateBill(double total) {
    total = (total ?? billTotal);
    setState(() {
      billTotal = total;
      billTotalController.text = "${formatter.format(billTotal)}";
      tip = (total / 100) * tipPercent;
      totalWithTip = total + tip;
      totalEach = (totalWithTip / tipSplit);
    });
  }

  /// Active and start the connection to the Watch App
  activateWatchConnection() async {

    // Start initial Session to allow watch and iOS to swap user data
    await platform.invokeMethod("activateSession");

    // Connect up our stream so we can monitor for watch updates
    stream.receiveBroadcastStream().listen((value) {
      List result = value;
      if (result[0] != null) {
        tipPercent = int.tryParse(result[0]['tip']);
        tipSplit = int.tryParse(result[0]['split']);
        billTotal = double.tryParse(result[0]['bill']);
        calculateBill(null);
      }
    });
  }

  /// Get the device locale so we can correctly format the currency
  setupDeviceLocale() async {
    List locales = await platform.invokeMethod("preferredLanguages");
    debugPrint("$locales");
    if (locales.length > 0) {
      formatter = NumberFormat.simpleCurrency(locale: locales[0]);
    }
    billTotalController.text = formatter.format(0.0);
    setState(() {});
  }
}
