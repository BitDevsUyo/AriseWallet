

import 'package:flutter/material.dart';

Widget customContainer(double height, double width,Decoration boxdecoration,Widget? child){
  return Container(
    height:height ,
    width: width,
    decoration: boxdecoration,
    child: child,
  );
}