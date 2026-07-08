import 'package:flutter/material.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

enum DsDropdownTitlePlacement { outside, inside }

enum DsDropdownMode { single, multiple }

class DsDropdownItem<T> {
  const DsDropdownItem({required this.value, required this.label});

  final T value;
  final String label;
}

/// Dropdown from Figma `MDropdownNormal` (Design System V2 Mobile).
///
/// Supports title outside/inside, single & multiple selection, error and disabled states.
class DsDropdown<T> extends StatefulWidget {
  const DsDropdown({
    super.key,
    required this.items,
    this.label,
    this.hintText = 'Lựa chọn',
    this.errorText,
    this.value,
    this.values = const [],
    this.onChanged,
    this.onMultiChanged,
    this.titlePlacement = DsDropdownTitlePlacement.outside,
    this.mode = DsDropdownMode.single,
    this.required = false,
    this.showInfo = false,
    this.onInfoTap,
    this.enabled = true,
  });

  final List<DsDropdownItem<T>> items;
  final String? label;
  final String hintText;
  final String? errorText;
  final T? value;
  final List<T> values;
  final ValueChanged<T?>? onChanged;
  final ValueChanged<List<T>>? onMultiChanged;
  final DsDropdownTitlePlacement titlePlacement;
  final DsDropdownMode mode;
  final bool required;
  final bool showInfo;
  final VoidCallback? onInfoTap;
  final bool enabled;

  @override
  State<DsDropdown<T>> createState() => _DsDropdownState<T>();
}

class _DsDropdownState<T> extends State<DsDropdown<T>> {
  bool _isOpen = false;

  bool get _hasError => widget.errorText != null && widget.errorText!.isNotEmpty;

  String? get _displayText {
    if (widget.mode == DsDropdownMode.single) {
      if (widget.value == null) return null;
      return widget.items
          .firstWhere((item) => item.value == widget.value)
          .label;
    }
    if (widget.values.isEmpty) return null;
    return widget.items
        .where((item) => widget.values.contains(item.value))
        .map((item) => item.label)
        .join(', ');
  }

  Future<void> _openPicker() async {
    if (!widget.enabled) return;

    setState(() => _isOpen = true);

    final selected = await showModalBottomSheet<List<T>>(
      context: context,
      builder: (context) => _DsDropdownSheet<T>(
        items: widget.items,
        mode: widget.mode,
        initialValue: widget.value,
        initialValues: widget.values,
      ),
    );

    if (!mounted) return;
    setState(() => _isOpen = false);

    if (selected == null) return;
    if (widget.mode == DsDropdownMode.single) {
      widget.onChanged?.call(selected.isEmpty ? null : selected.first);
    } else {
      widget.onMultiChanged?.call(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final palette = _DsDropdownPalette.resolve(
      colors: colors,
      enabled: widget.enabled,
      hasError: _hasError,
      active: _isOpen,
    );
    final isInside = widget.titlePlacement == DsDropdownTitlePlacement.inside;
    final displayText = _displayText;
    final showPlaceholder = displayText == null;
    final resolvedText = displayText ?? widget.hintText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isInside && widget.label != null) ...[
          _DropdownLabelRow(
            label: widget.label!,
            required: widget.required,
            showInfo: widget.showInfo,
            onInfoTap: widget.onInfoTap,
            labelColor: palette.label,
            requiredColor: palette.errorText,
            infoColor: palette.chevron,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        GestureDetector(
          onTap: widget.enabled ? _openPicker : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.m,
              vertical: isInside ? 10 : AppPadding.l,
            ),
            decoration: BoxDecoration(
              color: palette.background,
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(
                color: palette.border,
                width: palette.borderWidth,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: isInside && widget.label != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.label!,
                              style: _textStyle(
                                palette.insideLabel,
                                AppTypography.fontWeightRegular,
                              ),
                            ),
                            Text(
                              resolvedText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _textStyle(
                                showPlaceholder
                                    ? palette.placeholder
                                    : palette.value,
                                AppTypography.fontWeightRegular,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          resolvedText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _textStyle(
                            showPlaceholder
                                ? palette.placeholder
                                : palette.value,
                            AppTypography.fontWeightRegular,
                          ),
                        ),
                ),
                DsIcon(
                  name: DsIconName.alinearBottom,
                  size: AppIconSize.s,
                  color: palette.chevron,
                ),
              ],
            ),
          ),
        ),
        if (_hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          _DropdownErrorRow(
            message: widget.errorText!,
            color: palette.errorText,
            iconColor: palette.errorIcon,
          ),
        ],
      ],
    );
  }

  TextStyle _textStyle(Color color, FontWeight weight) {
    return TextStyle(
      fontFamily: AppTypography.fontFamily,
      fontSize: AppFont.sizeM,
      fontWeight: weight,
      height: AppFont.lineheightM / AppFont.sizeM,
      letterSpacing: 0.25,
      color: color,
    );
  }
}

