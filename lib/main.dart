import 'package:course_select/auth/bloc/auth_event.dart';
import 'package:course_select/auth/bloc/auth_state.dart';
import 'package:course_select/screens/dashboard_screen.dart';
import 'package:course_select/screens/forgot_password_screen.dart';
import 'package:course_select/screens/login_screen.dart';
import 'package:course_select/screens/register_screen.dart';
import 'package:course_select/screens/verify_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'auth/bloc/auth_bloc.dart';
import 'auth/firebase_auth_provider.dart';
import 'helpers/loading/loading_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const MyApp(),
      ),
      routes: {
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context , child) {
          return BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.isLoading) {
                LoadingScreen().show(
                  context: context,
                  text: state.loadingText ?? 'Please wait a moment',
                );
              } else {
                LoadingScreen().hide();
              }
            },
            builder: (context, state) {
              if (state is AuthStateLoggedIn) {
                return const DashboardScreen();
              } else if (state is AuthStateNeedsVerification) {
                return const VerifyEmailScreen();
              } else if (state is AuthStateLoggedOut) {
                return const LoginScreen();
              } else if (state is AuthStateForgotPassword) {
                return const ForgotPasswordScreen();
              } else if (state is AuthStateRegistering) {
                return const RegisterScreen();
              } else {
                return const Scaffold(
                  body: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      );

  }
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    // return ScreenUtilInit(
    //   designSize: const Size(430, 932),
    //   minTextAdapt: true,
    //   splitScreenMode: false,
    //   builder: (context , child) {
    //     return MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       // You can use the library anywhere in the app even in theme
    //       home: child,
    //       routes: PageRoutes().routes(),
    //     );
    //   },
    // );
  }
