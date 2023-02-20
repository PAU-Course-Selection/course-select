import 'package:get/get.dart';

class UserController extends GetxController {
  final _userName = 'user'.obs;

  setUserName(String name) {
    _userName(name);
  }

  get userName => _userName;
}