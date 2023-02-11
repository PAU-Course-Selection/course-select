import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../routes/routes.dart';

class RegisterPage extends StatelessWidget {
  static const screenId = 'register_screen';

  const RegisterPage({Key? key}) : super(key: key);
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
                            padding: EdgeInsets.all(8.0),
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
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey[100]!))
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey[500])
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
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
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color(0xffEF514C),
                              ]
                          )
                      ),
                      child: const Center(
                        child: Text(
                            "Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto')),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already a Student?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
                        TextButton(
                            onPressed: () { Navigator.popAndPushNamed(context, PageRoutes.login); },
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