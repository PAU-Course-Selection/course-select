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
      'no_student':'Not yet a Student？',
      'already_s' : 'Already a Student?'
    },
    'zh_CN': {
      'email': '邮箱',
      'password': '密码',
      'login': '登陆',
      'register': '注册',
      'forgot_password': '忘记密码?',
      'name': '姓名',
      'no_student':'还不是学生？',
      'already_s':'已有账户？'
    }
  };
}