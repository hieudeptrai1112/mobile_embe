import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';

/// Phone frame for component demos — inspired by Arco Design Mobile docs.
class ShowcasePhonePreview extends StatelessWidget {
  const ShowcasePhonePreview({
    super.key,
    required this.child,
    this.appTitle,
    this.width = 375,
    this.height = 680,
  });

  final Widget child;
  final String? appTitle;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    // On narrow screens the frame should not exceed available width.
    final maxWidth =
        MediaQuery.sizeOf(context).width - AppPadding.l * 2;
    final effectiveWidth = width.clamp(0.0, maxWidth);

    return Container(
      width: effectiveWidth,
      height: height,
      decoration: BoxDecoration(
        color: colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: colors.borderPrimary,
          width: AppStroke.s,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.overlayPrimary.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.s),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.backgroundPrimary,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: colors.borderPrimary, width: AppStroke.s),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(31),
          child: Column(
            children: [
              _PhoneStatusBar(colors: colors),
              if (appTitle != null) _PhoneAppBar(title: appTitle!, colors: colors),
              Expanded(
                child: ColoredBox(
                  color: colors.backgroundPrimary,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneStatusBar extends StatelessWidget {
  const _PhoneStatusBar({required this.colors});

  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.l),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.borderPrimary, width: AppStroke.s),
        ),
      ),
      child: Row(
        children: [
          Text(
            '9:41',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
              fontWeight: AppTypography.fontWeightSemibold,
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            'Design System',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeXs,
              color: colors.textSecondary,
            ),
          ),
          const Spacer(),
          Icon(Icons.signal_cellular_alt, size: 14, color: colors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Icon(Icons.wifi, size: 14, color: colors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Icon(Icons.battery_full, size: 14, color: colors.textSecondary),
        ],
      ),
    );
  }
}

class _PhoneAppBar extends StatelessWidget {
  const _PhoneAppBar({required this.title, required this.colors});

  final String title;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.l,
        vertical: AppPadding.m,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.borderPrimary, width: AppStroke.s),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: AppFont.sizeM,
          fontWeight: AppTypography.fontWeightSemibold,
          color: colors.textPrimary,
        ),
      ),
    );
  }
}
