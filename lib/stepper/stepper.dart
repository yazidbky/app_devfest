import 'package:flutter/material.dart';

class HorizontalStepper extends StatefulWidget {
  final List<Widget> steps;
  final Function(int) onStepTapped;

  HorizontalStepper({required this.steps, required this.onStepTapped});

  @override
  _HorizontalStepperState createState() => _HorizontalStepperState();
}

class _HorizontalStepperState extends State<HorizontalStepper> {
  int _currentStep = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stepper Example'),
      ),
      body: Column(
        children: [
          // Horizontal stepper
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Add the line between circles
                return Container(
                  width: 30, // Adjust the width of the line
                  height: 2, // Thickness of the line
                  color: Colors.grey,
                );
              }
              final stepIndex = index ~/ 2;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentStep = stepIndex;
                  });
                  _pageController.animateToPage(stepIndex,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                  widget.onStepTapped(stepIndex); // Trigger the callback
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          _currentStep == stepIndex ? Colors.blue : Colors.grey,
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Step ${stepIndex + 1}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _currentStep == stepIndex
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          // Stepper content (PageView)
          Expanded(
            child: PageView(
              controller: _pageController,
              children: widget.steps,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
