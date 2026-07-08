import 'package:flutter/material.dart';

import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Radio from Figma `MRadioNormal` (Design System V2 Mobile).
///
/// Supports selected/unselected and disabled states with optional label.
class DsRadio<T> extends StatelessWidget {
  const DsRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.enabled = true,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final bool enabled;

  bool get selected => value == groupValue;
  bool get _isInteractive => enabled && onChanged != null;

  void _handleTap() {
    if (!_isInteractive || selected) return;
    onChanged!(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final palette = _DsRadioPalette.resolve(
      colors: colors,
      enabled: enabled,
      selected: selected,
    );

    final control = Padding(
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: _isInteractive ? _handleTap : null,
        behavior: HitTestBehavior.opaque,
        child: _DsRadioControl(palette: palette),
      ),
    );

    if (label == null) {
      return Semantics(
        checked: selected,
        enabled: _isInteractive,
        label: 'Radio',
        child: control,
      );
    }

    return Semantics(
      checked: selected,
      enabled: _isInteractive,
      label: label,
      child: GestureDetector(
        onTap: _isInteractive ? _handleTap : null,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            control,
            const SizedBox(width: AppSpacing.s),
            Text(
              label!,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeM,
                fontWeight: AppTypography.fontWeightRegular,
                height: AppFont.lineheightM / AppFont.sizeM,
                letterSpacing: 0.25,
                color: palette.label,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DsRadioControl extends StatelessWidget {
  const _DsRadioControl({required this.palette});

  final _DsRadioPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppIconSize.s,
      height: AppIconSize.s,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: palette.background,
        border: Border.all(
          color: palette.border,
          width: AppStroke.s,
        ),
      ),
      alignment: Alignment.center,
      child: palette.selected
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: palette.dot,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}

class _DsRadioPalette {
  const _DsRadioPalette({
    required this.background,
    required this.border,
    required this.dot,
    required this.label,
    required this.selected,
  });

  final Color background;
  final Color border;
  final Color dot;
  final Color label;
  final bool selected;

  static _DsRadioPalette resolve({
    required SemanticColors colors,
    required bool enabled,
    required bool selected,
  }) {
    if (!enabled) {
      return _DsRadioPalette(
        background: selected ? colors.backgroundDisable3 : colors.backgroundDisable3,
        border: colors.borderDisable2,
        dot: colors.borderDisable2,
        label: colors.textPrimary,
        selected: selected,
      );
    }

    if (selected) {
      return _DsRadioPalette(
        background: colors.backgroundPrimary,
        border: colors.borderBrandTertiary,
        dot: colors.borderBrandTertiary,
        label: colors.textPrimary,
        selected: true,
      );
    }

    return _DsRadioPalette(
      background: colors.backgroundPrimary,
      border: colors.borderSecondary,
      dot: colors.borderSecondary,
      label: colors.textPrimary,
      selected: false,
    );
  }
}
