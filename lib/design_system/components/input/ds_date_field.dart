import 'package:flutter/material.dart';

import '../overlay/ds_date_picker.dart';
import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

enum DsDateFieldMode { single, range }

class DsDateField extends StatefulWidget {
  const DsDateField.single({
    super.key,
    this.label = 'Tiêu đề',
    this.hintText = 'Chọn ngày',
    this.required = false,
    this.showInfo = false,
    this.onInfoTap,
    this.enabled = true,
    this.errorText,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateChanged,
  })  : mode = DsDateFieldMode.single,
        initialRange = null,
        onRangeChanged = null;

  const DsDateField.range({
    super.key,
    this.label = 'Tiêu đề',
    this.required = false,
    this.showInfo = false,
    this.onInfoTap,
    this.enabled = true,
    this.errorText,
    this.initialRange,
    this.firstDate,
    this.lastDate,
    this.onRangeChanged,
  })  : mode = DsDateFieldMode.range,
        hintText = 'Chọn ngày',
        initialDate = null,
        onDateChanged = null;

  final DsDateFieldMode mode;
  final String label;
  final String hintText;
  final bool required;
  final bool showInfo;
  final VoidCallback? onInfoTap;
  final bool enabled;
  final String? errorText;
  final DateTime? initialDate;
  final DateTimeRange? initialRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?>? onDateChanged;
  final ValueChanged<DateTimeRange?>? onRangeChanged;

  @override
  State<DsDateField> createState() => _DsDateFieldState();
}

class _DsDateFieldState extends State<DsDateField> {
  DateTime? _selectedDate;
  DateTimeRange? _selectedRange;
  bool _active = false;

  bool get _hasError => widget.errorText != null && widget.errorText!.isNotEmpty;

  bool get _filled => widget.mode == DsDateFieldMode.single
      ? _selectedDate != null
      : _selectedRange != null;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedRange = widget.initialRange;
  }

  Future<void> _pickDate() async {
    if (!widget.enabled) return;
    setState(() => _active = true);
    final picked = await DsDatePicker.showSingle(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (!mounted) return;
    setState(() {
      _active = false;
      if (picked != null) _selectedDate = picked;
    });
    if (picked != null) widget.onDateChanged?.call(picked);
  }

  Future<void> _pickRange() async {
    if (!widget.enabled) return;
    setState(() => _active = true);
    final picked = await DsDatePicker.showRange(
      context: context,
      initialRange: _selectedRange,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (!mounted) return;
    setState(() {
      _active = false;
      if (picked != null) _selectedRange = picked;
    });
    if (picked != null) widget.onRangeChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final palette = _DateFieldPalette.resolve(
      colors: colors,
      enabled: widget.enabled,
      active: _active,
      filled: _filled,
      error: _hasError,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _DateFieldLabel(
          label: widget.label,
          required: widget.required,
          showInfo: widget.showInfo,
          onInfoTap: widget.onInfoTap,
          labelColor: palette.label,
          requiredColor: palette.required,
          infoColor: palette.icon,
        ),
        const SizedBox(height: AppSpacing.xs),
        GestureDetector(
          onTap: widget.mode == DsDateFieldMode.single ? _pickDate : _pickRange,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.m,
              vertical: AppPadding.s,
            ),
            decoration: BoxDecoration(
              color: palette.background,
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(
                color: palette.border,
                width: palette.borderWidth,
              ),
            ),
            child: widget.mode == DsDateFieldMode.single
                ? _SingleDateContent(
                    text: _selectedDate == null
                        ? widget.hintText
                        : _formatDate(_selectedDate!),
                    textColor: _selectedDate == null ? palette.placeholder : palette.value,
                    iconColor: palette.icon,
                  )
                : _RangeDateContent(
                    startText: _selectedRange == null
                        ? 'Từ ngày'
                        : _formatDate(_selectedRange!.start),
                    endText: _selectedRange == null
                        ? 'Đến ngày'
                        : _formatDate(_selectedRange!.end),
                    textColor: _selectedRange == null ? palette.placeholder : palette.value,
                    secondaryTextColor: palette.secondary,
                    iconColor: palette.icon,
                  ),
          ),
        ),
        if (_hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              DsIcon(
                name: DsIconName.aboldError,
                size: AppIconSize.s,
                color: palette.error,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                widget.errorText!,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: AppFont.sizeM,
                  fontWeight: AppTypography.fontWeightRegular,
                  height: AppFont.lineheightM / AppFont.sizeM,
                  letterSpacing: 0.25,
                  color: palette.error,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    return '$dd/$mm/$yyyy';
  }
}

class _DateFieldLabel extends StatelessWidget {
  const _DateFieldLabel({
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

class _SingleDateContent extends StatelessWidget {
  const _SingleDateContent({
    required this.text,
    required this.textColor,
    required this.iconColor,
  });

  final String text;
  final Color textColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              fontWeight: AppTypography.fontWeightRegular,
              height: AppFont.lineheightM / AppFont.sizeM,
              letterSpacing: 0.25,
              color: textColor,
            ),
          ),
        ),
        DsIcon(
          name: DsIconName.alinearCalendar,
          size: AppIconSize.s,
          color: iconColor,
        ),
      ],
    );
  }
}

