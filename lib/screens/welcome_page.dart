import 'package:course_select/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';
import 'auth.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);
  static const screenId = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return HomePage();
          }else{
            return const Onboarding();
          }
        });
  }
}

class Onboarding extends StatelessWidget {
  const Onboarding({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Users will have an overview of app features (onboarding)'),
              const SizedBox(height: 20),
              TextButton(
              onPressed: () => {Get.toNamed(PageRoutes.register)},
              child: const Text('Register')),
              TextButton(
                  onPressed: () => {Get.toNamed(PageRoutes.login)},
                  child: const Text('Login'))
            ],
          ),
        ));
  }
}