class _DsDropdownSheet<T> extends StatefulWidget {
  const _DsDropdownSheet({
    required this.items,
    required this.mode,
    this.initialValue,
    this.initialValues = const [],
  });

  final List<DsDropdownItem<T>> items;
  final DsDropdownMode mode;
  final T? initialValue;
  final List<T> initialValues;

  @override
  State<_DsDropdownSheet<T>> createState() => _DsDropdownSheetState<T>();
}

class _DsDropdownSheetState<T> extends State<_DsDropdownSheet<T>> {
  late T? _selected;
  late List<T> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
    _selectedValues = List<T>.from(widget.initialValues);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.mode == DsDropdownMode.multiple)
            Padding(
              padding: const EdgeInsets.all(AppPadding.m),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pop(context, _selectedValues),
                  child: const Text('Xong'),
                ),
              ),
            ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final item in widget.items)
                  if (widget.mode == DsDropdownMode.single)
                    ListTile(
                      title: Text(item.label),
                      trailing: _selected == item.value
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => Navigator.pop(context, [item.value]),
                    )
                  else
                    CheckboxListTile(
                      title: Text(item.label),
                      value: _selectedValues.contains(item.value),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedValues.add(item.value);
                          } else {
                            _selectedValues.remove(item.value);
                          }
                        });
                      },
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownLabelRow extends StatelessWidget {
  const _DropdownLabelRow({
    required this.label,
    required this.required,
    required this.showInfo,
    required this.labelColor,
    required this.requiredColor,
    required this.infoColor,
    this.onInfoTap,
  });

  final String label;
  final bool required;
  final bool showInfo;
  final Color labelColor;
  final Color requiredColor;
  final Color infoColor;
  final VoidCallback? onInfoTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeM,
                fontWeight: AppTypography.fontWeightSemibold,
                height: AppFont.lineheightM / AppFont.sizeM,
                letterSpacing: 0.5,
                color: labelColor,
              ),
            ),
            if (required)
              Text(
                '*',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: AppFont.sizeM,
                  fontWeight: AppTypography.fontWeightSemibold,
                  height: AppFont.lineheightM / AppFont.sizeM,
                  letterSpacing: 0.5,
                  color: requiredColor,
                ),
              ),
          ],
        ),
        if (showInfo) ...[
          const SizedBox(width: AppSpacing.s),
          GestureDetector(
            onTap: onInfoTap,
            behavior: HitTestBehavior.opaque,
            child: DsIcon(
              name: DsIconName.aboldInfo,
              size: AppIconSize.s,
              color: infoColor,
            ),
          ),
        ],
      ],
    );
  }
}

class _DropdownErrorRow extends StatelessWidget {
  const _DropdownErrorRow({
    required this.message,
    required this.color,
    required this.iconColor,
  });

  final String message;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DsIcon(
          name: DsIconName.aboldError,
          size: AppIconSize.s,
          color: iconColor,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              fontWeight: AppTypography.fontWeightRegular,
              height: AppFont.lineheightM / AppFont.sizeM,
              letterSpacing: 0.25,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _DsDropdownPalette {
  const _DsDropdownPalette({
    required this.background,
    required this.border,
    required this.borderWidth,
    required this.label,
    required this.insideLabel,
    required this.placeholder,
    required this.value,
    required this.chevron,
    required this.errorText,
    required this.errorIcon,
  });

  final Color background;
  final Color border;
  final double borderWidth;
  final Color label;
  final Color insideLabel;
  final Color placeholder;
  final Color value;
  final Color chevron;
  final Color errorText;
  final Color errorIcon;

  static _DsDropdownPalette resolve({
    required SemanticColors colors,
    required bool enabled,
    required bool hasError,
    required bool active,
  }) {
    if (!enabled) {
      return _DsDropdownPalette(
        background: colors.backgroundDisable3,
        border: colors.borderDisable2,
        borderWidth: AppStroke.s,
        label: colors.textPrimary,
        insideLabel: colors.textDisable1,
        placeholder: colors.textDisable1,
        value: colors.textDisable1,
        chevron: colors.textDisable1,
        errorText: colors.borderError2,
        errorIcon: colors.iconError,
      );
    }

    final border = hasError
        ? colors.borderError2
        : active
            ? colors.borderBrandTertiary
            : colors.borderPrimary;

    return _DsDropdownPalette(
      background: colors.backgroundPrimary,
      border: border,
      borderWidth: active ? AppStroke.m : AppStroke.s,
      label: colors.textPrimary,
      insideLabel: colors.textSecondary,
      placeholder: colors.borderTertiary,
      value: colors.textPrimary,
      chevron: colors.textPrimary,
      errorText: colors.borderError2,
      errorIcon: colors.iconError,
    );
  }
}
