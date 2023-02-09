//import 'package:course_select/screens/login.dart';
import 'package:course_select/routes/routes.dart';
//import 'package:course_select/screens/register.dart';
import 'package:course_select/screens/welcome.dart';
import 'package:flutter/material.dart';


void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      routes: PageRoutes().routes(),
    )
);