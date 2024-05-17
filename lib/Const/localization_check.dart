import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationChecker {
  static changeLanguge(BuildContext context) {
    Locale? currentLocale = EasyLocalization.of(context)!.currentLocale;
    if (currentLocale == const Locale('en', 'US')) {
      EasyLocalization.of(context)!.setLocale(const Locale('ta', 'IN'));
    } else if (currentLocale == const Locale('ta', 'IN')) {
      EasyLocalization.of(context)!.setLocale(const Locale('ml', 'IN'));
    } else {
      EasyLocalization.of(context)!.setLocale(const Locale('en', 'US'));
    }
  }
}