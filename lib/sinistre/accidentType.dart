import 'package:app_devfest/components/customButton.dart';
import 'package:app_devfest/sinistre/pictures.dart';
import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_devfest/components/guaranteesAndOptions.dart';

class Accidenttype extends StatefulWidget {
  const Accidenttype({super.key});

  @override
  State<Accidenttype> createState() => _AccidenttypeState();
}

class _AccidenttypeState extends State<Accidenttype> {
  final List<Map<String, String>> guaranteeOptions = [
    {
      'text': 'Mechanic',
      'subText': 'Issues with your car?',
      'buttonText': 'Select Mechanic',
    },
    {
      'text': 'Material',
      'subText': 'Need material support?',
      'buttonText': 'Select Material',
    },
  ];

  Set<String> selectedOptions = {}; // Local state for selected options

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(child: Image.asset('assets/images/logo2.png')),
              ),
              Container(
                color: Colors.blue[100],
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Welcome Abbad Hadjab\n'
                  'We wish that you are in a good health condition.\n'
                  'We really care about your safety. Please\n'
                  'be patient and follow the steps.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'What is the type of the accident?',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: List.generate(
                  (guaranteeOptions.length / 2).ceil(),
                  (index) {
                    final firstOption = guaranteeOptions[index * 2];
                    final secondOption = index * 2 + 1 < guaranteeOptions.length
                        ? guaranteeOptions[index * 2 + 1]
                        : null;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GuaranteesAndOptions(
                              iconColor:
                                  selectedOptions.contains(firstOption['text']!)
                                      ? Colors.white
                                      : mainColor,
                              textColor:
                                  selectedOptions.contains(firstOption['text']!)
                                      ? mainColor
                                      : Colors.white,
                              subTextColor:
                                  selectedOptions.contains(firstOption['text']!)
                                      ? Colors.white
                                      : mainColor,
                              backgourndColor:
                                  selectedOptions.contains(firstOption['text']!)
                                      ? mainColor
                                      : Colors.white,
                              buttontextColor:
                                  selectedOptions.contains(firstOption['text']!)
                                      ? mainColor
                                      : Colors.white,
                              borderColor: mainColor,
                              text: firstOption['text']!,
                              subText: firstOption['subText']!,
                              buttonText: firstOption['buttonText']!,
                              buttonColor:
                                  selectedOptions.contains(firstOption['text']!)
                                      ? Colors.white
                                      : mainColor,
                              onPressed: () {
                                toggleOption(firstOption['text']!);
                              },
                            ),
                          ),
                        ),
                        if (secondOption != null)
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GuaranteesAndOptions(
                                iconColor: selectedOptions
                                        .contains(secondOption['text']!)
                                    ? Colors.white
                                    : mainColor,
                                textColor: selectedOptions
                                        .contains(secondOption['text']!)
                                    ? mainColor
                                    : Colors.white,
                                subTextColor: selectedOptions
                                        .contains(secondOption['text']!)
                                    ? Colors.white
                                    : mainColor,
                                backgourndColor: selectedOptions
                                        .contains(secondOption['text']!)
                                    ? mainColor
                                    : Colors.white,
                                buttontextColor: selectedOptions
                                        .contains(secondOption['text']!)
                                    ? mainColor
                                    : Colors.white,
                                borderColor: mainColor,
                                text: secondOption['text']!,
                                subText: secondOption['subText']!,
                                buttonText: secondOption['buttonText']!,
                                buttonColor: selectedOptions
                                        .contains(secondOption['text']!)
                                    ? Colors.white
                                    : mainColor,
                                onPressed: () {
                                  toggleOption(secondOption['text']!);
                                },
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Next',
                borderColor: mainColor,
                onPressed: () {
                  print('Next button pressed');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SinistrePics(),
                    ),
                  );
                },
                color: mainColor,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
