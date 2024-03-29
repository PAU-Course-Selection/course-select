import 'package:course_select/screens/app_main_navigation.dart';
import 'package:course_select/screens/intro_pages/intro_page1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../routes/routes.dart';
import '../../utils/auth.dart';
import '../select_interests_page.dart';
import 'intro_page2.dart';
import 'intro_page3.dart';

/// [WelcomePage] Controls the welcome page slideshow.
/// This only displays when the app is first opened
class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);
  static const screenId = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const AppMainNav(); //AppMainNav SelectInterestsPage
          }else{
            return const Onboarding();
          }
        });
  }
}

/// [Onboarding] controls the pagination of the slide show and tracks when the last page is reached through the [_onLastPage] flag
class Onboarding extends StatefulWidget {
  const Onboarding({
    Key? key,
  }) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}


class _OnboardingState extends State<Onboarding> {

  final PageController _controller = PageController();
  bool _onLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            PageView(
            controller: _controller,
            onPageChanged: (value){
              setState(() {
                _onLastPage = (value ==2);
              });

            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
            Container(
                alignment: const Alignment(0, 0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:  [
                    GestureDetector(
                        child: const Text('Skip'),
                      onTap: () => Get.offAndToNamed(PageRoutes.loginRegister),
                    ),
                        SmoothPageIndicator( controller: _controller, count: 3,),

                    GestureDetector(
                        onTap: (){
                          _controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                          if(_onLastPage) {
                            Get.offAndToNamed(PageRoutes.loginRegister);
                          }
                        },
                        child: Text(_onLastPage ? 'Done':'Next')),
                  ],
                ),

            )]
        ));
  }
}
