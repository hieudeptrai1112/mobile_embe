import 'package:flutter/material.dart';

import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';
import 'ds_button.dart';

/// Text link button from Figma `MButtonLink` (Design System V2 Mobile).
class DsButtonLink extends StatefulWidget {
  const DsButtonLink({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DsButtonSize.large,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final DsButtonSize size;
  final bool isLoading;

  @override
  State<DsButtonLink> createState() => _DsButtonLinkState();
}

class _DsButtonLinkState extends State<DsButtonLink> {
  bool _pressed = false;

  bool get _isDisabled => widget.onPressed == null && !widget.isLoading;

  bool get _isInteractive =>
      widget.onPressed != null && !widget.isLoading && !_isDisabled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final metrics = _DsButtonLinkMetrics.forSize(widget.size);
    final foreground = _DsButtonLinkPalette.resolve(
      colors: colors,
      pressed: _pressed && _isInteractive,
      disabled: _isDisabled,
      loading: widget.isLoading,
    );

    return Semantics(
      button: true,
      enabled: _isInteractive,
      label: widget.label,
      link: true,
      child: GestureDetector(
        onTapDown: _isInteractive ? (_) => setState(() => _pressed = true) : null,
        onTapUp: _isInteractive ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: _isInteractive ? () => setState(() => _pressed = false) : null,
        onTap: _isInteractive ? widget.onPressed : null,
        child: Padding(
          padding: metrics.padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading) ...[
                SizedBox(
                  width: AppIconSize.s,
                  height: AppIconSize.s,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foreground,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: metrics.fontSize,
                  fontWeight: AppTypography.fontWeightRegular,
                  height: metrics.lineHeight / metrics.fontSize,
                  letterSpacing: metrics.letterSpacing,
                  color: foreground,
                  decoration: TextDecoration.underline,
                  decorationColor: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DsButtonLinkMetrics {
  const _DsButtonLinkMetrics({
    required this.fontSize,
    required this.lineHeight,
    required this.letterSpacing,
    required this.padding,
  });

  final double fontSize;
  final double lineHeight;
  final double letterSpacing;
  final EdgeInsets padding;

  static _DsButtonLinkMetrics forSize(DsButtonSize size) {
    return switch (size) {
      DsButtonSize.large => const _DsButtonLinkMetrics(
          fontSize: AppFont.sizeL,
          lineHeight: AppFont.lineheightL,
          letterSpacing: 0.5,
          padding: EdgeInsets.zero,
        ),
      DsButtonSize.medium => const _DsButtonLinkMetrics(
          fontSize: AppFont.sizeM,
          lineHeight: AppFont.lineheightM,
          letterSpacing: 0,
          padding: EdgeInsets.zero,
        ),
      DsButtonSize.small => const _DsButtonLinkMetrics(
          fontSize: AppFont.sizeS,
          lineHeight: AppFont.lineheightS,
          letterSpacing: 0.25,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
        ),
    };
  }
}

class _DsButtonLinkPalette {
  static Color resolve({
    required SemanticColors colors,
    required bool pressed,
    required bool disabled,
    required bool loading,
  }) {
    if (disabled) {
      return colors.hyperlinkDisable;
    }
    if (loading) {
      return colors.textBrandPrimary4;
    }
    if (pressed) {
      return colors.textBrandPrimary3;
    }
    return colors.hyperlinkPrimary;
  }
}
