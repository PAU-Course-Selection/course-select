import 'package:course_select/controllers/user_notifier.dart';
import 'package:course_select/shared_widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      'Edit_account'.tr,
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
            decoration:  InputDecoration(hintText: 'name'.tr),
          ),
          TextField(
            controller: _emailController,
            decoration:  InputDecoration(hintText: 'Email'.tr),
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
                      child:  Text('Confirm'.tr),
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
                      child: Text('Cancel'.tr),
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
            title: Text('Confirm_Changes'.tr),
            content:  Text(
                'change_sure'.tr),
            actions: [
              TextButton(
                onPressed: _confirmChanges,
                child:  Text('Confirm'.tr),
              ),
              TextButton(
                onPressed: _cancelChanges,
                child:  Text('Cancel'.tr),
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
