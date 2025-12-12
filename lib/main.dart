import 'package:flutter/material.dart';
import 'package:pocket_notes_practice_2/core/themes/app_theme.dart';
import 'package:pocket_notes_practice_2/features/notes/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _theme = ThemeMode.system;

  void _toggleTheme(ThemeMode themeMode) {
    setState(() {
      _theme = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _theme,
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      home: HomeScreen(toggleTheme: _toggleTheme),
    );
  }
}
