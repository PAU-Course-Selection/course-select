import 'package:course_select/shared_widgets/constants.dart';
import 'package:flutter/material.dart';

class CoursesFilter extends StatefulWidget {
  const CoursesFilter({Key? key}) : super(key: key);

  @override
  State<CoursesFilter> createState() => _CoursesFilterState();
}

class _CoursesFilterState extends State<CoursesFilter> {
  bool b1 = false;
  bool b2 = false;
  bool b3 = false;
  bool b4 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:  [
            GestureDetector(
              onTap: (){
                setState(() {
                  b1 = !b1;
                  b2 = false;
                  b3 = false;
                  b4 = false;
                });
              },
              child: CategoryButton(
                bgColour: b1? kSelected:Colors.white,
                iconBgColour: Colors.blue,
                icon: Icons.school_rounded,
                iconColour: Colors.white,
                text: 'All courses'
              ),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  b1 = false;
                  b2 = !b2 ;
                  b3 = false;
                  b4 = false;
                });
              },
              child: CategoryButton(
                bgColour: b2? kSelected: Colors.white,
                iconBgColour: Colors.orange,
                icon: Icons.child_care,
                iconColour: Colors.white,
                text: 'Beginner'
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:  [
            GestureDetector(
              onTap: (){
                setState(() {
                  b1 = false;
                  b2 = false;
                  b3 = !b3 ;
                  b4 = false;
                });
              },
              child: CategoryButton(
                bgColour: b3? kSelected: Colors.white,
                iconBgColour: Colors.pinkAccent,
                icon: Icons.sports_gymnastics,
                iconColour: Colors.white,
                text: 'Intermediate',
              ),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  b1 = false;
                  b2 = false;
                  b3 = false;
                  b4 = !b4 ;
                });
              },
              child: CategoryButton(
                bgColour: b4? kSelected: Colors.white,
                iconBgColour: Colors.green,
                icon: Icons.celebration,
                iconColour: Colors.white,
                text: 'Advanced',
              ),
            ),
          ],
        )
      ],
    );
  }
}

class CategoryButton extends StatelessWidget {
   final Color bgColour;
  final Color iconBgColour;
  final IconData icon;
  final Color iconColour;
  final String text;
  const CategoryButton({
    Key? key, required this.bgColour, required this.iconBgColour, required this.icon, required this.iconColour, required this.text

  }) : super(key: key);

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
            child: Text(text, style: const TextStyle( fontSize: 16, fontFamily: 'Roboto')),
          )
        ],
      ),
    );
  }
}
