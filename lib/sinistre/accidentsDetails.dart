import 'package:app_devfest/components/CustomTextField.dart';
import 'package:app_devfest/components/customButton.dart';
import 'package:app_devfest/sinistre/lastStep.dart';
import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccidentsDetails extends StatefulWidget {
  AccidentsDetails({super.key});

  @override
  _AccidentsDetailsState createState() => _AccidentsDetailsState();
}

class _AccidentsDetailsState extends State<AccidentsDetails> {
  TextEditingController locationController = TextEditingController();
  TextEditingController wilayaController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  bool isDrivable = false;
  bool isUndrivable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Accident Details Submission',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: locationController,
                text: 'Accident Location',
                hintText: 'Enter the city or area where the accident occurred',
              ),
              CustomTextField(
                controller: wilayaController,
                text: 'Wilaya',
                hintText: 'Enter le wilaya',
              ),
              CustomTextField(
                controller: dateController,
                text: 'Accident Date',
                hintText: 'dd/mm/yyyy',
              ),
              CustomTextField(
                controller: timeController,
                text: 'Accident Time',
                hintText: 'exp:10:30 am',
              ),
              const SizedBox(height: 20),
              const Text(
                'Vehicle Status',
                textAlign: TextAlign.left,
              ),
              CheckboxListTile(
                title: Text('Drivable'),
                activeColor: mainColor,
                value: isDrivable,
                onChanged: (bool? value) {
                  setState(() {
                    isDrivable = value ?? false;
                    // Ensuring that both checkboxes are mutually exclusive
                    if (isDrivable) {
                      isUndrivable = false;
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Undrivable'),
                activeColor: mainColor,
                value: isUndrivable,
                onChanged: (bool? value) {
                  setState(() {
                    isUndrivable = value ?? false;
                    // Ensuring that both checkboxes are mutually exclusive
                    if (isUndrivable) {
                      isDrivable = false;
                    }
                  });
                },
              ),
              CustomButton(
                text: 'Continue',
                textColor: Colors.white,
                color: const Color(0xFF394496),
                borderColor: const Color(0xFF394496),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LastStep(),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
