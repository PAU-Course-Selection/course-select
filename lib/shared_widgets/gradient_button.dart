import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final String buttonText;
  final dynamic onPressed;

  const GradientButton({Key? key, required this.buttonText, required this.onPressed}) : super(key: key);

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                colors: [
                  Color(0xff0DAB76),
                  Color(0xff408E91),

                ]
            )
        ),
        child: Center(
          child: Text(
              widget.buttonText,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto')),
        ),
      ),
    );
  }
}