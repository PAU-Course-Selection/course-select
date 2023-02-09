import 'package:flutter/cupertino.dart';

import '../screens/app_nav_screen.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../screens/welcome.dart';

class PageRoutes{
  static const String welcome = 'welcome';
  static const String login = 'logIn';
  static const String register = 'register';
  static const String home = 'home';




  Map<String, WidgetBuilder> routes() {
    return{
      welcome: (context) => WelcomePage(),
      login: (context) => LoginPage(),
      register: (context) => RegisterPage(),
      home: (context) => AppNavScreen(),

    };
  }

}