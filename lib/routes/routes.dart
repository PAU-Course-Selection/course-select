import 'package:flutter/cupertino.dart';

import '../screens/home_page.dart';
import '../screens/login_page.dart';
import '../screens/register_page.dart';
import '../screens/welcome_page.dart';

class PageRoutes{
  static const String welcome = 'welcome';
  static const String login = 'logIn';
  static const String register = 'register';
  static const String home = 'home';




  Map<String, WidgetBuilder> routes() {
    return{
      welcome: (context) => const WelcomePage(),
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      home: (context) => HomePage(),

    };
  }

}