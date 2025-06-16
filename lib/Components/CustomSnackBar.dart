import 'package:flutter/material.dart';
import '../utils/color_constants.dart';

class CustomSnackBar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontFamily: "Inter",fontSize: 14 ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: primarycolor,
      ),
    );
  }
}