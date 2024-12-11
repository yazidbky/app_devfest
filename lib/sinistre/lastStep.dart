import 'package:app_devfest/components/customButton.dart';
import 'package:app_devfest/sinistre/completeScreen.dart';
import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LastStep extends StatefulWidget {
  const LastStep({super.key});

  @override
  State<LastStep> createState() => _LastStepState();
}

class _LastStepState extends State<LastStep> {
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Last Step',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Can you please write a description of the sinistre?',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: TextField(
                controller: descriptionController,
                maxLines: null, // Allow unlimited lines
                expands:
                    true, // Make the text field take up as much space as possible
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                      'Description of the sinistre', // Hint text as label
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              textAlign: TextAlign.start,
              'this are some things to mention\n Conditions météorologiques et de visibilité au momentde laccident\n Description des dommvvages matériels pour chaque véhicule\nNoms et coordonnées des témoins éventuels\nDéclarations des témoins sur les circonstances de laccident.',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            CustomButton(
              text: 'valide',
              borderColor: mainColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompleteScreen(),
                    ));
              },
              color: mainColor,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
