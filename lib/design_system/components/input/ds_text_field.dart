import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Layout metrics from Figma `MTextFieldPostLogin`.
abstract final class _DsTextFieldMetrics {
  static const inputHeight = 52.0;
}

/// Text field from Figma `MTextFieldPostLogin` (Design System V2 Mobile).
///
/// Supports label, required indicator, prefix/suffix, password visibility toggle,
/// trailing icon, help text, and error state.
class DsTextField extends StatefulWidget {
  const DsTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helpText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.trailingIcon,
    this.onTrailingIconTap,
    this.onInfoTap,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.required = false,
    this.showInfo = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.money = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? helpText;
  final String? errorText;
  final String? prefix;
  final String? suffix;
  final Widget? trailingIcon;
  final VoidCallback? onTrailingIconTap;
  final VoidCallback? onInfoTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool obscureText;
  final bool showPasswordToggle;
  final bool required;
  final bool showInfo;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool money;

  @override
  State<DsTextField> createState() => _DsTextFieldState();
}

class _DsTextFieldState extends State<DsTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final bool _ownsController;
  late final bool _ownsFocusNode;
  bool _obscureText = false;

  bool get _hasError => widget.errorText != null && widget.errorText!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _ownsFocusNode = widget.focusNode == null;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(DsTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.obscureText != oldWidget.obscureText) {
      _obscureText = widget.obscureText;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() => setState(() {});

  void _togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final palette = _DsTextFieldPalette.resolve(
      colors: colors,
      enabled: widget.enabled,
      hasError: _hasError,
      focused: _focusNode.hasFocus,
    );
    final inputStyle = widget.money
        ? _moneyInputTextStyle(colors, enabled: widget.enabled)
        : _inputTextStyle(palette.input);
    final hintStyle = widget.money
        ? _moneyPlaceholderTextStyle(colors, enabled: widget.enabled)
        : _inputTextStyle(palette.placeholder);
    final suffixStyle = widget.money
        ? _moneySuffixTextStyle(colors)
        : _inputTextStyle(palette.input);
    final formatters = widget.money
        ? <TextInputFormatter>[
            _ThousandsSeparatorInputFormatter(),
            ...?widget.inputFormatters,
          ]
        : widget.inputFormatters;
    // Figma: container h-52, py-16 items-center (standard) / py-12 (money).
    // contentPadding drives vertical centering; isCollapsed must NOT be used.
    final editorVerticalPadding = widget.money ? 12.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          _LabelRow(
            label: widget.label!,
            required: widget.required,
            showInfo: widget.showInfo,
            onInfoTap: widget.onInfoTap,
            labelColor: palette.label,
            requiredColor: palette.required,
            infoColor: palette.icon,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          height: _DsTextFieldMetrics.inputHeight,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: palette.background,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(
              color: palette.border,
              width: AppStroke.s,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.m),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.prefix != null) ...[
                _AffixText(
                  text: widget.prefix!,
                  style: _inputTextStyle(palette.input),
                  lineHeight: AppFont.lineheightM,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  autofocus: widget.autofocus,
                  obscureText: _obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  inputFormatters: formatters,
                  maxLines: widget.maxLines,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  onTap: widget.onTap,
                  cursorColor: palette.cursor,
                  style: inputStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: editorVerticalPadding,
                    ),
                    hintText: widget.hintText,
                    hintStyle: hintStyle,
                  ),
                ),
              ),
              if (widget.suffix != null) ...[
                const SizedBox(width: AppSpacing.xs),
                _AffixText(
                  text: widget.suffix!,
                  style: suffixStyle,
                  lineHeight: AppFont.lineheightM,
                ),
              ],
              if (widget.showPasswordToggle && widget.enabled) ...[
                const SizedBox(width: AppSpacing.xs),
                _CenteredInputIcon(
                  child: _IconButton(
                    icon: DsIcon(
                      name: _obscureText
                          ? DsIconName.alinearHide
                          : DsIconName.alinearVisible,
                      size: AppIconSize.m,
                      color: palette.icon,
                    ),
                    onTap: _togglePasswordVisibility,
                  ),
                ),
              ] else if (widget.trailingIcon != null) ...[
                const SizedBox(width: AppSpacing.xs),
                _CenteredInputIcon(
                  child: _IconButton(
                    icon: IconTheme(
                      data: IconThemeData(
                        color: palette.icon,
                        size: AppIconSize.m,
                      ),
                      child: widget.trailingIcon!,
                    ),
                    onTap: widget.onTrailingIconTap,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          _ErrorRow(
            message: widget.errorText!,
            color: palette.errorText,
            iconColor: palette.errorIcon,
          ),
        ] else if (widget.helpText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.helpText!,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              fontWeight: AppTypography.fontWeightRegular,
              height: AppFont.lineheightM / AppFont.sizeM,
              letterSpacing: 0.25,
              color: palette.helpText,
            ),
          ),
        ],
      ],
    );
  }

  TextStyle _inputTextStyle(Color color) {
    return TextStyle(
      fontFamily: AppTypography.fontFamily,
      fontSize: AppFont.sizeM,
      fontWeight: AppTypography.fontWeightRegular,
      height: AppFont.lineheightM / AppFont.sizeM,
      letterSpacing: 0.25,
      color: color,
    );
  }

  TextStyle _moneyInputTextStyle(
    SemanticColors colors, {
    required bool enabled,
  }) {
    return TextStyle(
      fontFamily: AppTypography.fontFamily,
      fontSize: AppFont.sizeXl,
      fontWeight: AppTypography.fontWeightSemibold,
      height: AppFont.lineheightXl / AppFont.sizeXl,
      letterSpacing: 0.25,
      color: enabled ? colors.textBrandPrimary1 : colors.textDisable1,
    );
  }

  TextStyle _moneyPlaceholderTextStyle(
    SemanticColors colors, {
    required bool enabled,
  }) {
    return TextStyle(
      fontFamily: AppTypography.fontFamily,
      fontSize: AppFont.sizeXl,
      fontWeight: AppTypography.fontWeightRegular,
      height: AppFont.lineheightXl / AppFont.sizeXl,
      letterSpacing: 0.25,
      color: enabled ? colors.borderTertiary : colors.textDisable1,
    );
  }

  TextStyle _moneySuffixTextStyle(SemanticColors colors) {
    return TextStyle(
      fontFamily: AppTypography.fontFamily,
      fontSize: AppFont.sizeM,
      fontWeight: AppTypography.fontWeightRegular,
      height: AppFont.lineheightM / AppFont.sizeM,
      letterSpacing: 0.25,
      color: colors.textPrimary,
    );
  }
}

