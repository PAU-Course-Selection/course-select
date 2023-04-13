import 'package:course_select/constants/constants.dart';
import 'package:course_select/utils/enums.dart';
import 'package:flutter/material.dart';

class ColourPicker {
  Color selectSkillColor(String level) {
    Color color;
    level = "SkillLevel."+level;

    if (level == SkillLevel.beginner.toString()) {
      color = kLightGreen;
    } else if (level == SkillLevel.intermediate.toString()) {
      color = kLightYellow;
    } else if (level == SkillLevel.advanced.toString()) {
      color = kSaraAccent;
    } else {
      color = Colors.white;
    }

    return color;
  }
}
