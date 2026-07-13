import 'package:flutter/material.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';
import 'ds_button.dart';

/// Ghost button from Figma `MButtonGhost` (Design System V2 Mobile).
///
/// Transparent background, primary text/icon color, optional leading/trailing icon.
class DsButtonGhost extends StatefulWidget {
  const DsButtonGhost({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DsButtonSize.large,
    this.showLeadingIcon = false,
    this.showTrailingIcon = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final DsButtonSize size;

  /// Shows [DsIconName.alinearAdd] on the left (Figma `A Linear/Add`).
  final bool showLeadingIcon;

  /// Shows [DsIconName.alinearAdd] on the right (Figma `A Linear/Add`).
  final bool showTrailingIcon;

  @override
  State<DsButtonGhost> createState() => _DsButtonGhostState();
}

class _DsButtonGhostState extends State<DsButtonGhost> {
  bool _pressed = false;

  bool get _isDisabled => widget.onPressed == null;

  bool get _isInteractive => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final metrics = _DsButtonGhostMetrics.forSize(widget.size);
    final foreground = _DsButtonGhostPalette.resolve(
      colors: colors,
      pressed: _pressed && _isInteractive,
      disabled: _isDisabled,
    );

    return Semantics(
      button: true,
      enabled: _isInteractive,
      label: widget.label,
      child: GestureDetector(
        onTapDown: _isInteractive ? (_) => setState(() => _pressed = true) : null,
        onTapUp: _isInteractive ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: _isInteractive ? () => setState(() => _pressed = false) : null,
        onTap: _isInteractive ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.showLeadingIcon)
                DsIcon(
                  name: DsIconName.alinearAdd,
                  size: metrics.iconSize,
                  color: foreground,
                ),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: metrics.fontSize,
                  fontWeight: AppTypography.fontWeightSemibold,
                  height: metrics.lineHeight / metrics.fontSize,
                  letterSpacing: metrics.letterSpacing,
                  color: foreground,
                ),
              ),
              if (widget.showTrailingIcon)
                DsIcon(
                  name: DsIconName.alinearAdd,
                  size: metrics.iconSize,
                  color: foreground,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DsButtonGhostMetrics {
  const _DsButtonGhostMetrics({
    required this.fontSize,
    required this.lineHeight,
    required this.letterSpacing,
    required this.iconSize,
  });

  final double fontSize;
  final double lineHeight;
  final double letterSpacing;
  final double iconSize;

  static _DsButtonGhostMetrics forSize(DsButtonSize size) {
    return switch (size) {
      DsButtonSize.large => const _DsButtonGhostMetrics(
          fontSize: AppFont.sizeS,
          lineHeight: AppFont.lineheightS,
          letterSpacing: 0.25,
          iconSize: AppIconSize.m,
        ),
      DsButtonSize.medium => const _DsButtonGhostMetrics(
          fontSize: AppFont.sizeS,
          lineHeight: AppFont.lineheightS,
          letterSpacing: 0.25,
          iconSize: AppIconSize.s,
        ),
      DsButtonSize.small => const _DsButtonGhostMetrics(
          fontSize: AppFont.sizeS,
          lineHeight: AppFont.lineheightS,
          letterSpacing: 0.25,
          iconSize: AppIconSize.xs,
        ),
    };
  }
}

class _DsButtonGhostPalette {
  static Color resolve({
    required SemanticColors colors,
    required bool pressed,
    required bool disabled,
  }) {
    if (disabled) {
      return colors.textDisable2;
    }
    if (pressed) {
      return colors.textBrandPrimary3;
    }
    return colors.textBrandPrimary1;
  }
}
