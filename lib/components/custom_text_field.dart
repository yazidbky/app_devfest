import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text, hintText;
  final TextInputType keyboardType;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.text,
      required this.hintText,
      required this.keyboardType});

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
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
