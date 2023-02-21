import 'package:firebase_core/firebase_core.dart';
import 'package:course_select/routes/routes.dart';
import 'firebase_options.dart';
import 'package:course_select/screens/intro_pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'internationalization/app_internalization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in, unit in dp)
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context , child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // You can use the library anywhere in the app even in theme
          home: child,
          locale: const Locale('zh', 'CN'),
          translations: AppTranslations(),
          routes: PageRoutes().routes(),
          theme: ThemeData(
            textTheme: const TextTheme()
          ),
        );
      },
      child: const WelcomePage(),
    );
  }
}