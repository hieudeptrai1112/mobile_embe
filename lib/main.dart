import 'package:flutter/material.dart';

import 'design_system/design_system.dart';
import 'showcase/doc/showcase_doc_shell.dart';
import 'showcase/showcase_theme.dart';
import 'package:flutter_skill/flutter_skill.dart';

void main() {
  FlutterSkillBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseThemeScope(
      themeMode: _themeMode,
      toggleTheme: _toggleTheme,
      child: MaterialApp(
        title: 'DS App Biz',
        themeMode: _themeMode,
        theme: buildAppTheme(
          colors: SemanticColors.light,
          brightness: Brightness.light,
        ),
        darkTheme: buildAppTheme(
          colors: SemanticColors.dark,
          brightness: Brightness.dark,
        ),
        home: const ShowcaseDocShell(),
      ),
    );
  }
}
