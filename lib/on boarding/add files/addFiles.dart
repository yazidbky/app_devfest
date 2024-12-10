import 'package:flutter/material.dart';

class AddFiles extends StatefulWidget {
  const AddFiles({super.key});

  @override
  State<AddFiles> createState() => _AddFilesState();
}

class _AddFilesState extends State<AddFiles> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        Container(
          height: screenHeight * 0.05,
          width: screenWidth,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                spreadRadius: 1, // Spread of the shadow
                blurRadius: 5, // Blur intensity of the shadow
                offset: const Offset(0, 3), // Shadow position (x, y)
              ),
            ],
          ),
        )
      ],
    );
  }
}
