
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/file.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
           Positioned(
            bottom: 200,
            left: 150,
            child: Text(
              'NO Files'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 29,
              ),
            ),
          ),
           Positioned(
            bottom: 50,
            left: 0,
            child: Text(
              'Oops! The file you are \n'
              'looking for cannot be found...'.tr(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
