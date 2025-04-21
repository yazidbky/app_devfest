import 'package:app_devfest/components/yourCars.dart';
import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(child: Image.asset('assets/images/logo2.png')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Welcome back',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w300, fontSize: 20),
              ),
            ),
            Image.asset('assets/images/homeimage.png'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'See Insured card ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300, fontSize: 20),
                  ),
                  Text(
                    'see all',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                        color: mainColor),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const YourCars(),
                  const YourCars(),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.21,
                      width: MediaQuery.of(context).size.width * 0.21,
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                          border: Border.all(
                            color: mainColor,
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: mainColor,
                            size: 30,
                          ),
                          Text(
                            'Add\nNew Car',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          )
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
