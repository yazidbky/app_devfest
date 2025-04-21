import 'package:app_devfest/components/customButton.dart';
import 'package:app_devfest/home/home.dart';
import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Image.asset('assets/images/logo2.png'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Image.asset('assets/images/check.png'),
                ),
              ),
              Text(
                'The process has been',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 15),
              ),
              Text(
                'Completed',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.5),
              CustomButton(
                text: 'Back To home',
                borderColor: mainColor,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
