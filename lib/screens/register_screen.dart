import 'package:course_select/auth/bloc/auth_state.dart';
import 'package:course_select/extensions/loc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../auth/auth_exceptions.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../dialogs/error_dialog.dart';
import '../routes/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  // static final screenId = 'register_screen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_weak_password,
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_email_already_in_use,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_generic,
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_invalid_email,
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    Container(
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
                                        image: AssetImage(
                                            'assets/images/regbg.jpg'),
                                        fit: BoxFit.contain)),
                              )),
                          Positioned(
                              left: 30,
                              width: 80.w,
                              height: 120.h,
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/light-1.png'))),
                              )),
                          Positioned(
                              left: 140,
                              width: 80.w,
                              height: 80.h,
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/light-2.png'))),
                              )),
                          Positioned(
                              right: 30,
                              top: 20,
                              width: 80.w,
                              height: 80.h,
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/clock.png'))),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                    child: Container(
                  margin: EdgeInsets.only(top: 10.h, left: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(context.loc.register,
                        style: const TextStyle(
                            color: Color(0xFF0C005A),
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato')),
                  ),
                )),
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
                                    offset: Offset(0, 5)),
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .1),
                                    blurRadius: 10.0,
                                    offset: Offset(0, 5))
                              ]),
                          child: Column(children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[100]!))),
                              child: TextField(
                                controller: _name,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        context.loc.name_text_field_placeholder,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500])),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[100]!))),
                              child: TextField(
                                controller: _email,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: context
                                        .loc.email_text_field_placeholder,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500])),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                obscureText: true,
                                controller: _password,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",

                                    //Do passwords need to be invisible?
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500])),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color(0xffEF514C),
                                ]),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        final name = _name.text;
                                        final email = _email.text;
                                        final password = _password.text;
                                        context.read<AuthBloc>().add(
                                              AuthEventRegister(
                                                name,
                                                email,
                                                password,
                                              ),
                                            );
                                      },
                                      child: Text(
                                        context.loc.register,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Already a Student?",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  143, 148, 251, 1)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context.read<AuthBloc>().add(
                                                  const AuthEventLogOut(),
                                                );
                                          },
                                          child: const Text(
                                            "Login",
                                            style: TextStyle(
                                              color: Color(0xFF0C005A),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ])),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