class _CenteredInputIcon extends StatelessWidget {
  const _CenteredInputIcon({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppIconSize.m,
      height: AppIconSize.m,
      child: Center(child: child),
    );
  }
}

class _AffixText extends StatelessWidget {
  const _AffixText({
    required this.text,
    required this.style,
    required this.lineHeight,
  });

  final String text;
  final TextStyle style;
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: lineHeight,
      child: Center(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style,
        ),
      ),
    );
  }
}

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue();
    }

    final formatted = _formatWithCommas(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String _formatWithCommas(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

class _LabelRow extends StatelessWidget {
  const _LabelRow({
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
          _IconButton(
            icon: DsIcon(
              name: DsIconName.aboldInfo,
              size: AppIconSize.s,
              color: infoColor,
            ),
            onTap: onInfoTap,
          ),
        ],
      ],
    );
  }
}

class _ErrorRow extends StatelessWidget {
  const _ErrorRow({
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

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    this.onTap,
  });

  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: icon,
    );
  }
}

class _DsTextFieldPalette {
  const _DsTextFieldPalette({
    required this.background,
    required this.border,
    required this.label,
    required this.required,
    required this.input,
    required this.placeholder,
    required this.icon,
    required this.cursor,
    required this.errorText,
    required this.errorIcon,
    required this.helpText,
  });

  final Color background;
  final Color border;
  final Color label;
  final Color required;
  final Color input;
  final Color placeholder;
  final Color icon;
  final Color cursor;
  final Color errorText;
  final Color errorIcon;
  final Color helpText;

  static _DsTextFieldPalette resolve({
    required SemanticColors colors,
    required bool enabled,
    required bool hasError,
    required bool focused,
  }) {
    if (!enabled) {
      return _DsTextFieldPalette(
        background: colors.backgroundDisable3,
        border: colors.borderDisable2,
        label: colors.textPrimary,
        required: colors.borderError1,
        input: colors.textDisable1,
        placeholder: colors.textDisable1,
        icon: colors.textDisable1,
        cursor: colors.textDisable1,
        errorText: colors.borderError1,
        errorIcon: colors.iconError,
        helpText: colors.textPrimary4,
      );
    }

    final border = hasError
        ? colors.borderError1
        : focused
            ? colors.borderBrandTertiary
            : colors.borderPrimary;

    return _DsTextFieldPalette(
      background: colors.backgroundPrimary,
      border: border,
      label: colors.textPrimary,
      required: colors.borderError1,
      input: colors.textPrimary,
      placeholder: colors.borderTertiary,
      icon: colors.iconBrandPrimary1,
      cursor: colors.borderBrandTertiary,
      errorText: colors.borderError1,
      errorIcon: colors.iconError,
      helpText: colors.textPrimary4,
    );
  }
}
