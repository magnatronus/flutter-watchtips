import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homescreen.dart';
import 'colors.dart';

/// Kick the Tyres and Light the Fires
void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(TipCalculator());
}

class TipCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tip Calculator',
      home: HomeScreen(),
      theme: _buildAppTheme(),
    );
  }

  /// Define a modified theme for the app
  ThemeData _buildAppTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: appPrimaryColor,
      backgroundColor: Colors.yellow,
      scaffoldBackgroundColor: appScaffoldColor,
      textSelectionColor: appPrimaryTextColor,
      cursorColor: appPrimaryTextColor,

      textTheme: base.textTheme.apply(
        bodyColor: appTextColor,
        displayColor: appTextColor,
      ),

      primaryTextTheme: base.primaryTextTheme.apply(
        bodyColor: appPrimaryTextColor,
        displayColor: appPrimaryTextColor,
      ),

      accentTextTheme: base.primaryTextTheme.apply(
        bodyColor: accentTextColor,
        displayColor: accentTextColor,
      ),

      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: appButtonColor,
        textTheme: ButtonTextTheme.primary
      ),

      iconTheme: base.iconTheme.copyWith(
        color: appPrimaryButtonColor,
      ),

      /*
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: appTextColor, fontSize: 25.0),
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: appPrimaryTextColor, width: 2.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: appPrimaryTextColor, width: 2.0),
        ),
      ),
      */

    );
  }
}
