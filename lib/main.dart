import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'colors.dart';

void main() => runApp(TipCalculator());

class TipCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TipCalculator',
      home: HomeScreen(),
      theme: _buildAppTheme(),
    );
  }

  /// Define a modified theme for the app
  ThemeData _buildAppTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: appPrimaryColor,
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
      iconTheme: base.iconTheme.copyWith(color: appPrimaryTextColor),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: appTextColor, fontSize: 25.0),
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: appPrimaryTextColor, width: 2.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: appPrimaryTextColor, width: 2.0),
        ),
      ),
    );
  }
}
