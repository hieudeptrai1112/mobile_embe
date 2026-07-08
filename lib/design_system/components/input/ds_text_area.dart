import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Text area from Figma `MTextAreaNormal` (Design System V2 Mobile).
class DsTextArea extends StatefulWidget {
  const DsTextArea({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText = 'Input text',
    this.errorText,
    this.onChanged,
    this.required = true,
    this.showInfo = false,
    this.onInfoTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength = 100,
    this.minLines = 2,
    this.maxLines = 4,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool required;
  final bool showInfo;
  final VoidCallback? onInfoTap;
  final bool enabled;
  final bool readOnly;
  final int maxLength;
  final int minLines;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<DsTextArea> createState() => _DsTextAreaState();
}

class _DsTextAreaState extends State<DsTextArea> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final bool _ownsController;
  late final bool _ownsFocusNode;

  bool get _hasError => widget.errorText != null && widget.errorText!.isNotEmpty;
  bool get _isFilled => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _ownsFocusNode = widget.focusNode == null;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_refresh);
    _controller.addListener(_refresh);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_refresh);
    _controller.removeListener(_refresh);
    if (_ownsFocusNode) _focusNode.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final palette = _DsTextAreaPalette.resolve(
      colors: colors,
      enabled: widget.enabled,
      hasError: _hasError,
      focused: _focusNode.hasFocus,
      filled: _isFilled,
    );
    final currentLength = _controller.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          _TextAreaLabelRow(
            label: widget.label!,
            required: widget.required,
            showInfo: widget.showInfo,
            onInfoTap: widget.onInfoTap,
            labelColor: palette.label,
            requiredColor: palette.required,
            infoColor: palette.info,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minHeight: 52, maxHeight: 132),
          decoration: BoxDecoration(
            color: palette.background,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(
              color: palette.border,
              width: palette.borderWidth,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppPadding.m,
            AppPadding.l,
            AppPadding.m,
            AppPadding.s,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  inputFormatters: widget.inputFormatters,
                  onChanged: widget.onChanged,
                  style: _textStyle(palette.input),
                  cursorColor: palette.cursor,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText: widget.hintText,
                    hintStyle: _textStyle(palette.placeholder),
                    counterText: '',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '$currentLength/${widget.maxLength}',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppFont.sizeS,
                    fontWeight: AppTypography.fontWeightRegular,
                    height: AppFont.lineheightS / AppFont.sizeS,
                    letterSpacing: 0.25,
                    color: palette.counter,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DsIcon(
                name: DsIconName.aboldError,
                size: AppIconSize.s,
                color: palette.errorIcon,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppFont.sizeM,
                    fontWeight: AppTypography.fontWeightRegular,
                    height: AppFont.lineheightM / AppFont.sizeM,
                    letterSpacing: 0.25,
                    color: palette.errorText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  TextStyle _textStyle(Color color) {
    return TextStyle(
      fontFamily: AppTypography.fontFamily,
      fontSize: AppFont.sizeM,
      fontWeight: AppTypography.fontWeightRegular,
      height: AppFont.lineheightM / AppFont.sizeM,
      letterSpacing: 0.25,
      color: color,
    );
  }
}

class _TextAreaLabelRow extends StatelessWidget {
  const _TextAreaLabelRow({
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

class _DsTextAreaPalette {
  const _DsTextAreaPalette({
    required this.background,
    required this.border,
    required this.borderWidth,
    required this.label,
    required this.required,
    required this.info,
    required this.input,
    required this.placeholder,
    required this.counter,
    required this.cursor,
    required this.errorText,
    required this.errorIcon,
  });

  final Color background;
  final Color border;
  final double borderWidth;
  final Color label;
  final Color required;
  final Color info;
  final Color input;
  final Color placeholder;
  final Color counter;
  final Color cursor;
  final Color errorText;
  final Color errorIcon;

  static _DsTextAreaPalette resolve({
    required SemanticColors colors,
    required bool enabled,
    required bool hasError,
    required bool focused,
    required bool filled,
  }) {
    if (!enabled) {
      return _DsTextAreaPalette(
        background: colors.backgroundDisable3,
        border: colors.borderDisable2,
        borderWidth: AppStroke.s,
        label: colors.textPrimary,
        required: colors.borderError2,
        info: colors.textDisable1,
        input: colors.textDisable1,
        placeholder: colors.textDisable1,
        counter: colors.textDisable2,
        cursor: colors.textDisable1,
        errorText: colors.borderError1,
        errorIcon: colors.iconError,
      );
    }

    final border = hasError
        ? colors.borderError3
        : focused
            ? colors.borderBrandTertiary
            : colors.borderPrimary;

    return _DsTextAreaPalette(
      background: colors.backgroundPrimary,
      border: border,
      borderWidth: focused ? AppStroke.m : AppStroke.s,
      label: colors.textPrimary,
      required: colors.borderError2,
      info: colors.iconBrandPrimary1,
      input: colors.textPrimary,
      placeholder: colors.borderTertiary,
      counter: colors.textDisable2,
      cursor: colors.borderBrandTertiary,
      errorText: colors.borderError1,
      errorIcon: colors.iconError,
    );
  }
}
