import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color, textColor;
  final Color borderColor;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.color,
    required this.borderColor,
    this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: borderColor)),
        minWidth: MediaQuery.of(context).size.width * 0.9,
        height: 60,
        color: color,
        child: Text(text,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: textColor)),
      ),
    );
  }
}
