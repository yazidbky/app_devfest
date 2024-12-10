import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GuaranteesAndOptions extends StatelessWidget {
  final Color? backgourndColor,
      textColor,
      subTextColor,
      buttontextColor,
      buttonColor,
      iconColor;
  final Color borderColor;
  final String text, subText, buttonText;
  final void Function()? onPressed;

  const GuaranteesAndOptions(
      {super.key,
      this.backgourndColor,
      this.textColor,
      this.subTextColor,
      this.buttontextColor,
      this.buttonColor,
      required this.borderColor,
      required this.text,
      required this.subText,
      required this.buttonText,
      this.onPressed,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.4,
      height: screenHeight * 0.55,
      decoration: BoxDecoration(
        color: backgourndColor,
        border: Border.all(color: mainColor), // Use your mainColor
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.car_crash,
            color: iconColor,
            size: 50,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textAlign: TextAlign.center,
              text,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textAlign: TextAlign.center,
              subText,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: subTextColor,
              ),
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              onPressed: onPressed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: borderColor)),
              minWidth: MediaQuery.of(context).size.width * 0.3,
              height: 40,
              color: buttonColor,
              child: Text(buttonText,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, color: buttontextColor)),
            ),
          ),
        ],
      ),
    );
  }
}
