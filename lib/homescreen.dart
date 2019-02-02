import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'colors.dart';

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
  TextEditingController billTotalController = TextEditingController(); 
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
        brightness: Brightness.light,
        elevation: 0.0,
        title: Text(
          "Tip Calculator",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
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
                        Icons.keyboard_return,
                        color: Theme.of(context).textTheme.body1.color,
                      ),
                    )),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                child: Text(
                  "Enter the total amount of your bill above and press the 'Return' icon.",
                  style: Theme.of(context).textTheme.body1,
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                child: Text(
                  "Alter Tip and Split Between to update the bill breakdown.",
                  style: Theme.of(context).textTheme.body1,
                ),
              ),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 110.0,
                      child: Text(
                        "Tip",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).primaryTextTheme.subhead,
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        if (tipPercent > 0) {
                          tipPercent--;
                          calculateBill(null);
                        }
                      },
                      icon: Icon(Icons.remove),
                    ),

                    Container(
                      width: 40.0,
                      child: Text(
                        "$tipPercent%",
                        style: Theme.of(context).textTheme.subhead,
                        textAlign: TextAlign.center,
                      ),  
                    ),               
  
                    IconButton(
                      onPressed: () {
                        if (tipPercent < 50) {
                          tipPercent++;
                          calculateBill(null);
                        }
                      },
                      icon: Icon(Icons.add),
                    ),


                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 110.0,
                      child: Text(
                        "Split Between",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).primaryTextTheme.subhead,
                      ),
                    ), 
                    IconButton(
                      onPressed: () {
                        if (tipSplit > 1) {
                          tipSplit--;
                          calculateBill(null);
                        }
                      },
                      icon: Icon(Icons.remove),
                    ),                    
                    Container(
                      width: 40.0,               
                      child: Text(
                        "$tipSplit",
                        style: Theme.of(context).textTheme.subhead,
                        textAlign: TextAlign.center,
                      ),  
                    ), 
                    IconButton(
                      onPressed: () {
                        if (tipSplit < 50) {
                          tipSplit++;
                          calculateBill(null);
                        }
                      },
                      icon: Icon(Icons.add),
                    ),                  

                  ]),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: appPrimaryTextColor, 
                    width: 2.0 
                  ),
                  borderRadius: BorderRadius.all( Radius.circular(5.0))
                ),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Bill total",
                          style: Theme.of(context).primaryTextTheme.subhead,
                        ),
                        Text(
                          "${formatter.format(billTotal)}",
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      ],
                    ),                  
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "With tip",
                          style: Theme.of(context).primaryTextTheme.subhead,
                        ),
                        Text(
                          "${formatter.format(totalWithTip)}",
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Cost each",
                            style: Theme.of(context).primaryTextTheme.subhead,
                          ),
                          Text(
                            "${formatter.format(totalEach)}",
                            style: Theme.of(context).textTheme.subhead,
                          ),
                        ]
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  /// Get the device locale so we can correctly format the currency
  setupDeviceLocale() async {
    List locales = await platform.invokeMethod("preferredLanguages");
    debugPrint("$locales");
    if(locales.length> 0){
      formatter = NumberFormat.simpleCurrency(locale: locales[0]);
    }
    billTotalController.text = formatter.format(0.0);
    setState((){});
  }
}
