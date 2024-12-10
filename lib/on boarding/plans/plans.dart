import 'package:app_devfest/components/customButton.dart';
import 'package:app_devfest/components/guaranteesAndOptions.dart';
import 'package:app_devfest/components/offersCard.dart';
import 'package:app_devfest/components/preMadePacks.dart';
import 'package:app_devfest/on%20boarding/plans/selectedOptionsCubit.dart';
import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class Plans extends StatelessWidget {
  final List<Map<String, String>> items = [
    {'name': 'toyota yaris', 'price': '18000'},
    {'name': 'honda civic', 'price': '22000'},
    {'name': 'nissan altima', 'price': '20000'},
    {'name': 'total', 'price': '60000'},
  ];

  Plans({super.key});

  // Assuming you fetch guaranteeOptions from somewhere or initialize here
  List<Map<String, String>> guaranteeOptions = [
    {'text': 'Option 1', 'subText': 'Description 1', 'buttonText': 'Add'},
    {'text': 'Option 2', 'subText': 'Description 2', 'buttonText': 'Add'},
    {'text': 'Option 3', 'subText': 'Description 3', 'buttonText': 'Add'},
    {'text': 'Option 4', 'subText': 'Description 4', 'buttonText': 'Add'},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SelectedOptionsCubit(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Most Popular',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      OffersCard(),
                      OffersCard(),
                      OffersCard(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Column(
                  children: [
                    PreMadePacks(
                      headline: 'Headline',
                      imagePath: 'assets/images/pop.png',
                      subHeadline:
                          'Please add your content here\nKeep it short and simple\nAnd smile :) ',
                    ),
                    SizedBox(height: 20),
                    PreMadePacks(
                      headline: 'Headline',
                      imagePath: 'assets/images/pop.png',
                      subHeadline:
                          'Please add your content here\nKeep it short and simple\nAnd smile :) ',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BlocBuilder<SelectedOptionsCubit, Set<String>>(
                  builder: (context, selectedOptions) {
                    // Safely handle empty or null guaranteeOptions
                    if (guaranteeOptions.isEmpty) {
                      return Center(child: Text('No options available'));
                    }

                    return Column(
                      children: List.generate(
                        (guaranteeOptions.length / 2).ceil(),
                        (index) {
                          final firstOption = guaranteeOptions[index * 2];
                          final secondOption =
                              index * 2 + 1 < guaranteeOptions.length
                                  ? guaranteeOptions[index * 2 + 1]
                                  : null;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GuaranteesAndOptions(
                                    iconColor: selectedOptions
                                            .contains(firstOption['text']!)
                                        ? Colors.white
                                        : mainColor,
                                    textColor: selectedOptions
                                            .contains(firstOption['text']!)
                                        ? mainColor
                                        : Colors.white,
                                    subTextColor: selectedOptions
                                            .contains(firstOption['text']!)
                                        ? Colors.white
                                        : mainColor,
                                    backgourndColor: selectedOptions
                                            .contains(firstOption['text']!)
                                        ? mainColor
                                        : Colors.white,
                                    buttontextColor: selectedOptions
                                            .contains(firstOption['text']!)
                                        ? mainColor
                                        : Colors.white,
                                    borderColor: mainColor,
                                    text: firstOption['text']!,
                                    subText: firstOption['subText']!,
                                    buttonText: firstOption['buttonText']!,
                                    buttonColor: selectedOptions
                                            .contains(firstOption['text']!)
                                        ? Colors.white
                                        : mainColor,
                                    onPressed: () {
                                      context
                                          .read<SelectedOptionsCubit>()
                                          .toggleOption(firstOption['text']!);
                                    },
                                  ),
                                ),
                              ),
                              if (secondOption != null)
                                Expanded(
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
                                        context
                                            .read<SelectedOptionsCubit>()
                                            .toggleOption(
                                                secondOption['text']!);
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  children: items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['name']!,
                            style: GoogleFonts.poppins(
                              fontWeight: item['name'] == 'total'
                                  ? FontWeight.bold
                                  : FontWeight.w300,
                              color: item['name'] == 'total'
                                  ? mainColor
                                  : Colors.black38,
                            ),
                          ),
                          Text(
                            item['price']!,
                            style: GoogleFonts.poppins(
                              fontWeight: item['name'] == 'total'
                                  ? FontWeight.bold
                                  : FontWeight.w300,
                              color: item['name'] == 'total'
                                  ? mainColor
                                  : Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                CustomButton(
                  text: 'validate',
                  color: mainColor,
                  borderColor: mainColor,
                  textColor: Colors.white,
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
