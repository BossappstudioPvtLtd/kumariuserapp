// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class StepperPage extends StatefulWidget {
  const StepperPage({super.key});

  @override
  _StepperPageState createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.vertical,
      currentStep: _currentStep,
      onStepContinue: () {
        setState(() {
          if (_currentStep < 2) {
            _currentStep += 1;
          } else {
            // Handle when stepper reaches the last step
          }
        });
      },
      onStepCancel: () {
        setState(() {
          if (_currentStep > 0) {
            _currentStep -= 1;
          } else {
            _currentStep = 0;
          }
        });
      },
      steps: <Step>[
        Step(
          title: const Text('Step 1',style:TextStyle(color: Colors.white70) ,),
          content: const Text('Content for Step 1'),
          isActive: _currentStep == 0,
        ),
        Step(
          title: const Text('Step 2',style:TextStyle(color: Colors.white70) ,),
          content: const Text('Content for Step 2'),
          isActive: _currentStep == 1,
        ),
        Step(
          title: const Text('Step 3',style:TextStyle(color: Colors.white70) ,),
          content: const Text('Content for Step 3'),
          isActive: _currentStep == 2,
        ),
      ],
    );
  }
}