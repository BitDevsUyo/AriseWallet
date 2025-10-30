

import 'package:flutter/material.dart';

Widget customContainer(double height, double width,Decoration boxdecoration,Widget? child){
  return Container(
    height:height ,
    width: width,
    decoration: boxdecoration,
    child: child,
  );
}

void showCustomSnackBar(BuildContext context, String message,
    {Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    int durationSeconds = 3}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: textColor, fontSize: 16),
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16),
    duration: Duration(seconds: durationSeconds),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

