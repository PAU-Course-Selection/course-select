import 'package:course_select/screens/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routes/routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);
  static final screenId = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {Navigator.popAndPushNamed(context, PageRoutes.register)},
                  child: Text('Register')),
              GestureDetector(
              onTap: () => {Navigator.popAndPushNamed(context, PageRoutes.login)},
              child: Text('Login'))
            ],
          ),
        )
        ));
  }
}
