import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreMadePacks extends StatelessWidget {
  final String headline, subHeadline, imagePath;
  const PreMadePacks({
    super.key,
    required this.headline,
    required this.subHeadline,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.5,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        border: Border.all(color: mainColor), // Use your mainColor
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2, // Allocate space for the text and button
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    headline,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subHeadline,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: mainColor),
                    ),
                    minWidth: screenWidth * 0.4,
                    height: 40,
                    color: mainColor,
                    child: Text(
                      'Use Offer',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2, // Allocate space for the image
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover, // Ensures the image fills the space properly
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
