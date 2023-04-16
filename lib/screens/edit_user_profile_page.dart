import 'package:course_select/controllers/user_notifier.dart';
import 'package:course_select/shared_widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../routes/routes.dart';

/// [EditUserProfilePage] displays the user settings screen that allows a user to edit their information
// TODO: Implement account info editing
class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({Key? key}) : super(key: key);

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  // late final TextEditingController _passwordController;

  late final UserNotifier userNotifier;

  @override
  void initState() {
    userNotifier = Provider.of<UserNotifier>(context, listen: false);
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    super.initState();
    // _passwordController = TextEditingController();
  }

  Widget _title() {
    return Text(
      "Edit Account",
      style: kHeadlineMedium,
    );
  }

  Widget _editPage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          // TextField(
          //   controller: _passwordController,
          //   obscureText: true,
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      child: const Text("Confirm"),
                      onPressed: () {
                        _showConfirmationDialog();
                      }),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.red)),
                      child: const Text("Cancel"),
                      onPressed: () {
                        _cancelChanges();
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: _editPage(),
        ),
      ),
    );
  }

  _showConfirmationDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirm Changes"),
            content: const Text(
                "Are you sure you would like to make these changes?"),
            actions: [
              TextButton(
                onPressed: _confirmChanges,
                child: const Text("Confirm"),
              ),
              TextButton(
                onPressed: _cancelChanges,
                child: const Text("Cancel"),
              ),
            ],
          );
        });
  }

  _confirmChanges() async {
    userNotifier.setUserName(_nameController.text);
    userNotifier.email = _emailController.text;
  }

  _cancelChanges() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
