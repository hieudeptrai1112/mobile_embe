import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Search input from Figma `MSearchNormal` (Design System V2 Mobile).
class DsSearch extends StatefulWidget {
  const DsSearch({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText = 'Input Text',
    this.error = false,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onClear,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final bool error;
  final bool enabled;
  final bool autofocus;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<DsSearch> createState() => _DsSearchState();
}

class _DsSearchState extends State<DsSearch> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final bool _ownsController;
  late final bool _ownsFocusNode;

  bool get _hasText => _controller.text.trim().isNotEmpty;
  bool get _active => _focusNode.hasFocus;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _ownsFocusNode = widget.focusNode == null;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_refresh);
    _focusNode.addListener(_refresh);
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _focusNode.removeListener(_refresh);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final palette = _DsSearchPalette.resolve(
      colors: colors,
      enabled: widget.enabled,
      active: _active,
      hasText: _hasText,
      error: widget.error,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(AppPadding.m),
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
          DsIcon(
            name: DsIconName.alinearSearch,
            size: AppIconSize.m,
            color: palette.icon,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              readOnly: widget.readOnly,
              inputFormatters: widget.inputFormatters,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
              style: _textStyle(palette.input),
              cursorColor: palette.cursor,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: widget.hintText,
                hintStyle: _textStyle(palette.placeholder),
              ),
            ),
          ),
          if (_hasText || _active)
            GestureDetector(
              onTap: widget.enabled ? _clear : null,
              behavior: HitTestBehavior.opaque,
              child: DsIcon(
                name: DsIconName.alinearCancel,
                size: AppIconSize.s,
                color: palette.icon,
              ),
            ),
        ],
      ),
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

class _DsSearchPalette {
  const _DsSearchPalette({
    required this.background,
    required this.border,
    required this.borderWidth,
    required this.icon,
    required this.placeholder,
    required this.input,
    required this.cursor,
  });

  final Color background;
  final Color border;
  final double borderWidth;
  final Color icon;
  final Color placeholder;
  final Color input;
  final Color cursor;

  static _DsSearchPalette resolve({
    required SemanticColors colors,
    required bool enabled,
    required bool active,
    required bool hasText,
    required bool error,
  }) {
    if (!enabled) {
      return _DsSearchPalette(
        background: colors.backgroundDisable3,
        border: colors.borderDisable2,
        borderWidth: AppStroke.s,
        icon: colors.textDisable1,
        placeholder: colors.textDisable1,
        input: colors.textDisable1,
        cursor: colors.textDisable1,
      );
    }

    final border = error ? colors.borderError1 : colors.borderPrimary;
    return _DsSearchPalette(
      background: colors.backgroundPrimary,
      border: border,
      borderWidth: AppStroke.s,
      icon: colors.iconBrandPrimary1,
      placeholder: colors.borderTertiary,
      input: hasText ? colors.textPrimary : colors.textPrimary,
      cursor: active ? colors.backgroundBrandTertiary1 : colors.backgroundBrandTertiary1,
    );
  }
}
