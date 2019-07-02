import 'package:flutter/material.dart';

// Return number as RichText colored red if negative or green if positive
Widget doubleToColouredText(double money) {
  if (money < 0) {
    return RichText(
        text: TextSpan(
            text: money.toStringAsFixed(2) + ' HRK',
            style: TextStyle(color: Colors.red)
        ));
  } else {
    return RichText(
        text: TextSpan(
            text: money.toStringAsFixed(2) + ' HRK',
            style: TextStyle(color: Colors.green)
        ));
  }
}