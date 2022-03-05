import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkr_demo/screens/like_screen.dart';
import 'package:talkr_demo/theme_manager.dart';
import 'settings_screen.dart';

class DarkMode extends StatelessWidget {
  const DarkMode({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return MaterialApp(
      home: const LikeScreen(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeManager.thememode,
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        },
        tooltip: 'Settings',
        child: const Icon(Icons.dark_mode),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
