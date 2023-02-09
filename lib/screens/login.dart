import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../animation/fade_nimation.dart';
import '../routes/routes.dart';

class LoginPage extends StatelessWidget {
  static final screenId = 'login_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      height: 400,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 20,
                            width: 400,
                            height: 500,
                            child: FadeAnimation(0.5, Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/bg.jpg'),
                                      fit: BoxFit.contain
                                  )
                              ),
                            )),
                          ),
                          Positioned(
                            left: 30,
                            width: 80,
                            height: 200,
                            child: FadeAnimation(1, Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/light-1.png')
                                  )
                              ),
                            )),
                          ),
                          Positioned(
                            left: 140,
                            width: 80,
                            height: 120,
                            child: FadeAnimation(1.3, Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/light-2.png')
                                  )
                              ),
                            )),
                          ),
                          Positioned(
                            right: 40,
                            top: 40,
                            width: 80,
                            height: 100,
                            child: FadeAnimation(1.5, Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/clock.png')
                                  )
                              ),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Container(
                  child: FadeAnimation(1.6, Container(
                    margin: EdgeInsets.only(top: 10, left: 30),
                    child: Align(
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
                  )),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(1.8, Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
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
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey[500])
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                      SizedBox(height: 30,),
                      FadeAnimation(2, Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color(0xffEF514C),
                                ]
                            )
                        ),
                        child: Center(
                          child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto')),
                        ),
                      )),
                      SizedBox(height: 30,),
                      GestureDetector(
                        onTap: () => {Navigator.popAndPushNamed(context, PageRoutes.register)},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeAnimation(1.5, Text("Not yet a Student?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)),
                            FadeAnimation(1.5, TextButton(
                                onPressed: () { Navigator.popAndPushNamed(context, PageRoutes.register); },
                                child: Text("Register", style: TextStyle(color: Color(0xFF0C005A), fontWeight: FontWeight.bold))),
                            )],
                        ),
                      ),

                      FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Color(0xffEC4F4A)),)),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}