import 'package:flutter/material.dart';

class Stepper extends StatefulWidget {
  const Stepper({
    super.key,
    required int currentStep,
    required Null Function() onStepContinue,
    required onStepCancel,
    required List<Step> steps,
  });

  @override
  State<Stepper> createState() => _StepperState();
}

class _StepperState extends State<Stepper> {
  int currentStep = 0;
  List<Step> steps = const [
    Step(
      title: Text('Step 1'),
      content: Text('Content for Step 1'),
    ),
    Step(
      title: Text('Step 2'),
      content: Text('Content for Step 2'),
    ),
    Step(
      title: Text('Step 3'),
      content: Text('Content for Step 3'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stepper(
          
          currentStep: currentStep,
          onStepContinue: () {
            setState(() {
              if (currentStep < steps.length - 1) {
                currentStep += 1;
              } else {
                // Finish button pressed
                // You can perform any final actions here
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (currentStep > 0) {
                currentStep -= 1;
              } else {
                // Cancel button pressed on the first step
              }
            });
          },
          steps: steps,
        ),
        
      ],
    );
  }
}
