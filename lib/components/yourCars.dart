import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YourCars extends StatelessWidget {
  const YourCars({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.21,
        width: MediaQuery.of(context).size.width * 0.27,
        decoration: BoxDecoration(
            border: Border.all(
              color: mainColor,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/car.png'),
            Text(
              'Toyota',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 10, color: mainColor),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Text(
                  'claims',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      color: mainColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
