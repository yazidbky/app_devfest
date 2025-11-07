import 'package:app_devfest/local%20storage/save_userID.dart';
import 'package:flutter/material.dart';
import 'package:app_devfest/registration_of_assurance/Registre/registre_screen.dart';
import 'package:app_devfest/registration_of_assurance/add%20files/addFiles.dart';
import 'package:app_devfest/registration_of_assurance/confirmation%20identity/confirmation.dart';
import 'package:app_devfest/registration_of_assurance/plans/plans.dart';

class HorizontalStepper extends StatefulWidget {
  const HorizontalStepper({super.key});

  @override
  _HorizontalStepperState createState() => _HorizontalStepperState();
}

class _HorizontalStepperState extends State<HorizontalStepper> {
  int _currentStep = 0;
  late PageController _pageController;
  late List<Widget> _steps;
  final ScrollController _scrollController = ScrollController();

  String _carType = '';
  int _cv = 0;
  String _usage = '';
  int _carYear = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _updateSteps(); // Initialize steps with current data
  }

  void _updateSteps() {
    _steps = [
      RegistreScreen(
        stepsLength: 4,
        stepContinue: _stepContinue,
        stepCancel: _stepCancel,
        currentStep: _currentStep,
      ),
      FutureBuilder<String>(
        future: getUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return AddFiles(
              stepsLength: 4,
              stepContinue: _stepContinue,
              stepCancel: _stepCancel,
              currentStep: _currentStep,
              userId: snapshot.data,
              onCarDetailsSubmitted: (type, cv, usage, year) {
                setState(() {
                  _carType = type;
                  _cv = cv;
                  _usage = usage;
                  _carYear = year;
                });
              },
            );
          }
        },
      ),
      IdentityConfirmation(
        stepsLength: 4,
        stepContinue: _stepContinue,
        stepCancel: _stepCancel,
        currentStep: _currentStep,
      ),
      Plans(
        stepsLength: 4,
        stepContinue: _stepContinue,
        stepCancel: _stepCancel,
        currentStep: _currentStep,
        carType: _carType,
        cv: _cv,
        usage: _usage,
        carYear: _carYear,
        key: ValueKey('plans-$_carType-$_cv-$_usage-$_carYear'), // Unique key
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _stepContinue() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
        _updateSteps(); // Rebuild steps with latest data
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _stepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _stepTap(int step) {
    setState(() {
      _currentStep = step;
    });
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logo2.png', height: 65),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _steps.length * 2 - 1,
                (index) {
                  if (index.isOdd) {
                    return Container(
                      width: 60,
                      height: 2,
                      color: Colors.grey,
                    );
                  }
                  final stepIndex = index ~/ 2;
                  return GestureDetector(
                    onTap: () => _stepTap(stepIndex),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: _currentStep == stepIndex
                              ? Colors.blue
                              : Colors.grey,
                          child: Text(
                            '${stepIndex + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              stretchTriggerOffset: 100,
              elevation: 0,
              expandedHeight: 160.0,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildStepper(),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Container(),
              ),
            ),
          ];
        },
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _steps,
          onPageChanged: (index) {
            setState(() {
              _currentStep = index;
            });
          },
        ),
      ),
    );
  }
}
