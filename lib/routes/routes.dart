import 'package:flutter/cupertino.dart';

import '../screens/app_nav_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

class PageRoutes{
  static const String login = 'logIn';
  static const String register = 'register';
  static const String home = 'home';




  Map<String, WidgetBuilder> routes() {
    return{
      login: (context) => LoginScreen(),
      register: (context) => RegisterScreen(),
      home: (context) => AppNavScreen(),

    };
  }

}