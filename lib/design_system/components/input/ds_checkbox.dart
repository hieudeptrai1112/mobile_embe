import 'package:flutter/material.dart';

import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Checkbox from Figma `ACheckBoxNormal` (Design System V2 Mobile).
///
/// Supports checked, unchecked, indeterminate (`value: null` with `tristate: true`),
/// optional label, and disabled state.
class DsCheckbox extends StatelessWidget {
  const DsCheckbox({
    super.key,
    this.value = false,
    this.tristate = false,
    this.onChanged,
    this.label,
    this.enabled = true,
  });

  final bool? value;
  final bool tristate;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final bool enabled;

  bool get _isInteractive => enabled && onChanged != null;

  void _handleTap() {
    if (!_isInteractive) return;
    if (value == null) {
      onChanged!(true);
      return;
    }
    onChanged!(value == true ? false : true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final palette = _DsCheckboxPalette.resolve(
      colors: colors,
      enabled: enabled,
      checked: value == true,
      indeterminate: value == null,
    );

    final control = Padding(
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: _isInteractive ? _handleTap : null,
        behavior: HitTestBehavior.opaque,
        child: _DsCheckboxControl(palette: palette),
      ),
    );

    if (label == null) {
      return Semantics(
        checked: value == true,
        enabled: _isInteractive,
        label: 'Checkbox',
        child: control,
      );
    }

    return Semantics(
      checked: value == true,
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

class _DsCheckboxControl extends StatelessWidget {
  const _DsCheckboxControl({required this.palette});

  final _DsCheckboxPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppIconSize.s,
      height: AppIconSize.s,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: palette.showBorder
            ? Border.all(color: palette.border, width: AppStroke.s)
            : null,
      ),
      alignment: Alignment.center,
      child: palette.indeterminate
          ? Container(
              width: 8,
              height: 1.5,
              decoration: BoxDecoration(
                color: palette.icon,
                borderRadius: BorderRadius.circular(1),
              ),
            )
          : palette.checked
              ? Icon(
                  Icons.check,
                  size: 12,
                  color: palette.icon,
                )
              : null,
    );
  }
}

class _DsCheckboxPalette {
  const _DsCheckboxPalette({
    required this.background,
    required this.border,
    required this.icon,
    required this.label,
    required this.checked,
    required this.indeterminate,
    required this.showBorder,
  });

  final Color background;
  final Color border;
  final Color icon;
  final Color label;
  final bool checked;
  final bool indeterminate;
  final bool showBorder;

  static _DsCheckboxPalette resolve({
    required SemanticColors colors,
    required bool enabled,
    required bool checked,
    required bool indeterminate,
  }) {
    if (!enabled) {
      if (checked || indeterminate) {
        return _DsCheckboxPalette(
          background: colors.borderDisable2,
          border: colors.borderDisable2,
          icon: colors.textWhite,
          label: colors.textPrimary,
          checked: checked,
          indeterminate: indeterminate,
          showBorder: false,
        );
      }
      return _DsCheckboxPalette(
        background: colors.backgroundDisable3,
        border: colors.borderDisable2,
        icon: colors.textDisable1,
        label: colors.textPrimary,
        checked: false,
        indeterminate: false,
        showBorder: true,
      );
    }

    if (checked || indeterminate) {
      return _DsCheckboxPalette(
        background: colors.borderBrandTertiary,
        border: colors.borderBrandTertiary,
        icon: colors.textPrimary,
        label: colors.textPrimary,
        checked: checked,
        indeterminate: indeterminate,
        showBorder: false,
      );
    }

    return _DsCheckboxPalette(
      background: Colors.transparent,
      border: colors.borderSecondary,
      icon: colors.textPrimary,
      label: colors.textPrimary,
      checked: false,
      indeterminate: false,
      showBorder: true,
    );
  }
}
