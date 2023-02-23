import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final Color bgColour;
  final Color iconBgColour;
  final Color iconColour;
  final IconData icon;
  final text;

  const CategoryButton({Key? key, required this.iconBgColour, required this.icon, this.text, required this.bgColour, required this.iconColour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: bgColour,
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
      width: screenWidth * 0.42,
      child: Row(
        children:  [
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: iconBgColour,
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Icon(icon, color: iconColour,)),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(text, style: TextStyle( fontSize: 16, fontFamily: 'Roboto')),
          )
        ],
      ),
    );
  }
}
