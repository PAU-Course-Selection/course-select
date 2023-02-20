import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../shared_widgets/gradient_button.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);



  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}



class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  bool isSent = false;
  String? errorMessage = '';

  Future passwordReset() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _controllerEmail.text.trim());
      setState(() {
        isSent = true;
      });
    }on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message;
        isSent = false;
      });
    }
  }

  Widget _showMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: isSent? const Text('Password reset link sent, check your email' ,style: TextStyle(color: Colors.green)):  Text(errorMessage ?? '' ,style: const TextStyle(color: Colors.red),
    ));
  }

  Widget _submitButton() {
    return GradientButton(
      onPressed:()=> passwordReset(),
      buttonText: 'Reset Password',
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/forgot.json'),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Enter your email and we will send you a password reset link', textAlign: TextAlign.center,),
            ),
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
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[100]!))
                    ),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _controllerEmail,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.grey[500])
                      ),
                    ),
                  ),

                ],
              ),
            ),
            _showMessage(),
            _submitButton(),

          ],
        ),
      ),
    );
  }
}
