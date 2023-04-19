import 'package:chips_choice/chips_choice.dart';
import 'package:course_select/shared_widgets/gradient_button.dart';
import 'package:course_select/utils/firebase_data_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../controllers/user_notifier.dart';
import '../utils/enums.dart';

/// Allows a user to select their interests and level after registering.
/// These then affect the content of the "for you" list on the home page
class SelectInterestsPage extends StatefulWidget {
  const SelectInterestsPage({Key? key}) : super(key: key);

  @override
  State<SelectInterestsPage> createState() => _SelectInterestsPageState();
}

class _SelectInterestsPageState extends State<SelectInterestsPage> {
  late final UserNotifier userNotifier;
  DatabaseManager db = DatabaseManager();
  late int studentLevel;
  var _selectedInterests = [];
  late List userInterests;

  /// Initialise controllers and get data for display on screen from database
  @override
  void initState() {
    userNotifier = Provider.of<UserNotifier>(context, listen: false);
    userInterests = userNotifier.getInterests();
    _selectedInterests = userInterests;
    studentLevel = userNotifier.studentLevel;
    super.initState();
  }


  /// Builds UI elements for display on the screen
  @override
  Widget build(BuildContext context) {
    List<String> subjects = SubjectArea.values
        .map((status) => status.toString().split('.').last)
        .map((str) => str.substring(0, 1).toUpperCase() + str.substring(1))
        .toList();

    List<String> levels = SkillLevel.values
        .map((status) => status.toString().split('.').last)
        .map((str) => str.substring(0, 1).toUpperCase() + str.substring(1))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: GradientButton(
          onPressed: () {
            db.updateUserInterests(userNotifier, _selectedInterests);
            db.updateStudentLevel(userNotifier, studentLevel);
            Navigator.of(context).pushNamed('home');
          },
          buttonText: 'start_l'.tr,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Animate(
                child: Image.asset(
                  'assets/icons/star.png',
                  width: 50,
                  height: 50,
                  color: kSaraLightPink,
                ),
              ).shimmer(duration: 100.ms)
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10),
              child: Text(
                'personal'.tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Text(
              'interest'.tr,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kDeepGreen,
                  fontSize: 32,
                  fontFamily: 'Roboto'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              width: 320.w,
              child: Text(
                'interest_hint'.tr,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 0),
                width: 280.w,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'time_allow'.tr,
                        style: const TextStyle(color: Colors.black)),
                    TextSpan(
                        text: 'time_limit'.tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ]),
                )),
            Divider(
              color: kDeepGreen.withOpacity(0.2),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: MultiSelectChipField(
                title: Text('subject_areas'.tr),
                headerColor: Colors.white,
                selectedChipColor: kTeal,
                selectedTextStyle: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                items: subjects.map((e) => MultiSelectItem(e, e)).toList(),
                initialValue: userInterests,
                onTap: (values) {
                  print('Selected interests: $values');
                  _selectedInterests = List.from(userInterests);
                  for (var value in values) {
                    if (_selectedInterests.contains(value)) {
                      _selectedInterests.remove(value);
                    } else {
                      _selectedInterests.add(value);
                    }
                  }
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: Row(
                    children: [
                      Image.asset('assets/icons/speedometer.png',width: 20, height: 20,),
                      const SizedBox(width: 8,),
                      Text('Skill_level'.tr, style: const TextStyle(fontSize: 18),),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: ChipsChoice<int>.single(
                    value: studentLevel,
                    onChanged: (val) {
                      setState((){
                        studentLevel = val;
                      });
                    },
                    // print(tag);
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: levels,
                      value: (i, v) => i,
                      label: (i, v) => v,
                      tooltip: (i, v) => v,
                    ),
                    choiceCheckmark: true,
                    choiceStyle: C2ChipStyle.outlined(
                      overlayColor: kSaraLightPink,
                      color: kSaraAccent,
                      foregroundStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      borderStyle: BorderStyle.solid,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(15)
                      ),
                      selectedStyle:  C2ChipStyle.filled(
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
        ),
      ),
    );
  }
}
