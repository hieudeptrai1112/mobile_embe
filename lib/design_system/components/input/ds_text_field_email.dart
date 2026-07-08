import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

/// A committed email value shown as a chip inside [DsTextFieldEmail].
class DsEmailChipEntry {
  const DsEmailChipEntry({
    required this.value,
    this.isValid,
  });

  final String value;

  /// When null, validity is resolved via [DsTextFieldEmail.emailValidator].
  final bool? isValid;
}

/// Multi-email text field from Figma `Text Field-Email` (Design System V2 Mobile).
///
/// Supports email chips (valid/invalid), field states, help text, and errors.
class DsTextFieldEmail extends StatefulWidget {
  const DsTextFieldEmail({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText = 'Input text',
    this.helpText,
    this.errorText,
    this.initialChips = const [],
    this.onChipsChanged,
    this.onChanged,
    this.onInfoTap,
    this.emailValidator,
    this.required = false,
    this.showInfo = false,
    this.enabled = true,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? helpText;
  final String? errorText;
  final List<DsEmailChipEntry> initialChips;
  final ValueChanged<List<DsEmailChipEntry>>? onChipsChanged;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onInfoTap;
  final bool Function(String email)? emailValidator;
  final bool required;
  final bool showInfo;
  final bool enabled;
  final bool autofocus;

  static final RegExp _defaultEmailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static bool isValidEmail(String value) =>
      _defaultEmailPattern.hasMatch(value.trim());

  @override
  State<DsTextFieldEmail> createState() => _DsTextFieldEmailState();
}

class _DsTextFieldEmailState extends State<DsTextFieldEmail> {
  static const _minInputWidth = 80.0;
  static const _minFieldHeight = 52.0;

  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final bool _ownsController;
  late final bool _ownsFocusNode;
  late List<DsEmailChipEntry> _chips;
  double _inputWidth = _minInputWidth;

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  bool Function(String) get _validator =>
      widget.emailValidator ?? DsTextFieldEmail.isValidEmail;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _ownsFocusNode = widget.focusNode == null;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _chips = List<DsEmailChipEntry>.from(widget.initialChips);
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_updateInputWidth);
    _updateInputWidth();
  }

