import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFieldPassword extends StatelessWidget {
  final TextEditingController passwordController;
  final String text, hintText;
  final bool obscureText;
  CustomTextFieldPassword(
      {super.key,
      required this.passwordController,
      required this.text,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        // Password TextField
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
              suffixText: 'Show',
              suffixStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              hintText: hintText,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          obscureText: obscureText,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}