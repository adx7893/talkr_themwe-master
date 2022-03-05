// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:talkr_demo/pages/google_sign_in.dart';
import 'package:talkr_demo/screens/splash_screen.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences.getInstance(runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSignInProvider>(
            create: (context) => GoogleSignInProvider()),
      ],
      child: const MyApp(),
    ),
  ));
}

class SharedPreferences {
  static void getInstance(void runApp) {}
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<GoogleSignInProvider>(
              create: (_) => GoogleSignInProvider()),
        ],
        builder: (context, _) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        },
      );
}
