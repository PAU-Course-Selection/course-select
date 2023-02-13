import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../routes/routes.dart';
import '../shared_widgets/gradient_button.dart';
import 'auth.dart';

class RegisterPage extends StatefulWidget {
  static const screenId = 'register_screen';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();



  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Hmm? $errorMessage', style: const TextStyle(color: Colors.red),);
  }

  bool _errorVisibility = false;

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
                    height: 320,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          width: 420.w,
                          height: 440.h,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/regbg.jpg'),
                                    fit: BoxFit.contain
                                )
                            ),
                          )),
                        Positioned(
                          left: 30,
                          width: 80.w,
                          height: 120.h,
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
                          height: 80.h,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/light-2.png')
                                )
                            ),
                          )),
                        Positioned(
                          right: 30,
                          top: 20,
                          width: 80.w,
                          height: 80.h,
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
                margin: EdgeInsets.only(top: 10.h, left: 30),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      "Register",
                      style: TextStyle(
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
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey[100]!))
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Name",
                                  hintStyle: TextStyle(color: Colors.grey[500])
                              ),
                            ),
                          ),
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
                                  hintText: "Password",//Do passwords need to be invisible?
                                  hintStyle: TextStyle(color: Colors.grey[500])
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Visibility(
                        visible: _errorVisibility,
                        child: _errorMessage()),

                    GradientButton(
                      buttonText: 'Register',
                      onPressed: () async {
                        await createUserWithEmailAndPassword();
                        log('REGISTER');
                        setState((){
                          isLogin = !isLogin;
                        });
                        if(isLogin){
                          log('success');
                          setState((){
                            _errorVisibility = false;
                          });
                          Get.toNamed(PageRoutes.home);
                        }else {
                          _errorVisibility = true;
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already a Student?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
                        TextButton(
                            onPressed: () {Get.toNamed(PageRoutes.login);  },
                            child: const Text("Login", style: TextStyle(color: Color(0xFF0C005A), fontWeight: FontWeight.bold))),
                        ],
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