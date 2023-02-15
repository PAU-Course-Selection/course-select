import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';
import '../shared_widgets/gradient_button.dart';
import 'auth.dart';

class LoginRegisterPage extends StatefulWidget {
  static const screenId = 'login_screen';

  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {

  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

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
      padding: const EdgeInsets.all(8.0),
      child: Text(errorMessage == ''?'' : 'Hmm... $errorMessage', style: const TextStyle(color: Colors.red),),
    );
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
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

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
          errorMessage = '';
        });
      },
      child: isLogin? const RegisterOrLogin(text1: "Not yet a Student?", text2: " Register",): const RegisterOrLogin(text1: "Already a Student?", text2: " Login",),
    );
  }

  Widget _submitButton() {
    return GradientButton(
      onPressed:
      isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      buttonText: isLogin? 'Login' : 'Register',
    );
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
                      isLogin ? 'Login' : 'Register',
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
                              controller: _controllerName,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Name",
                                  hintStyle: TextStyle(color: Colors.grey[500])
                              ),
                            ),
                          ),),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey[100]!))
                            ),
                            child: TextField(
                              controller: _controllerEmail,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey[500])
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _controllerPassword,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey[500])
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 10.0.h),
                    _errorMessage(),
                    _submitButton(),
                    _loginOrRegisterButton(),
                    SizedBox(height: 5.h,),
                    const Text("Forgot Password?", style: TextStyle(color: Color(0xffEC4F4A)),),
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

