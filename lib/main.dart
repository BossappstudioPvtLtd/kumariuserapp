import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_app/Appinfo/app_info.dart';
import 'package:new_app/onboarding.dart/on_boarding.dart';
import 'package:new_app/themes/NewMethord/ui_Provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
     options: const FirebaseOptions(
      apiKey: 'AIzaSyCH-K_JDF4Sfaa2EL7MKeD0PQ0jPfIQv98',
      appId: '1:1028914323103:android:b2429b3396633ec037ccaa',
      messagingSenderId: '1028914323103',
      projectId: 'bossapp-9fba7',
      authDomain: 'bossapp-9fba7.firebaseapp.com',
      storageBucket: 'bossapp-9fba7.appspot.com',
    ),
  );
  await Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
    if (valueOfPermission) {
      Permission.locationWhenInUse.request();
    }
  });

 


  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ta', 'IN'),
        Locale('ml', 'IN'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
   return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => AppInfo()),
    ChangeNotifierProvider(create: (context) => UiProvider()..init()),
  ],
  child: Consumer<UiProvider>(
    builder: (context, notifier, child) {
      return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'Flutter user app',
        themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
        darkTheme: notifier.isDark ? notifier.darkTheme : notifier.lightTheme,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 3, 22, 60),
          ),
          useMaterial3: true,
        ),
        home: const OnBoding(),
      );
    },
  ),
);

  }
}