class _RangeDateContent extends StatelessWidget {
  const _RangeDateContent({
    required this.startText,
    required this.endText,
    required this.textColor,
    required this.secondaryTextColor,
    required this.iconColor,
  });

  final String startText;
  final String endText;
  final Color textColor;
  final Color secondaryTextColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            startText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              fontWeight: AppTypography.fontWeightRegular,
              height: AppFont.lineheightM / AppFont.sizeM,
              letterSpacing: 0.25,
              color: textColor,
            ),
          ),
        ),
        DsIcon(
          name: DsIconName.alinearRight,
          size: AppIconSize.s,
          color: secondaryTextColor,
        ),
        Expanded(
          child: Text(
            endText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              fontWeight: AppTypography.fontWeightRegular,
              height: AppFont.lineheightM / AppFont.sizeM,
              letterSpacing: 0.25,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        DsIcon(
          name: DsIconName.alinearCalendar,
          size: AppIconSize.s,
          color: iconColor,
        ),
      ],
    );
  }
}

class _DateFieldPalette {
  const _DateFieldPalette({
    required this.background,
    required this.border,
    required this.borderWidth,
    required this.label,
    required this.required,
    required this.icon,
    required this.placeholder,
    required this.value,
    required this.secondary,
    required this.error,
  });

  final Color background;
  final Color border;
  final double borderWidth;
  final Color label;
  final Color required;
  final Color icon;
  final Color placeholder;
  final Color value;
  final Color secondary;
  final Color error;

  static _DateFieldPalette resolve({
    required SemanticColors colors,
    required bool enabled,
    required bool active,
    required bool filled,
    required bool error,
  }) {
    if (!enabled) {
      return _DateFieldPalette(
        background: colors.backgroundDisable3,
        border: colors.borderDisable2,
        borderWidth: AppStroke.m,
        label: colors.textPrimary,
        required: colors.borderError2,
        icon: colors.textDisable1,
        placeholder: colors.textDisable1,
        value: colors.textDisable1,
        secondary: colors.textDisable1,
        error: colors.borderError2,
      );
    }

    final border = error
        ? colors.borderError1
        : active
            ? colors.borderBrandTertiary
            : colors.borderPrimary;

    return _DateFieldPalette(
      background: colors.backgroundPrimary,
      border: border,
      borderWidth: active ? AppStroke.m : AppStroke.s,
      label: colors.textPrimary,
      required: colors.borderError2,
      icon: colors.iconBrandPrimary1,
      placeholder: colors.borderTertiary,
      value: filled ? colors.textPrimary : colors.borderTertiary,
      secondary: colors.textSecondary,
      error: colors.borderError2,
    );
  }
}
