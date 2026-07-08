import 'package:flutter/material.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

enum DsButtonType { primary, outline }

enum DsButtonSize { small, medium, large }

/// Pill button from Figma `MButtonPill` (Design System V2 Mobile).
class DsButton extends StatefulWidget {
  const DsButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = DsButtonType.primary,
    this.size = DsButtonSize.large,
    this.showLeadingIcon = false,
    this.showTrailingIcon = false,
    this.isLoading = false,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final DsButtonType type;
  final DsButtonSize size;

  /// Shows [DsIconName.alinearAdd4x] on the left (Figma `A Linear/Add`).
  final bool showLeadingIcon;

  /// Shows [DsIconName.alinearAdd4x] on the right (Figma `A Linear/Add`).
  final bool showTrailingIcon;

  final bool isLoading;

  /// When true, the button stretches to the full width of its parent.
  final bool expanded;

  @override
  State<DsButton> createState() => _DsButtonState();
}

class _DsButtonState extends State<DsButton> {
  bool _pressed = false;

  bool get _isDisabled => widget.onPressed == null && !widget.isLoading;

  bool get _isInteractive =>
      widget.onPressed != null && !widget.isLoading && !_isDisabled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final metrics = _DsButtonMetrics.forSize(widget.size);
    final palette = _DsButtonPalette.resolve(
      colors: colors,
      type: widget.type,
      pressed: _pressed && _isInteractive,
      disabled: _isDisabled,
      loading: widget.isLoading,
    );
    final hasLeading = widget.showLeadingIcon || widget.isLoading;
    final hasTrailing = widget.showTrailingIcon;
    final padding = metrics.padding(
      hasLeading: hasLeading,
      hasTrailing: hasTrailing,
      textOnly: !hasLeading && !hasTrailing,
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
          width: widget.expanded ? double.infinity : null,
          constraints: BoxConstraints(
            minWidth: metrics.minWidth(
              textOnly: !hasLeading && !hasTrailing,
            ),
            minHeight: metrics.minHeight ?? 0,
          ),
          padding: padding,
          decoration: BoxDecoration(
            color: palette.background,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: palette.borderColor == null
                ? null
                : Border.all(
                    color: palette.borderColor!,
                    width: AppStroke.s,
                  ),
          ),
          child: Row(
            mainAxisSize:
                widget.expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading) ...[
                SizedBox(
                  width: metrics.iconSize,
                  height: metrics.iconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: palette.foreground,
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
              ] else if (widget.showLeadingIcon) ...[
                DsIcon(
                  name: DsIconName.alinearAdd4x,
                  size: metrics.iconSize,
                  color: palette.foreground,
                ),
                SizedBox(width: AppSpacing.xs),
              ],
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: metrics.fontSize,
                  fontWeight: AppTypography.fontWeightSemibold,
                  height: metrics.lineHeight / metrics.fontSize,
                  letterSpacing: metrics.letterSpacing,
                  color: palette.foreground,
                ),
              ),
              if (widget.showTrailingIcon) ...[
                SizedBox(width: AppSpacing.xs),
                DsIcon(
                  name: DsIconName.alinearAdd4x,
                  size: metrics.iconSize,
                  color: palette.foreground,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DsButtonMetrics {
  const _DsButtonMetrics({
    required this.fontSize,
    required this.lineHeight,
    required this.letterSpacing,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.iconPaddingInner,
    required this.iconPaddingOuter,
    required this.minWidthTextOnly,
    required this.minHeight,
    required this.iconSize,
  });

  final double fontSize;
  final double lineHeight;
  final double letterSpacing;
  final double verticalPadding;
  final double horizontalPadding;
  final double iconPaddingInner;
  final double iconPaddingOuter;
  final double minWidthTextOnly;
  final double? minHeight;
  final double iconSize;

  static _DsButtonMetrics forSize(DsButtonSize size) {
    return switch (size) {
      DsButtonSize.large => const _DsButtonMetrics(
          fontSize: AppFont.sizeL,
          lineHeight: AppFont.lineheightL,
          letterSpacing: 0,
          verticalPadding: AppPadding.s,
          horizontalPadding: AppPadding.xl,
          iconPaddingInner: AppPadding.m,
          iconPaddingOuter: AppPadding.xl,
          minWidthTextOnly: AppWidth.l,
          minHeight: null,
          iconSize: AppIconSize.s,
        ),
      DsButtonSize.medium => const _DsButtonMetrics(
          fontSize: AppFont.sizeM,
          lineHeight: AppFont.lineheightM,
          letterSpacing: 0.5,
          verticalPadding: AppPadding.s,
          horizontalPadding: AppPadding.xl,
          iconPaddingInner: AppPadding.m,
          iconPaddingOuter: AppPadding.xl,
          minWidthTextOnly: 103,
          minHeight: null,
          iconSize: AppIconSize.s,
        ),
      DsButtonSize.small => const _DsButtonMetrics(
          fontSize: AppFont.sizeS,
          lineHeight: AppFont.lineheightS,
          letterSpacing: 0.03,
          verticalPadding: AppSpacing.xs,
          horizontalPadding: AppPadding.xl,
          iconPaddingInner: AppPadding.m,
          iconPaddingOuter: AppPadding.xl,
          minWidthTextOnly: AppWidth.s,
          minHeight: 28,
          iconSize: AppIconSize.s,
        ),
    };
  }

  double minWidth({required bool textOnly}) => textOnly ? minWidthTextOnly : 0;

  EdgeInsets padding({
    required bool hasLeading,
    required bool hasTrailing,
    required bool textOnly,
  }) {
    if (textOnly) {
      return EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      );
    }
    if (hasLeading && !hasTrailing) {
      return EdgeInsets.only(
        left: iconPaddingInner,
        right: iconPaddingOuter,
        top: verticalPadding,
        bottom: verticalPadding,
      );
    }
    if (hasTrailing && !hasLeading) {
      return EdgeInsets.only(
        left: iconPaddingOuter,
        right: iconPaddingInner,
        top: verticalPadding,
        bottom: verticalPadding,
      );
    }
    return EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    );
  }
}

class _DsButtonPalette {
  const _DsButtonPalette({
    required this.background,
    required this.foreground,
    this.borderColor,
  });

