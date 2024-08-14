import 'package:flutter/material.dart';
import 'package:new_app/components/animation_mbutton.dart';
import 'package:new_app/drewer/Gift/gift_details.dart';
// Import the necessary package for MaterialButtonsAnimation if required



class TimerButton extends StatefulWidget {
  const TimerButton({super.key, required this.title});

  final String title;

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  int _start = 300;
  bool _buttonEnabled = false;
  bool _isTimerRunning = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_start > 0 && _isTimerRunning) {
        setState(() {
          _start--;
        });
        _startTimer();
      } else if (_start == 0) {
        setState(() {
          _buttonEnabled = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _isTimerRunning = false;
    super.dispose();
  }

  void _navigateToNextPage() {
    _isTimerRunning = false;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GiftPage()),
    );
  }

  void _navigateToNewPage() {
    _isTimerRunning = false;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GiftPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: GestureDetector(
          onTap: _navigateToNewPage,
          child: const Icon(Icons.home_mini),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Countdown: $_start',
              style: const TextStyle(color: Colors.amber),
            ),
            const SizedBox(height: 20),
            if (_buttonEnabled)
              MaterialButtonsAnimation(
                text: 'Select Your Seats to continue',
                containerheight: 50,
                containerwidth: 200,
                borderRadius: BorderRadius.circular(16),
                onTap: _navigateToNextPage,
                elevationsize: 20,
              ),
          ],
        ),
      ),
    );
  }
}


