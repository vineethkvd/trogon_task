import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void showCustomToast({required String message, Duration? duration}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: duration?.inSeconds ?? 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
        webBgColor: "linear-gradient(to right,#7CFF5BFF, #7CFF5BFF)",
        webPosition: "center",
        webShowClose: true);
  }

  static void showCustomErrorToast(
      {required String message, Color? color, Duration? duration}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration?.inSeconds ?? 3,
      backgroundColor: color ?? Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
      webBgColor: "linear-gradient(to right, #FF0000FF, #FF0000FF)",
      webPosition: "center",
    );
  }
}