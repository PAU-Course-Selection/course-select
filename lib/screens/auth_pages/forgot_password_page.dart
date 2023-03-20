import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../shared_widgets/gradient_button.dart';

///Shows the screen for users to request a new password
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  ///A controller to update text field values for email
  final TextEditingController _controllerEmail = TextEditingController();

  ///This boolean flag specifies whether an email is sent or not.
  bool isSent = false;

  ///Stores an error message if authentication fails for any reason, otherwise it is blank
  String? errorMessage = '';

  ///Sends a password reset email to the given email address.
  Future passwordReset() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _controllerEmail.text.trim());
      setState(() {
        ///If successful, set flag to true
        isSent = true;
      });
    }on FirebaseAuthException catch (e){
      setState(() {
        ///Updates [errorMessage] variable with exception message
        errorMessage = e.message;
        isSent = false;
      });
    }
    //TODO: To complete the password reset, call confirmPasswordReset with the code supplied in the email sent to the user, along with the new password specified by the user.
    //TODO: May throw a FirebaseAuthException with error codes so check to make sure all potential errors are addressed
  }

  ///Either shows a green success text or red error text if the email is sent successfully
  Widget _showMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: isSent? const Text('Password reset link sent, check your email' ,style: TextStyle(color: Colors.green)):  Text(errorMessage ?? '' ,style: const TextStyle(color: Colors.red),
    ));
  }

  ///Triggers password reset function to receive an email
  Widget _submitButton() {
    return GradientButton(
      onPressed:()=> passwordReset(),
      buttonText: 'Reset Password',
    );
  }

  ///Disposes TextEditingController to prevent memory leak
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
