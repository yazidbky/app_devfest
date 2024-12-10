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
            children: List.generate(widget.steps.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentStep = index;
                  });
                  _pageController.animateToPage(index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                  widget.onStepTapped(index); // Trigger the callback
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            _currentStep == index ? Colors.blue : Colors.grey,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Step ${index + 1}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              _currentStep == index ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
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
