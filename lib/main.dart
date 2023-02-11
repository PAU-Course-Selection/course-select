//import 'package:course_select/screens/login.dart';
import 'package:course_select/routes/routes.dart';
//import 'package:course_select/screens/register.dart';
import 'package:course_select/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in, unit in dp)
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // You can use the library anywhere in the app even in theme
          home: child,
          routes: PageRoutes().routes(),
        );
      },
      child: const WelcomePage(),
    );
  }
}