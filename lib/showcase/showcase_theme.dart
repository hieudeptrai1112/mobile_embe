import 'package:flutter/material.dart';

class ShowcaseThemeScope extends InheritedWidget {
  const ShowcaseThemeScope({
    super.key,
    required this.themeMode,
    required this.toggleTheme,
    required super.child,
  });

  final ThemeMode themeMode;
  final VoidCallback toggleTheme;

  bool get isDark => themeMode == ThemeMode.dark;

  static ShowcaseThemeScope of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ShowcaseThemeScope>();
    assert(scope != null, 'ShowcaseThemeScope not found in widget tree');
    return scope!;
  }

  @override
  bool updateShouldNotify(ShowcaseThemeScope oldWidget) {
    return themeMode != oldWidget.themeMode;
  }
}

class ShowcaseThemeToggle extends StatelessWidget {
  const ShowcaseThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ShowcaseThemeScope.of(context);

    return IconButton(
      tooltip: scope.isDark ? 'Light theme' : 'Dark theme',
      onPressed: scope.toggleTheme,
      icon: Icon(scope.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
    );
  }
}
