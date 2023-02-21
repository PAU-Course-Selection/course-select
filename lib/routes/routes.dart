import 'package:flutter/cupertino.dart';
import '../screens/forgot_password.dart';
import '../screens/home_page.dart';
import '../screens/login_register_page.dart';
import '../screens/user_profile_page.dart';
import '../screens/intro_pages/welcome_page.dart';

///Creates a class with accessible routes to all screens of the app
class PageRoutes{
  static const String welcome = 'welcome';
  static const String loginRegister = 'logIn';
  static const String register = 'register';
  static const String home = 'home';
  static const String userProfile = 'user_profile';
  static const String forgotPassword = 'forgot_password';

  ///Builds screen widgets and maps them to class attributes
  Map<String, WidgetBuilder> routes() {
    return{
      welcome: (context) => const WelcomePage(),
      loginRegister: (context) => const LoginRegisterPage(),
      home: (context) => const HomePage(),
      userProfile: (context) => UserProfilePage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
    };
  }

}