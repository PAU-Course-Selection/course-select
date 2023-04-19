import 'package:course_select/screens/course_info_page.dart';
import 'package:course_select/screens/edit_user_profile_page.dart';
import 'package:course_select/screens/search_sheet.dart';
import 'package:course_select/screens/select_interests_page.dart';
import 'package:flutter/cupertino.dart';
import '../screens/auth_pages/forgot_password_page.dart';
import '../screens/auth_pages/login_register_page.dart';
import '../screens/app_main_navigation.dart';
import '../screens/my_courses_page.dart';
import '../screens/user_profile_page.dart';
import '../screens/intro_pages/welcome_page.dart';
import '../utils/enums.dart';

///Creates a class with accessible routes to all screens of the app
class PageRoutes{
  static const String welcome = 'welcome';
  static const String loginRegister = 'logIn';
  static const String register = 'register';
  static const String interests = 'interests';
  static const String home = 'home';
  static const String userProfile = 'user_profile';
  static const String forgotPassword = 'forgot_password';
  static const String courseInfo = 'course_info';
  static const String searchSheet = 'search_sheet';
  static const String courses = 'courses_page';
  static const String edit = 'edit_profile_page';

  ///Builds screen widgets and maps them to class attributes
  Map<String, WidgetBuilder> routes() {
    return{
      welcome: (context) => const WelcomePage(),
      loginRegister: (context) => const LoginRegisterPage(),
      interests:(context) => const SelectInterestsPage(),
      home: (context) => const AppMainNav(),
      courseInfo: (context) => const CourseInfoPage(),
      userProfile: (context) => const UserProfilePage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      searchSheet: (context) =>  const SearchSheet(categoryFilterKeyword: CategorySearchFilter.all,),
      courses: (context) => const MyCourses(),
      edit: (context) => const EditUserProfilePage(),
    };
  }

}