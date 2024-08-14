import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_app/components/fortune_wheel_screen.dart';

class GiftPage extends StatefulWidget {
  const GiftPage({super.key,});

  @override
  GiftPageState createState() => GiftPageState();
}

class GiftPageState extends State<GiftPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/gift2.png',
      'title': '',
      'description': 'Welcome to RideNow Your premier choice for convenient and reliable transportation.then get your gift'.tr(),
    },
    {
      'image': 'assets/images/egg.png',
      'title': 'Explore Features'.tr(),
      'description': 'Discover and enjoy the gift features of the app'.tr(),
    },
    {
      'image': 'assets/images/wheel.png',
      'title': 'Get Started'.tr(),
      'description': 'Spin your way to happiness with our gift'.tr(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPageContent(
                content: onboardingData[index],
              );
            },
          ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    onboardingData.length,
                    (int index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 10,
                      width: (index == _currentPage) ? 30 : 10,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: (index == _currentPage)
                            ? Colors.amber
                            : Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _currentPage != onboardingData.length - 1
                    ? ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Icon(Icons.arrow_forward),
                      )
                    : ElevatedButton(
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
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                                            child: Image.asset(
                                              "assets/images/background.jpg",
                                              fit: BoxFit.cover,
                                            ),
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
                          );
                        },
                        child: Text('Get Started'.tr()),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Individual onboarding page content
class OnboardingPageContent extends StatelessWidget {
  final Map<String, String> content;

  const OnboardingPageContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(content['image']!),
        const SizedBox(height: 30),
        Text(
          content['title']!,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          content['description']!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
