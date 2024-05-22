import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_app/components/fortune_wheel_screen.dart';

class GiftPage extends StatefulWidget {
  const GiftPage({super.key});

  @override
  GiftPageState createState() => GiftPageState();
}

class GiftPageState extends State<GiftPage> {
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': '',
      'description':
          'Welcome to RideNow Your premier choice for convenient and reliable transportation.then get your gift'
              .tr(),
      'image': 'assets/images/gift2.png',
    },
    {
      'title': 'Explore Features'.tr(),
      'description': 'Discover and enjoy the gift features of the app'.tr(),
      'image': 'assets/images/egg.png',
    },
    {
      'title': 'Get Started'.tr(),
      'description': 'Spin your way to happiness with our gift'.tr(),
      'image': 'assets/images/wheel.png',
    },
  ];

  void _nextPage() {
    if (_currentIndex < _onboardingData.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Navigate to home screen or next page
    }
  }

  void _skip() {
    setState(() {
      _currentIndex = _onboardingData.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(_onboardingData[_currentIndex]['image']!),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Text(
              _onboardingData[_currentIndex]['title']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Text(
              _onboardingData[_currentIndex]['description']!,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      bottomSheet: _currentIndex != _onboardingData.length - 1
          ? BottomActionButtons(
              onNext: _nextPage,
              onSkip: _skip,
            )
          : TextButton(
              child: Text('Get Started'.tr()),
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (builder) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 200,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Material(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Image.asset(
                                      "assets/images/background.jpg",
                                      fit: BoxFit.cover),
                                ),
                                const Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: WheelScreen(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ); // Navigate to home screen or next page
              },
            ),
    );
  }
}

class BottomActionButtons extends StatefulWidget {
  final Function onNext;
  final Function onSkip;

  const BottomActionButtons(
      {super.key, required this.onNext, required this.onSkip});

  @override
  State<BottomActionButtons> createState() => _BottomActionButtonsState();
}

class _BottomActionButtonsState extends State<BottomActionButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            child: Text('SKIP'.tr()),
            onPressed: () => widget.onSkip(),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward,color: Colors.amber,),
            onPressed: () => widget.onNext(),
          ),
        ],
      ),
    );
  }
}
