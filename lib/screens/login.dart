import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../routes/routes.dart';

class LoginPage extends StatelessWidget {
  static const screenId = 'login_screen';

  const LoginPage({Key? key}) : super(key: key);
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
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      "Login",
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
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey[500])
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey[500])
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0.h),
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
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto')),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    GestureDetector(
                      onTap: () => {Navigator.popAndPushNamed(context, PageRoutes.register)},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Not yet a Student?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
                          TextButton(
                              onPressed: () { Navigator.popAndPushNamed(context, PageRoutes.register); },
                              child: const Text("Register", style: TextStyle(color: Color(0xFF0C005A), fontWeight: FontWeight.bold))),
                          ],
                      ),
                    ),
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