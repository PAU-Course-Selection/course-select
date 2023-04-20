import 'package:course_select/controllers/user_notifier.dart';
import 'package:course_select/firestore/firebase_data_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../routes/routes.dart';
import '../../shared_widgets/gradient_button.dart';
import '../../auth/auth.dart';

class LoginRegisterPage extends StatefulWidget {
  static const screenId = 'login_screen';

  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {

  String? errorMessage = '';
  bool isLogin = true;
  bool _showError = false;

  final userController = Get.put(UserNotifier());
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  DatabaseManager db = DatabaseManager();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      Get.offAndToNamed(PageRoutes.home);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _errorMessage() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(errorMessage == ''?'' : 'Hmm... $errorMessage', style: const TextStyle(color: Colors.red),),
    );
  }

  Widget _emptyFieldError() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(!_showError ? '' : 'All fields required...', style: const TextStyle(color: Colors.red),),
    );
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      if(_controllerName.text != ''){

        await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text.trim(),
          password: _controllerPassword.text.trim(),
        );
        userController.setUserName(_controllerName.text);
        db.userSetup(displayName:_controllerName.text.trim(), email: _controllerEmail.text.trim());
        Get.offAndToNamed(PageRoutes.interests);
      }else{
        setState(() {
          _showError = true;
        });
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
          errorMessage = '';
        });
      },
      child: isLogin? RegisterOrLogin(text1: 'no_student'.tr, text2: 'register'.tr,): RegisterOrLogin(text1: 'already_s'.tr, text2: 'login'.tr,),
    );
  }

  Widget _submitButton() {
    return GradientButton(
      onPressed:
      isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      buttonText: isLogin? 'login'.tr : 'register'.tr,
    );
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  SizedBox(
                    height: 350.h,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 20.w,
                          width: 400.w,
                          height: 450.h,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/bg.jpg'),
                                    fit: BoxFit.contain
                                )
                            ),
                          )),
                        Positioned(
                          left: 30,
                          width: 80.w,
                          height: 150.h,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/light-1.png')
                                )
                            ),
                          )),
                        Positioned(
                          left: 140,
                          width: 80.w,
                          height: 90.h,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/light-2.png')
                                )
                            ),
                          )),
                        Positioned(
                          right: 40,
                          top: 20,
                          width: 80.w,
                          height: 100.h,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/clock.png')
                                )
                            ),
                          )),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0.h, left: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      isLogin ? 'login'.tr : 'register'.tr,
                      style: const TextStyle(
                          color: Color(0xFF0C005A),
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato'
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .2),
                                blurRadius: 10.0,
                                offset: Offset(0, 5)
                            ),
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .1),
                                blurRadius: 10.0,
                                offset: Offset(0, 5)
                            )
                          ]
                      ),
                      child: Column(
                        children: <Widget>[
                          Visibility(
                            visible: isLogin? false:true,
                            child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey[100]!))
                            ),
                            child: TextField(
                              keyboardType: TextInputType.name,
                              controller: _controllerName,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'name'.tr,
                                  hintStyle: TextStyle(color: _showError? Colors.red: Colors.grey[500])
                              ),
                            ),
                          ),),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey[100]!))
                            ),
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _controllerEmail,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'email'.tr,
                                  hintStyle: TextStyle(color: Colors.grey[500])
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              controller: _controllerPassword,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'password'.tr,
                                  hintStyle: TextStyle(color: Colors.grey[500])
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    _emptyFieldError(),
                    _errorMessage(),
                    _submitButton(),
                    _loginOrRegisterButton(),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(PageRoutes.forgotPassword);
                      },
                      child: Text(isLogin? 'forgot_password'.tr: '', style: const TextStyle(color: Color(0xffEC4F4A)),),
                      ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}

class RegisterOrLogin extends StatelessWidget {
  final String text1;
  final String text2;
  const RegisterOrLogin({
    Key? key, required this.text1, required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text1, style: const TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
        Text(text2, style: const TextStyle(color: Color(0xFF0C005A), fontWeight: FontWeight.bold)),
        ],
    );
  }
}

