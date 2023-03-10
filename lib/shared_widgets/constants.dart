import 'dart:ui';

import 'package:flutter/material.dart';

Color kPrimaryColour = const Color(0xff0DAB76);
Color kSelected = const Color(0xffF2F3D9);
Color kLightBackground = const Color(0xffD9D9D9);
TextStyle kHeadlineMedium = const TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis);
List<BoxShadow> kSomeShadow = const [
  BoxShadow(
      color: Color.fromRGBO(143, 148, 251, .2),
      blurRadius: 10.0,
      offset: Offset(0, 5)),
  BoxShadow(
      color: Color.fromRGBO(143, 148, 251, .1),
      blurRadius: 10.0,
      offset: Offset(0, 5))
];
