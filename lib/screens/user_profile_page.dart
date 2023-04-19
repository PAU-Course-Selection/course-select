import 'dart:io' as io;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_select/routes/routes.dart';
import 'package:course_select/constants/constants.dart';
import 'package:course_select/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../controllers/user_notifier.dart';
import '../utils/auth.dart';
import '../utils/firebase_data_management.dart';
/// This screen allows a user to edit the preferences regarding their account.
/// This includes their user image, privacy settings and interests
/// A user can also delete their account from this page
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String imageUrl = '';
  late final UserNotifier userNotifier;
  final DatabaseManager db = DatabaseManager();
  final User? user = Auth().currentUser;
  late Future futureData;
  int levelResult = 0;
  List myInterests = [];

  /// Displays formatted page title
  Widget _title() {
    return Text(
      'Profile',
      style: kHeadlineMedium,
    );
  }

 /// Gets current student interests and level from the database
  Future<dynamic> _update() async {
    // print('called');
    await db.test();
    if (mounted) {
      setState(() {
        myInterests = userNotifier.userInterests;
        print("myInterests: $myInterests");
        levelResult = userNotifier.studentLevel;
      });
    }
  }

  /// Gets data from the database
  Future getData() async {
    var users = await db.getUsers(userNotifier);

    userNotifier.updateUserDetails();
    userNotifier.getStudentLevel();
    return users;
  }

  late XFile? imgFile;

  /// Loads avatar image and handles updating of the avatar
  Future loadAvatar(bool useCamera) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(
        source: useCamera ? ImageSource.camera : ImageSource.gallery);
    // print(file?.path);

    if (file == null) return;
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(io.File(file.path));
      //Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      //Some error occurred
    }

    var myUser = await FirebaseFirestore.instance
        .collection("Users")
        .where("uid", isEqualTo: user?.uid)
        .get();
    if (myUser.docs.isNotEmpty) {
      var docId = myUser.docs.first.id;

      DocumentReference docRef =
          FirebaseFirestore.instance.collection("Users").doc(docId);
      await docRef.update({"avatar": imageUrl});
      userNotifier.avatar = imageUrl;
    }
  }

  bool imgChanged = false;

  /// Initialise notifiers and get data from the database
  @override
  void initState() {
    userNotifier = Provider.of<UserNotifier>(context, listen: false);
    futureData = getData();
    super.initState();
  }

  late String oldUrl;

  /// Build UI elements for the profile screen
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    List<String> subjects = SubjectArea.values
        .map((status) => status.toString().split('.').last)
        .map((str) => str.substring(0, 1).toUpperCase() + str.substring(1))
        .toList();
    List<String> levels = SkillLevel.values
        .map((status) => status.toString().split('.').last)
        .map((str) => str.substring(0, 1).toUpperCase() + str.substring(1))
        .toList();
    // print(subjects);
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, PageRoutes.edit);
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: FutureBuilder(
          future: futureData,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                width: double.infinity,
                height: 810,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                            onTap: () {
                              showCupertinoModalBottomSheet(
                                isDismissible: true,
                                topRadius: const Radius.circular(20),
                                barrierColor: Colors.black54,
                                elevation: 8,
                                context: context,
                                builder: (context) => Material(
                                    child: SizedBox(
                                  height: screenHeight * 0.25,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      EditImageOptionsItem(
                                        text: 'Take Photo',
                                        onPressed: () async {
                                          await loadAvatar(true);
                                          setState(() {
                                            imgChanged = true;
                                          });
                                        },
                                      ),
                                      const Divider(
                                        height: 0,
                                      ),
                                      EditImageOptionsItem(
                                        text: 'Choose Image',
                                        onPressed: () async {
                                          await loadAvatar(false);
                                          setState(() {
                                            imgChanged = true;
                                          });
                                        },
                                      ),
                                      const Divider(
                                        height: 0,
                                      ),
                                      EditImageOptionsItem(
                                        text: 'Cancel',
                                        onPressed: () {
                                          setState(() {
                                            futureData = getData();
                                          });
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                )),
                              ).whenComplete(() {
                                setState(() {
                                  futureData = getData();
                                });
                              });
                            },
                            child: Stack(children: [
                              CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.white,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(75.0),
                                    child: CachedNetworkImage(
                                      height: 100.0,
                                      width: 100.0,
                                      fit: BoxFit.cover,
                                      imageUrl: userNotifier.avatar,
                                      placeholder: (context, url) {
                                        return const CircularProgressIndicator();
                                      },
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  bottom: 0,
                                  right: 5,
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 15,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 20,
                                        color: kPrimaryColour,
                                      )))
                            ]))),
                    getLevelPill(userNotifier.studentLevel),
                    Text(
                      userNotifier.userName,
                      style: kHeadlineMedium,
                    ),
                    Text(userNotifier.email ?? 'User email'),
                    Text(userNotifier.joinDate),
                    const SizedBox(
                      height: 15,
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              userNotifier.userCourseIds.length.toString(),
                              style: kHeadlineMedium.copyWith(color: kTeal),
                            ),
                            const Text('Enrolled'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('2',
                                style: kHeadlineMedium.copyWith(color: kTeal)),
                            const Text('Active'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('1',
                                style: kHeadlineMedium.copyWith(color: kTeal)),
                            const Text('Completed'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xfffafafa),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: SettingsList(
                                  shrinkWrap: true,
                                  platform: DevicePlatform.device,
                                  lightTheme: const SettingsThemeData(
                                      settingsListBackground:
                                          Colors.transparent),
                                  sections: [
                                    SettingsSection(
                                      title: const Text('Common'),
                                      tiles: <SettingsTile>[
                                        SettingsTile.navigation(
                                          leading: const Icon(Icons.language),
                                          title: const Text('Language'),
                                          value: const Text('English'),
                                        ),
                                        SettingsTile.navigation(
                                          leading: const Icon(
                                              Icons.settings_suggest_rounded),
                                          title:
                                              const Text('Student Preferences'),
                                          onPressed: (context) {
                                            setState(() {
                                              getData();
                                              _showMultiSelect(
                                                  context,
                                                  subjects,
                                                  levels,
                                                  db,
                                                  userNotifier,
                                                  () => _update());
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    SettingsSection(
                                      title: const Text(
                                          'Security & Account Settings'),
                                      tiles: <SettingsTile>[
                                        SettingsTile(
                                          leading: const Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                          ),
                                          title: const Text('Delete Account'),
                                          onPressed: (context) {
                                            var currentUser = FirebaseAuth
                                                .instance.currentUser;

                                            // set up the buttons
                                            Widget cancelButton = TextButton(
                                              style: ButtonStyle(
                                                  overlayColor:
                                                      MaterialStatePropertyAll(
                                                          kSaraLightPink)),
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            );
                                            Widget confirmButton = TextButton(
                                              style: ButtonStyle(
                                                  overlayColor:
                                                      MaterialStatePropertyAll(
                                                          kSaraLightPink)),
                                              child: Text('Confirm',
                                                  style: TextStyle(
                                                      color: kDeepGreen)),
                                              onPressed: () async {
                                                Navigator.of(context)
                                                    .pushNamed("logIn");
                                                await currentUser?.delete();
                                                await currentUser?.reload();
                                              },
                                            );
                                            // set up the AlertDialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                Widget dialog =
                                                    io.Platform.isAndroid ==
                                                            true
                                                        ? AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0)),
                                                            title: const Text(
                                                                "Delete Account"),
                                                            content: const Text(
                                                                "Are you sure you would like to delete your account?"),
                                                            actions: [
                                                              cancelButton,
                                                              confirmButton,
                                                            ],
                                                          )
                                                        : CupertinoAlertDialog(
                                                            title: const Text(
                                                                'This action is irreversible. Are you sure?'),
                                                            actions: [
                                                              CupertinoDialogAction(
                                                                /// This parameter indicates this action is the default,
                                                                /// and turns the action's text to bold text.
                                                                isDefaultAction:
                                                                    true,
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'Cancel'),
                                                              ),
                                                              CupertinoDialogAction(
                                                                /// This parameter indicates the action would perform
                                                                /// a destructive action such as deletion, and turns
                                                                /// the action's text color to red.
                                                                isDestructiveAction:
                                                                    true,
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          "logIn");
                                                                  await currentUser
                                                                      ?.delete();
                                                                  await currentUser
                                                                      ?.reload();
                                                                },
                                                                child: const Text(
                                                                    'Confirm'),
                                                              ),
                                                            ],
                                                          );
                                                // show the dialog
                                                return dialog;
                                              },
                                            );
                                          },
                                        ),
                                        SettingsTile.switchTile(
                                          onToggle: (value) {},
                                          initialValue: true,
                                          leading: const Icon(Icons.security),
                                          title: const Text(
                                              'Allow activity sharing'),
                                        ),
                                        SettingsTile(
                                          leading: const Icon(Icons.logout,
                                              color: Colors.red),
                                          title: const Text('Log out'),
                                          onPressed: (context) => {
                                            Auth().signOut(),
                                            Get.offAndToNamed(
                                                PageRoutes.loginRegister)
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SafeArea(
                                  child: Column(
                                children: [
                                  SizedBox(
                                    width: 300.w,
                                    child: Center(
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                            text: 'Study Sprint\'s ',
                                            style:
                                                TextStyle(color: Colors.black),
                                            children: [
                                              TextSpan(
                                                text: 'GDPR Privacy',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              TextSpan(text: ' and '),
                                              TextSpan(
                                                text: 'Open Source Software',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'App version 1.0.0',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ))
                            ],
                          ),
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

late int studentLevel;
// late List userInterests;
List<dynamic> _selectedInterests = [];
// var userInterests = [];

/// displays multi select list for interest and level selection
_showMultiSelect(
    BuildContext context,
    List subjectsList,
    List<String> levelsList,
    DatabaseManager db,
    UserNotifier userNotifier,
    Function onComplete) {

  List<dynamic> userInterests = userNotifier.userInterests;
  if(userInterests.isEmpty){
    userInterests= userNotifier.getInterests();
  }
  studentLevel = userNotifier.studentLevel;

  {
    showModalBottomSheet(
      isScrollControlled: true,
      // required for min/max child size
      constraints: BoxConstraints(maxHeight: 650.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setState) {
          return Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Image.asset(
                      'assets/icons/star.png',
                      width: 50,
                      height: 50,
                      color: kSaraLightPink,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: Text(
                      'Personalise your experience',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Text(
                    'Select Interests',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kDeepGreen,
                        fontSize: 32,
                        fontFamily: 'Roboto'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    width: 320.w,
                    child: const Text(
                      'You will be offered appropriate courses and groups of '
                      'interrelated courses for a full immersion in the noted area of interest',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      width: 280.w,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(children: [
                          TextSpan(
                              text:
                                  'Allowable time limit for full time students is ',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: '20 hours per week',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ]),
                      )),
                ],
              ),
              Divider(
                color: kDeepGreen.withOpacity(0.2),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: MultiSelectChipField(
                    // showHeader: false,
                    title: const Text('Subject Areas'),
                    headerColor: Colors.white,
                    selectedChipColor: kTeal,
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                    items:
                        subjectsList.map((e) => MultiSelectItem(e, e)).toList(),
                    initialValue: userInterests,
                    onTap: (values) {
                      setState(() {
                        _selectedInterests = values;
                      });
                    }),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/speedometer.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Student\'s Level',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: ChipsChoice<int>.single(
                      value: studentLevel,
                      onChanged: (val) {
                        setState(() {
                          studentLevel = val;
                        });
                      },
                      // print(tag);
                      choiceItems: C2Choice.listFrom<int, String>(
                        source: levelsList,
                        value: (i, v) => i,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                      ),
                      choiceCheckmark: true,
                      choiceStyle: C2ChipStyle.outlined(
                        overlayColor: kSaraLightPink,
                        color: kSaraAccent,
                        foregroundStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        borderStyle: BorderStyle.solid,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        selectedStyle: C2ChipStyle.filled(
                          overlayColor: kSaraLightPink,
                          height: 35,
                          color: const Color(0xffffd0ef),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    ).whenComplete(() {
      print('final interests: $_selectedInterests');
      userNotifier.userInterests = _selectedInterests;
      db.updateUserInterests(userNotifier, _selectedInterests);
      db.updateStudentLevel(userNotifier, studentLevel);
      onComplete.call();
      // print('user interests: ${userNotifier.userInterests}');
      // print('user levels: ${userNotifier.skillLevel}');
    });
  }
  return studentLevel;
}

///Encapsulates skill level pills for multi select skill list
Widget getLevelPill(int count) {
  Widget levelPill = Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), color: kSaraLightPink),
    child: Text(
      count == 0
          ? 'Beginner'
          : count == 1
              ? 'Intermediate'
              : 'Advanced',
      style: TextStyle(fontWeight: FontWeight.w500),
    ),
  );

  return levelPill;
}

/// [EditImageOptionsItem] encapsulates the controls for editing the user image
class EditImageOptionsItem extends StatelessWidget {
  final String text;
  final Function onPressed;

  const EditImageOptionsItem({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  /// Builds UI elements for editing images after clicking on avatar image
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return TextButton(
      style: ButtonStyle(
          overlayColor: MaterialStateColor.resolveWith(
              (states) => kSelected.withOpacity(0.5)),
          minimumSize: MaterialStateProperty.all(
              Size(double.infinity, screenHeight * 0.065))),
      onPressed: () => onPressed.call(),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
/// [PhotoAvatar] encapsulates avatar image display
class PhotoAvatar extends StatelessWidget {
  final String image;

  const PhotoAvatar({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CircleAvatar(
          radius: 45,
          backgroundColor: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: CachedNetworkImage(
              imageUrl: image,
              placeholder: (context, url) {
                return const CircularProgressIndicator();
              },
              errorWidget: (context, url, error) => const Icon(
                Icons.person,
                color: Colors.grey,
              ),
            ),
          )),
      Positioned(
          bottom: 0,
          right: 5,
          child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(
                Icons.camera_alt,
                size: 20,
                color: kPrimaryColour,
              )))
    ]);
  }
}
