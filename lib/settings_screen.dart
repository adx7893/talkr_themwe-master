import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_manager.dart';

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeMode _groupValue;
  late ThemeManager _themeManager;

  @override
  void initState() {
    super.initState();
    _themeManager = Provider.of<ThemeManager>(context, listen: false);
    _groupValue = _themeManager.thememode;
  }

  void _updateTheme(ThemeMode themeMode) {
    _themeManager.themeMode = themeMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio(
                  onChanged: (val) => setState(() {
                    var val = ThemeMode.system;
                    _groupValue = val;
                    _updateTheme(val);
                  }),
                  value: ThemeMode.system,
                  groupValue: _groupValue,
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    var val = ThemeMode.system;
                    _groupValue = val;
                    _updateTheme(val);
                  }),
                  child: const Text(
                    "System Default",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio(
                  onChanged: (val) => setState(() {
                    var val = ThemeMode.light;
                    _groupValue = val;
                    _updateTheme(val);
                  }),
                  value: ThemeMode.light,
                  groupValue: _groupValue,
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    var val = ThemeMode.light;
                    _groupValue = val;
                    _updateTheme(val);
                  }),
                  child: const Text(
                    "Light Theme",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio(
                  onChanged: (val) => setState(() {
                    var val = ThemeMode.dark;
                    _groupValue = val;
                    _updateTheme(val);
                  }),
                  value: ThemeMode.dark,
                  groupValue: _groupValue,
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    var val = ThemeMode.dark;
                    _groupValue = val;
                    _updateTheme(val);
                  }),
                  child: const Text(
                    "Dark Theme",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}
