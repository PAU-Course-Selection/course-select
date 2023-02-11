import 'package:flutter/material.dart';

import '../routes/routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);
  static const screenId = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {Navigator.pushNamed(context, PageRoutes.register)},
                  child: const Text('Register')),
              GestureDetector(
              onTap: () => {Navigator.popAndPushNamed(context, PageRoutes.login)},
              child: const Text('Login'))
            ],
          ),
        ));
  }
}
