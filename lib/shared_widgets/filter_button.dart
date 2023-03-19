
import 'package:flutter/material.dart';

import '../screens/app_main_navigation.dart';
import 'constants.dart';

class FilterButton extends StatefulWidget {
  final Function onPressed;
  const FilterButton({
    Key? key,
    required bool isFilterVisible, required this.onPressed,
  }) : _isFilterVisible = isFilterVisible, super(key: key);

  final bool _isFilterVisible;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onPressed.call(),
      child: RaisedContainer(width: 50, bgColour: widget._isFilterVisible?kPrimaryColour:Colors.white,
        child: ImageIcon(const AssetImage('assets/icons/setting.png'), color: widget._isFilterVisible? Colors.white: kPrimaryColour),

      ),
    );
  }
}