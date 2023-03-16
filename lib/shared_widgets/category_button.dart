import 'package:flutter/cupertino.dart';

class CategoryButton extends StatefulWidget {
  final Color bgColour;
  final Color iconBgColour;
  final IconData icon;
  final Color iconColour;
  final String text;
  final Function onTap;
  const CategoryButton({
    Key? key, required this.bgColour, required this.iconBgColour, required this.icon, required this.iconColour, required this.text, required this.onTap

  }) : super(key: key);

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: ()=> widget.onTap.call(),
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
        width: screenWidth * 0.42,
        child: Row(
          children:  [
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: widget.iconBgColour,
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Icon(widget.icon, color: widget.iconColour,)),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(widget.text, style: const TextStyle( fontSize: 16, fontFamily: 'Roboto')),
            )
          ],
        ),
      ),
    );
  }
}