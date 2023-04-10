import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../controllers/user_notifier.dart';
import '../utils/enums.dart';

class SelectInterestsPage extends StatefulWidget {
  const SelectInterestsPage({Key? key}) : super(key: key);

  @override
  State<SelectInterestsPage> createState() => _SelectInterestsPageState();
}

class _SelectInterestsPageState extends State<SelectInterestsPage> {
  late final UserNotifier userNotifier;

  @override
  void initState() {
    userNotifier = Provider.of<UserNotifier>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userInterests = userNotifier.getInterests();
    // var userLevels = userNotifier.studentLevel
    var _selectedInterests = [];
    var _selectedLevels = [];

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                      text: 'Allowable time limit for full time students is ',
                      style: TextStyle(color: Colors.black)),
                  TextSpan(
                      text: '10 hours per week',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ]),
              )),
          Divider(
            color: kDeepGreen.withOpacity(0.2),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: MultiSelectChipField(
              title: const Text('Subject Areas'),
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
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('home');
              },
              child: const Text("Start Learning!"))
        ],
      ),
    );

  }
}
