import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_app/components/m_buttons.dart';
import 'package:new_app/components/setting_listtile.dart';
import 'package:new_app/components/text_add.dart';
import 'package:new_app/navigatinbar/profile_edt.dart';
import 'package:new_app/themes/NewMethord/ui_Provider.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class LocalizationChecker {
  static Future<void> changeLanguage(BuildContext context, Locale newLocale) async {
    await context.setLocale(newLocale);
  }
}

class SettingsState extends State<Settings> {
  bool _switch = true;
  Locale _currentLocale = const Locale('en', 'US');

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentLocale = context.locale;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        title: Text(
          "Settings".tr(),
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_list,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Account".tr(),
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SettingListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrifileEdt(
                        name: '',
                        email: '',
                        phone: '',
                        photo: '',
                      ),
                    ),
                  );
                },
                text: "Edit Profile".tr(),
                leadingicon: Icons.edit_outlined,
                leadingiconcolor: Colors.blueGrey,
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                text1: "App Settings".tr(),
                leadingiconcolor1: Colors.green,
                trailing1: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap1: () {
                  AppSettings.openAppSettings();
                },
                leadingicon1: Icons.phonelink_setup,
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.notifications_none,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Notification".tr(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.amber,
                        ),
                        title: Text(
                          "Notification".tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Switch(
                          value: _switch,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: Colors.green,
                          onChanged: (bool val) {
                            setState(() {
                              _switch = val;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.sunny,
                          color: Colors.grey,
                        ),
                        title: Text(
                          "Dark Mode".tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Consumer<UiProvider>(
                          builder: (context, UiProvider notifier, child) {
                            return Switch(
                              value: notifier.isDark,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              activeColor: Colors.green,
                              onChanged: (value) => notifier.changeTheme(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.expand_more,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "More".tr(),
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SettingListTile(
                text: "Language".tr(),
                onTap: () {},
                leadingicon: Icons.language_outlined,
                leadingiconcolor: Colors.blue,
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<Locale>(
                    value: _currentLocale,
                    items: const [
                      DropdownMenuItem<Locale>(
                        value: Locale('en', 'US'),
                        child: Text('English'),
                      ),
                      DropdownMenuItem<Locale>(
                        value: Locale('ta', 'IN'),
                        child: Text('Tamil'),
                      ),
                      DropdownMenuItem<Locale>(
                        value: Locale('ml', 'IN'),
                        child: Text('Malayalam'),
                      ),
                    ],
                    onChanged: (Locale? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _currentLocale = newValue;
                          LocalizationChecker.changeLanguage(context, newValue);
                        });
                      }
                    },
                  ),
                ),
                text1: "Dark Mode".tr(),
                leadingiconcolor1: Colors.grey,
                leadingicon1: Icons.dark_mode_outlined,
                trailing1: const Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              MaterialButtons(
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.black87,
                        elevation: 20,
                        title: TextEdt(
                          text: 'Sign Out Your Account'.tr(),
                          color: Colors.white,
                          fontSize: null,
                        ),
                        content: TextEdt(
                          text: 'Do you want to continue with sign out?'.tr(),
                          fontSize: null,
                          color: Colors.grey,
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MaterialButtons(
                                onTap: () {
                                  Navigator.of(context).pop(false);
                                },
                                elevationsize: 20,
                                text: 'Cancel'.tr(),
                                fontSize: 17,
                                containerheight: 40,
                                containerwidth: 100,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                onPressed: null,
                              ),
                              MaterialButtons(
                                onTap: () {
                                  _signOut();
                                  Navigator.of(context).pop();
                                },
                                elevationsize: 20,
                                text: 'Continue'.tr(),
                                fontSize: 17,
                                containerheight: 40,
                                containerwidth: 100,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                onPressed: null,
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
                containerheight: 40,
                borderRadius: BorderRadius.circular(10),
                meterialColor: Colors.white,
                text: 'Sign Out'.tr(),
                textcolor: Colors.red,
                elevationsize: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
