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
      'buttonText': 'Select ',
      'buttonTextSelected': 'Selected ',
    },
    {
      'text': 'Material',
      'subText': 'Need material support?',
      'buttonText': 'Select ',
      'buttonTextSelected': 'Selected ',
    },
  ];

  // Change from Set to String to track a single selection
  String? selectedOption;

  void toggleOption(String option) {
    setState(() {
      // If the option is already selected, deselect it
      if (selectedOption == option) {
        selectedOption = null;
      } else {
        // Otherwise, select this option (and automatically deselect any other)
        selectedOption = option;
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
                              iconColor: selectedOption == firstOption['text']!
                                  ? Colors.white
                                  : mainColor,
                              textColor: selectedOption == firstOption['text']!
                                  ? mainColor
                                  : Colors.white,
                              subTextColor:
                                  selectedOption == firstOption['text']!
                                      ? Colors.white
                                      : mainColor,
                              backgourndColor:
                                  selectedOption == firstOption['text']!
                                      ? mainColor
                                      : Colors.white,
                              buttontextColor:
                                  selectedOption == firstOption['text']!
                                      ? mainColor
                                      : Colors.white,
                              borderColor: mainColor,
                              text: firstOption['text']!,
                              subText: firstOption['subText']!,
                              buttonText: selectedOption == firstOption['text']!
                                  ? firstOption['buttonTextSelected']!
                                  : firstOption['buttonText']!,
                              buttonColor:
                                  selectedOption == firstOption['text']!
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
                                iconColor:
                                    selectedOption == secondOption['text']!
                                        ? Colors.white
                                        : mainColor,
                                textColor:
                                    selectedOption == secondOption['text']!
                                        ? mainColor
                                        : Colors.white,
                                subTextColor:
                                    selectedOption == secondOption['text']!
                                        ? Colors.white
                                        : mainColor,
                                backgourndColor:
                                    selectedOption == secondOption['text']!
                                        ? mainColor
                                        : Colors.white,
                                buttontextColor:
                                    selectedOption == secondOption['text']!
                                        ? mainColor
                                        : Colors.white,
                                borderColor: mainColor,
                                text: secondOption['text']!,
                                subText: secondOption['subText']!,
                                buttonText:
                                    selectedOption == secondOption['text']!
                                        ? secondOption['buttonTextSelected']!
                                        : secondOption['buttonText']!,
                                buttonColor:
                                    selectedOption == secondOption['text']!
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
                  if (selectedOption != null) {
                    print('Selected option: $selectedOption');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SinistrePics(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select an accident type'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
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
