import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// [CategoryPill] encapsulates the pill button responsible for filtering courses by subject area in the course lists
class CategoryPill extends StatefulWidget {
  final Color bgColour;
  final Color iconBgColour;
  final IconData icon;
  final Color iconColour;
  final String text;
  final Function onTap;
  const CategoryPill({
    Key? key, required this.bgColour, required this.iconBgColour, required this.icon, required this.iconColour, required this.text, required this.onTap

  }) : super(key: key);

  @override
  State<CategoryPill> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryPill> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: ()=> widget.onTap.call(),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Container(
          decoration: BoxDecoration(
              color: widget.bgColour,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(143, 148, 251, .1),
                    blurRadius: 10.0,
                    offset: Offset(0, 5)
                ),
                BoxShadow(
                    color: Color.fromRGBO(143, 148, 251, .0),
                    blurRadius: 10.0,
                    offset: Offset(0, 5)
                )
              ]
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children:  [
              CircleAvatar(
                backgroundColor: widget.iconBgColour,
                  radius: 20,
                  child: Icon(widget.icon, color: widget.iconColour,)),
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Text(widget.text, style: const TextStyle( fontSize: 16, fontFamily: 'Roboto')),
              )
            ],
          ),
        ),
      ),
    );
  }
}