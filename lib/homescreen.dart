import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = const MethodChannel('uk.spiralarm.watchtips/tipinfo');
  static const stream =
      const EventChannel('uk.spiralarm.watchtips/tipinfo/watchdata');
  StreamSubscription tipSubscription;

  NumberFormat formatter = NumberFormat("##0.00");
  TextEditingController billTotalController =
      TextEditingController(text: "0.00");
  int tipPercent = 10, tipSplit = 1;
  double billTotal = 0.0;
  double totalWithTip = 0.0;
  double totalEach = 0.0;

  @override
  void initState() {
    super.initState();
    setupDeviceLocale();
    activateWatchConnection();
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
        title: Text("Tip Calculator"),
      ),
      body: Container(
        margin: EdgeInsets.all(30.0),
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: billTotalController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  labelText: "Bill Total",
                  suffixIcon: IconButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      calculateBill(double.tryParse(billTotalController.text));
                    },
                    icon: Icon(
                      Icons.thumb_up,
                      color: Theme.of(context).textTheme.body1.color,
                    ),
                  )),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Tip Percentage",
                    style: Theme.of(context).primaryTextTheme.title,
                  ),
                  IconButton(
                    onPressed: () {
                      if (tipPercent > 0) {
                        tipPercent--;
                        calculateBill(null);
                      }
                    },
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    "$tipPercent%",
                    style: Theme.of(context).textTheme.title,
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    onPressed: () {
                      if (tipPercent < 50) {
                        tipPercent++;
                        calculateBill(null);
                      }
                    },
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Split Between",
                    style: Theme.of(context).primaryTextTheme.title,
                  ),
                  IconButton(
                    onPressed: () {
                      if (tipSplit > 1) {
                        tipSplit--;
                        calculateBill(null);
                      }
                    },
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    "$tipSplit",
                    style: Theme.of(context).textTheme.title,
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    onPressed: () {
                      if (tipSplit < 50) {
                        tipSplit++;
                        calculateBill(null);
                      }
                    },
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total with tip",
                    style: Theme.of(context).primaryTextTheme.title,
                  ),
                  Text(
                    "${formatter.format(totalWithTip)}",
                    style: Theme.of(context).textTheme.title,
                  ),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total cost each",
                    style: Theme.of(context).primaryTextTheme.title,
                  ),
                  Text(
                    "${formatter.format(totalEach)}",
                    style: Theme.of(context).textTheme.title,
                  ),
                ]),
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
      double tip = (total / 100) * tipPercent;
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

  /// Get the set device locale so we can correctly format the currency
  setupDeviceLocale() async {
    List locales = await platform.invokeMethod("preferredLanguages");
    debugPrint("$locales");
    if(locales.length> 0){
      formatter = NumberFormat.simpleCurrency(locale: locales[0]);
      setState(() {});
    }
  }
}
