import 'package:get/get.dart';

class UserController extends GetxController {
  final userName = 'user'.obs;

  setUserName(String name) {
    userName(name);
  }


}