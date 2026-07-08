import 'package:flutter/material.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import 'ds_button.dart';

enum DsFloatingButtonShape { square, round }

/// Floating icon button from Figma `MButtonIcon` (square) and `MButtonFloatAction` (round).
///
/// Renders [DsIconName.alinearAdd4x] (Figma `A Linear/Add`) — 24px square, 32px round.
class DsFloatingButton extends StatefulWidget {
  const DsFloatingButton({
    super.key,
    this.onPressed,
    this.type = DsButtonType.primary,
    this.shape = DsFloatingButtonShape.round,
  });

  final VoidCallback? onPressed;
  final DsButtonType type;
  final DsFloatingButtonShape shape;

  /// Square floating button — Figma `MButtonIcon`.
  const DsFloatingButton.square({
    super.key,
    this.onPressed,
    this.type = DsButtonType.primary,
  }) : shape = DsFloatingButtonShape.square;

  /// Round floating button — Figma `MButtonFloatAction`.
  const DsFloatingButton.round({
    super.key,
    this.onPressed,
    this.type = DsButtonType.primary,
  }) : shape = DsFloatingButtonShape.round;

  @override
  State<DsFloatingButton> createState() => _DsFloatingButtonState();
}

class _DsFloatingButtonState extends State<DsFloatingButton> {
  bool _pressed = false;

  bool get _isDisabled => widget.onPressed == null;

  bool get _isInteractive => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final metrics = _DsFloatingButtonMetrics.forShape(widget.shape);
    final palette = _DsFloatingButtonPalette.resolve(
      colors: colors,
      type: widget.type,
      shape: widget.shape,
      pressed: _pressed && _isInteractive,
      disabled: _isDisabled,
    );

    return Semantics(
      button: true,
      enabled: _isInteractive,
      child: GestureDetector(
        onTapDown: _isInteractive ? (_) => setState(() => _pressed = true) : null,
        onTapUp: _isInteractive ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: _isInteractive ? () => setState(() => _pressed = false) : null,
        onTap: _isInteractive ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(AppPadding.m),
          decoration: BoxDecoration(
            color: palette.background,
            borderRadius: BorderRadius.circular(metrics.borderRadius),
            border: palette.borderColor == null
                ? null
                : Border.all(
                    color: palette.borderColor!,
                    width: AppStroke.s,
                  ),
          ),
          child: DsIcon(
            name: DsIconName.alinearAdd4x,
            size: metrics.iconSize,
            color: palette.foreground,
          ),
        ),
      ),
    );
  }
}

class _DsFloatingButtonMetrics {
  const _DsFloatingButtonMetrics({
    required this.borderRadius,
    required this.iconSize,
  });

  final double borderRadius;
  final double iconSize;

  static _DsFloatingButtonMetrics forShape(DsFloatingButtonShape shape) {
    return switch (shape) {
      DsFloatingButtonShape.square => const _DsFloatingButtonMetrics(
          borderRadius: AppRadius.xs,
          iconSize: AppIconSize.m,
        ),
      DsFloatingButtonShape.round => const _DsFloatingButtonMetrics(
          borderRadius: 30,
          iconSize: AppIconSize.xl,
        ),
    };
  }
}

class _DsFloatingButtonPalette {
  const _DsFloatingButtonPalette({
    required this.background,
    required this.foreground,
    this.borderColor,
  });

  final Color? background;
  final Color foreground;
  final Color? borderColor;

  static _DsFloatingButtonPalette resolve({
    required SemanticColors colors,
    required DsButtonType type,
    required DsFloatingButtonShape shape,
    required bool pressed,
    required bool disabled,
  }) {
    if (type == DsButtonType.primary) {
      if (disabled) {
        return _DsFloatingButtonPalette(
          background: shape == DsFloatingButtonShape.round
              ? colors.backgroundBrandSecondary3
              : colors.backgroundBrandSecondary4,
          foreground: colors.textBrandOnSecondary,
        );
      }
      if (pressed && shape == DsFloatingButtonShape.square) {
        return _DsFloatingButtonPalette(
          background: colors.backgroundBrandSecondary3,
          foreground: colors.textBrandOnSecondary,
        );
      }
      return _DsFloatingButtonPalette(
        background: colors.backgroundBrandSecondary1,
        foreground: colors.textBrandOnSecondary,
      );
    }

    if (disabled) {
      return _DsFloatingButtonPalette(
        background: Colors.transparent,
        foreground: colors.textBrandSecondary4,
        borderColor: colors.borderBrandSecondary4,
      );
    }
    if (pressed) {
      return _DsFloatingButtonPalette(
        background: Colors.transparent,
        foreground: colors.textBrandSecondary3,
        borderColor: colors.borderBrandSecondary3,
      );
    }
    return _DsFloatingButtonPalette(
      background: Colors.transparent,
      foreground: colors.textBrandSecondary1,
      borderColor: colors.borderBrandSecondary1,
    );
  }
}
