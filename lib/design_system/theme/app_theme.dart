import 'package:flutter/material.dart';

import '../tokens/semantic_colors.dart';
import '../tokens/typography_tokens.dart';

/// Builds Material [ThemeData] from Master Token semantic colors.
ThemeData buildAppTheme({required SemanticColors colors, Brightness brightness = Brightness.light}) {
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: colors.backgroundBrandPrimary1,
      onPrimary: colors.textBrandOnPrimary,
      secondary: colors.backgroundBrandSecondary1,
      onSecondary: colors.textBrandOnSecondary,
      error: colors.backgroundErrorPrimary,
      onError: colors.textOnError,
      surface: colors.backgroundPrimary,
      onSurface: colors.textPrimary,
    ),
    scaffoldBackgroundColor: colors.backgroundPrimary,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.sizeL,
        height: AppTypography.lineHeightL / AppTypography.sizeL,
        color: colors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.sizeM,
        height: AppTypography.lineHeightM / AppTypography.sizeM,
        color: colors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.sizeXl,
        fontWeight: AppTypography.fontWeightSemibold,
        height: AppTypography.lineHeightXl / AppTypography.sizeXl,
        color: colors.textPrimary,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.backgroundPrimary,
      foregroundColor: colors.textPrimary,
      elevation: 0,
    ),
    dividerColor: colors.dividerPrimary,
  );
}
