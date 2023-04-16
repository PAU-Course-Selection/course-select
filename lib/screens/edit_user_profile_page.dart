import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  Widget _title() {
    return Text(
      'Edit Profile',
      style: kHeadlineMedium,
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
      body: const Center(child: Text('Edit'),),
    );
  }
}
