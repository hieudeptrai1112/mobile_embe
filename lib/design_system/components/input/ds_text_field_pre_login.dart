import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Underline-style text/password field from Figma `MTextFieldPreLogin`
/// (Design System V2 Mobile — node 3385:29338).
///
/// Specs:
/// - No background fill, no border-box — only a bottom border line.
/// - Input font: 16px / SemiBold.
/// - Label floats above the underline when focused or filled.
/// - Supports password visibility toggle (hide / unhide).
class DsTextFieldPreLogin extends StatefulWidget {
  const DsTextFieldPreLogin({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.required = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool obscureText;
  final bool showPasswordToggle;
  final bool required;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<DsTextFieldPreLogin> createState() => _DsTextFieldPreLoginState();
}

class _DsTextFieldPreLoginState extends State<DsTextFieldPreLogin> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final bool _ownsController;
  late final bool _ownsFocusNode;
  bool _obscureText = false;

  bool get _hasError => widget.errorText != null && widget.errorText!.isNotEmpty;
  bool get _hasContent => _controller.text.isNotEmpty;
  bool get _showLabel => _hasContent || _focusNode.hasFocus;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _ownsFocusNode = widget.focusNode == null;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _focusNode.addListener(_rebuild);
    _controller.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(DsTextFieldPreLogin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.obscureText != oldWidget.obscureText) {
      _obscureText = widget.obscureText;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_rebuild);
    _controller.removeListener(_rebuild);
    if (_ownsFocusNode) _focusNode.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  void _toggleVisibility() => setState(() => _obscureText = !_obscureText);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    final underlineColor = !widget.enabled
        ? colors.borderDisable2
        : _hasError
            ? colors.borderError1
            : colors.borderTertiary; // Semantic1/400 = #9BAFC8

    final inputColor =
        !widget.enabled ? colors.textDisable1 : colors.textPrimary;

    final iconColor =
        !widget.enabled ? colors.textDisable1 : colors.iconBrandPrimary1;

    // Semantic1/500 = #6D83A7 — used for floating label and placeholder
    final labelColor = colors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Floating label — visible when focused or has content
        AnimatedSize(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: _showLabel && widget.label != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label!,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: AppFont.sizeM,
                          fontWeight: AppTypography.fontWeightRegular,
                          height: AppFont.lineheightM / AppFont.sizeM,
                          letterSpacing: 0.25,
                          color: labelColor,
                        ),
                      ),
                      if (widget.required)
                        Text(
                          ' *',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: AppFont.sizeM,
                            fontWeight: AppTypography.fontWeightRegular,
                            height: AppFont.lineheightM / AppFont.sizeM,
                            color: colors.borderError1,
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        // Underline input row
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: underlineColor, width: 1.0),
            ),
          ),
          padding: const EdgeInsets.only(bottom: AppPadding.s),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                  inputFormatters: widget.inputFormatters,
                  maxLines: 1,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  onTap: widget.onTap,
                  cursorColor: colors.borderBrandTertiary,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppFont.sizeL, // 16px
                    fontWeight: AppTypography.fontWeightSemibold,
                    height: AppFont.lineheightL / AppFont.sizeL, // 24/16
                    color: inputColor,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    // When label is not shown, use label as hint placeholder
                    hintText: _showLabel
                        ? null
                        : (widget.hintText ?? widget.label),
                    hintStyle: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: AppFont.sizeL,
                      fontWeight: AppTypography.fontWeightSemibold,
                      height: AppFont.lineheightL / AppFont.sizeL,
                      color: labelColor,
                    ),
                  ),
                ),
              ),
              if (widget.showPasswordToggle && widget.enabled) ...[
                const SizedBox(width: AppSpacing.xs),
                GestureDetector(
                  onTap: _toggleVisibility,
                  behavior: HitTestBehavior.opaque,
                  child: DsIcon(
                    name: _obscureText
                        ? DsIconName.alinearHide
                        : DsIconName.alinearVisible,
                    size: AppIconSize.m,
                    color: iconColor,
                  ),
                ),
              ] else if (widget.showPasswordToggle && !widget.enabled) ...[
                const SizedBox(width: AppSpacing.xs),
                DsIcon(
                  name: DsIconName.alinearHide,
                  size: AppIconSize.m,
                  color: iconColor,
                ),
              ],
            ],
          ),
        ),
        if (_hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DsIcon(
                name: DsIconName.aboldError,
                size: AppIconSize.s,
                color: colors.borderError1,
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
                    color: colors.borderError1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