  @override
  void didUpdateWidget(DsTextFieldEmail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialChips != oldWidget.initialChips &&
        widget.initialChips.isNotEmpty) {
      _chips = List<DsEmailChipEntry>.from(widget.initialChips);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _controller.removeListener(_updateInputWidth);
    if (_ownsFocusNode) _focusNode.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() => setState(() {});

  void _updateInputWidth() {
    final text = _controller.text;
    final style = const TextStyle(
      fontFamily: AppTypography.fontFamily,
      fontSize: AppFont.sizeM,
    );
    final painter = TextPainter(
      text: TextSpan(
        text: text.isEmpty ? widget.hintText : text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    final nextWidth = math.max(_minInputWidth, painter.width + 8);
    if (nextWidth != _inputWidth) {
      setState(() => _inputWidth = nextWidth);
    }
  }

  bool _chipIsValid(DsEmailChipEntry chip) =>
      chip.isValid ?? _validator(chip.value);

  void _notifyChipsChanged() => widget.onChipsChanged?.call(List.unmodifiable(_chips));

  void _commitInput([String? raw]) {
    final value = (raw ?? _controller.text).trim();
    if (value.isEmpty) return;

    setState(() {
      _chips = [
        ..._chips,
        DsEmailChipEntry(
          value: value,
          isValid: _validator(value),
        ),
      ];
      _controller.clear();
      _updateInputWidth();
    });
    _notifyChipsChanged();
    widget.onChanged?.call('');
  }

  void _removeChip(int index) {
    if (!widget.enabled) return;
    setState(() => _chips = List<DsEmailChipEntry>.from(_chips)..removeAt(index));
    _notifyChipsChanged();
  }

  void _handleChanged(String value) {
    widget.onChanged?.call(value);

    if (value.endsWith(',') ||
        value.endsWith(';') ||
        value.endsWith(' ')) {
      _commitInput(value.substring(0, value.length - 1));
      return;
    }

    _updateInputWidth();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!widget.enabled) return KeyEventResult.ignored;
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.backspace) {
      return KeyEventResult.ignored;
    }
    if (_controller.text.isEmpty && _chips.isNotEmpty) {
      setState(() => _chips = List<DsEmailChipEntry>.from(_chips)..removeLast());
      _notifyChipsChanged();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final palette = _DsTextFieldEmailPalette.resolve(
      colors: colors,
      enabled: widget.enabled,
      hasError: _hasError,
      focused: _focusNode.hasFocus,
    );

    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 250),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: _minFieldHeight),
              decoration: BoxDecoration(
                color: palette.background,
                borderRadius: BorderRadius.circular(AppRadius.xs),
                border: Border.all(
                  color: palette.border,
                  width: AppStroke.s,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.m,
                vertical: AppPadding.l,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final editorWidth = _chips.isEmpty
                      ? constraints.maxWidth
                      : math.max(
                          _minInputWidth,
                          math.min(_inputWidth, constraints.maxWidth),
                        );

                  return Focus(
                    onKeyEvent: _handleKeyEvent,
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (var i = 0; i < _chips.length; i++)
                          _EmailChip(
                            label: _chips[i].value,
                            isValid: _chipIsValid(_chips[i]),
                            enabled: widget.enabled,
                            onRemove: () => _removeChip(i),
                          ),
                        SizedBox(
                          width: editorWidth,
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            enabled: widget.enabled,
                            autofocus: widget.autofocus,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            autocorrect: false,
                            enableSuggestions: false,
                            onChanged: _handleChanged,
                            onSubmitted: _commitInput,
                            cursorColor: palette.cursor,
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: AppFont.sizeM,
                              fontWeight: AppTypography.fontWeightRegular,
                              height: AppFont.lineheightM / AppFont.sizeM,
                              letterSpacing: 0.25,
                              color: palette.input,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              hintText: _chips.isEmpty ? widget.hintText : null,
                              hintStyle: TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: AppFont.sizeM,
                                fontWeight: AppTypography.fontWeightRegular,
                                height: AppFont.lineheightM / AppFont.sizeM,
                                letterSpacing: 0.25,
                                color: palette.placeholder,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
        ),
      ),
    );
  }
}

class _EmailChip extends StatelessWidget {
  const _EmailChip({
    required this.label,
    required this.isValid,
    required this.enabled,
    required this.onRemove,
  });

  final String label;
  final bool isValid;
  final bool enabled;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    final background = isValid
        ? colors.backgroundBrandPrimary4
        : colors.backgroundErrorTertiary;
    final textColor =
        isValid ? colors.textPrimary2 : colors.backgroundErrorPrimary;
    final iconColor = isValid ? colors.textPrimary4 : colors.backgroundErrorPrimary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.s),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeM,
                fontWeight: AppTypography.fontWeightRegular,
                height: AppFont.lineheightM / AppFont.sizeM,
                letterSpacing: 0.25,
                color: textColor,
              ),
            ),
            if (enabled) ...[
              const SizedBox(width: AppSpacing.s),
              GestureDetector(
                onTap: onRemove,
                behavior: HitTestBehavior.opaque,
                child: DsIcon(
                  name: DsIconName.alinearCancel,
                  size: AppIconSize.xs,
                  color: iconColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
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

class _DsTextFieldEmailPalette {
  const _DsTextFieldEmailPalette({
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

  static _DsTextFieldEmailPalette resolve({
    required SemanticColors colors,
    required bool enabled,
    required bool hasError,
    required bool focused,
  }) {
    if (!enabled) {
      return _DsTextFieldEmailPalette(
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

    return _DsTextFieldEmailPalette(
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
