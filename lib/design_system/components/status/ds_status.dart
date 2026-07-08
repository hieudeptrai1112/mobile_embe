import 'package:flutter/material.dart';

import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Visual style from Figma `ATagStatus` vs `ATagState`.
enum DsStatusStyle {
  /// Dot indicator + colored label (`ATagStatus`).
  status,

  /// Pill badge with background fill (`ATagState`).
  state,
}

/// Semantic color preset for status variants.
enum DsStatusVariant {
  neutral,
  warning,
  darkBlue,
  info,
  primary,
  success,
  error,
}

/// Status tag from Figma `ATagStatus` / `ATagState` (Design System V2 Mobile).
class DsStatus extends StatelessWidget {
  const DsStatus({
    super.key,
    required this.label,
    this.style = DsStatusStyle.status,
    this.variant = DsStatusVariant.neutral,
    this.description,
  });

  final String label;
  final DsStatusStyle style;
  final DsStatusVariant variant;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final palette = _DsStatusPalette.resolve(colors: colors, variant: variant);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        switch (style) {
          DsStatusStyle.status => _StatusDotRow(
              label: label,
              dotColor: palette.indicator,
              labelColor: palette.indicator,
            ),
          DsStatusStyle.state => _StatusPill(
              label: label,
              background: palette.background,
              labelColor: palette.foreground,
            ),
        },
        if (description != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            description!,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
              fontWeight: AppTypography.fontWeightRegular,
              height: AppFont.lineheightS / AppFont.sizeS,
              letterSpacing: 0.25,
              color: style == DsStatusStyle.status
                  ? palette.descriptionStatus
                  : palette.descriptionState,
            ),
          ),
        ],
      ],
    );
  }
}

class _StatusDotRow extends StatelessWidget {
  const _StatusDotRow({
    required this.label,
    required this.dotColor,
    required this.labelColor,
  });

  final String label;
  final Color dotColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppPadding.xs),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeS,
            fontWeight: AppTypography.fontWeightSemibold,
            height: AppFont.lineheightS / AppFont.sizeS,
            letterSpacing: 0.25,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.background,
    required this.labelColor,
  });

  final String label;
  final Color background;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.m,
        vertical: AppPadding.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: AppFont.sizeS,
          fontWeight: AppTypography.fontWeightSemibold,
          height: AppFont.lineheightS / AppFont.sizeS,
          letterSpacing: 0.25,
          color: labelColor,
        ),
      ),
    );
  }
}

class _DsStatusPalette {
  const _DsStatusPalette({
    required this.indicator,
    required this.background,
    required this.foreground,
    required this.descriptionStatus,
    required this.descriptionState,
  });

  final Color indicator;
  final Color background;
  final Color foreground;
  final Color descriptionStatus;
  final Color descriptionState;

  static _DsStatusPalette resolve({
    required SemanticColors colors,
    required DsStatusVariant variant,
  }) {
    return switch (variant) {
      DsStatusVariant.neutral => _DsStatusPalette(
          indicator: colors.borderDisable2,
          background: colors.backgroundDisable3,
          foreground: colors.borderDisable2,
          descriptionStatus: colors.textBrandPrimary1,
          descriptionState: colors.textPrimary,
        ),
      DsStatusVariant.warning => _DsStatusPalette(
          indicator: colors.backgroundWarningPrimary,
          background: colors.backgroundWarningTertiary,
          foreground: colors.backgroundWarningPrimary,
          descriptionStatus: colors.textBrandPrimary1,
          descriptionState: colors.textPrimary,
        ),
      DsStatusVariant.darkBlue => _DsStatusPalette(
          indicator: colors.textSecondary,
          background: colors.backgroundBrandPrimary4,
          foreground: colors.textSecondary,
          descriptionStatus: colors.textBrandPrimary1,
          descriptionState: colors.textPrimary,
        ),
      DsStatusVariant.info => _DsStatusPalette(
          indicator: colors.textBrandPrimary1,
          background: colors.backgroundSecondary,
          foreground: colors.textBrandPrimary1,
          descriptionStatus: colors.textBrandPrimary1,
          descriptionState: colors.textPrimary,
        ),
      DsStatusVariant.primary => _DsStatusPalette(
          indicator: colors.textBrandPrimary1,
          background: colors.backgroundBrandPrimary1,
          foreground: colors.textWhite,
          descriptionStatus: colors.textBrandPrimary1,
          descriptionState: colors.textPrimary,
        ),
      DsStatusVariant.success => _DsStatusPalette(
          indicator: colors.backgroundSuccessPrimary,
          background: colors.backgroundSuccessSecondary,
          foreground: colors.textWhite,
          descriptionStatus: colors.textBrandPrimary1,
          descriptionState: colors.textPrimary,
        ),
      DsStatusVariant.error => _DsStatusPalette(
          indicator: colors.backgroundErrorPrimary,
          background: colors.backgroundErrorSecondary,
          foreground: colors.textWhite,
          descriptionStatus: colors.textBrandPrimary1,
          descriptionState: colors.textPrimary,
        ),
    };
  }
}