  final Color? background;
  final Color foreground;
  final Color? borderColor;

  static _DsButtonPalette resolve({
    required SemanticColors colors,
    required DsButtonType type,
    required bool pressed,
    required bool disabled,
    required bool loading,
  }) {
    if (type == DsButtonType.primary) {
      if (disabled || loading) {
        return _DsButtonPalette(
          background: colors.backgroundBrandSecondary4,
          foreground: colors.textBrandOnSecondary,
        );
      }
      if (pressed) {
        return _DsButtonPalette(
          background: colors.backgroundBrandSecondary3,
          foreground: colors.textBrandOnSecondary,
        );
      }
      return _DsButtonPalette(
        background: colors.backgroundBrandSecondary1,
        foreground: colors.textBrandOnSecondary,
      );
    }

    if (disabled) {
      return _DsButtonPalette(
        background: Colors.transparent,
        foreground: colors.textBrandSecondary3,
        borderColor: colors.borderBrandSecondary3,
      );
    }
    if (loading) {
      return _DsButtonPalette(
        background: Colors.transparent,
        foreground: colors.textBrandSecondary4,
        borderColor: colors.borderBrandSecondary4,
      );
    }
    if (pressed) {
      return _DsButtonPalette(
        background: Colors.transparent,
        foreground: colors.textBrandSecondary3,
        borderColor: colors.borderBrandSecondary3,
      );
    }
    return _DsButtonPalette(
      background: Colors.transparent,
      foreground: colors.textBrandSecondary1,
      borderColor: colors.borderBrandSecondary1,
    );
  }
}
