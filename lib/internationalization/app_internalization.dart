import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_UK': {
      'email': 'Email',
      'password': 'Password',
      'login': 'Login',
      'register': 'Register',
      'forgot_password': 'Forgot password?',
      'name': 'Name',
    },
    'zh_CN': {
      'email': '邮件',
      'password': '密码',
      'login': '登记',
      'register': '注册',
      'forgot_password': '忘记密码?',
      'name': '名字',
    }

  };
}