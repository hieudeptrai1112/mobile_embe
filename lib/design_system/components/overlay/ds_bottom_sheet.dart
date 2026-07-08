import 'package:flutter/material.dart';

import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../../illustrations/ds_illustration.dart';
import '../../illustrations/ds_illustration_assets.dart';
import '../input/ds_checkbox.dart';
import '../input/ds_radio.dart';
import '../button/ds_button.dart';

class DsBottomSheetOption<T> {
  const DsBottomSheetOption({
    required this.value,
    required this.label,
    this.leading,
  });

  final T value;
  final String label;
  final Widget? leading;
}

class DsBottomSheetFooterActions {
  const DsBottomSheetFooterActions({
    this.resetLabel = 'Thiết lập lại',
    this.confirmLabel = 'Tìm kiếm',
    this.onReset,
    this.onConfirm,
  });

  final String resetLabel;
  final String confirmLabel;
  final VoidCallback? onReset;
  final VoidCallback? onConfirm;
}

/// Bottom sheet from Figma `TBottomsheetDropdown` (Design System V2 Mobile).
abstract final class DsBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    Widget? footer,
    bool isScrollControlled = true,
    double maxHeightFactor = 0.9,
  }) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      barrierColor: colors.overlayPrimary,
      builder: (context) {
        final maxHeight = MediaQuery.sizeOf(context).height * maxHeightFactor;
        return DsBottomSheetShell(
          title: title,
          footer: footer,
          maxHeight: maxHeight,
          child: child,
        );
      },
    );
  }

  static Future<T?> showTextList<T>({
    required BuildContext context,
    required String title,
    required List<DsBottomSheetOption<T>> options,
  }) {
    return show<T>(
      context: context,
      title: title,
      child: DsBottomSheetTextList<T>(
        options: options,
        onSelected: (value) => Navigator.pop(context, value),
      ),
    );
  }

  static Future<T?> showRadioList<T>({
    required BuildContext context,
    required String title,
    required List<DsBottomSheetOption<T>> options,
    T? initialValue,
    DsBottomSheetFooterActions? footer,
  }) {
    return show<T>(
      context: context,
      title: title,
      footer: footer != null ? DsBottomSheetFooter(actions: footer) : null,
      child: DsBottomSheetRadioList<T>(
        options: options,
        initialValue: initialValue,
        onConfirmed: footer?.onConfirm == null
            ? (value) => Navigator.pop(context, value)
            : null,
      ),
    );
  }

  static Future<List<T>?> showCheckboxList<T>({
    required BuildContext context,
    required String title,
    required List<DsBottomSheetOption<T>> options,
    List<T> initialValues = const [],
    DsBottomSheetFooterActions? footer,
  }) {
    return show<List<T>>(
      context: context,
      title: title,
      footer: footer != null ? DsBottomSheetFooter(actions: footer) : null,
      child: DsBottomSheetCheckboxList<T>(
        options: options,
        initialValues: initialValues,
        onConfirmed: footer?.onConfirm == null
            ? (values) => Navigator.pop(context, values)
            : null,
      ),
    );
  }
}

class DsBottomSheetShell extends StatelessWidget {
  const DsBottomSheetShell({
    super.key,
    required this.title,
    required this.child,
    this.footer,
    this.maxHeight,
  });

  final String title;
  final Widget child;
  final Widget? footer;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight ?? double.infinity),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.backgroundPrimary,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.l),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DsBottomSheetHeader(
                title: title,
                onClose: () => Navigator.pop(context),
              ),
              Flexible(child: child),
              ?footer,
              SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ],
          ),
        ),
      ),
    );
  }
}

class DsBottomSheetHeader extends StatelessWidget {
  const DsBottomSheetHeader({
    super.key,
    required this.title,
    required this.onClose,
  });

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.xl,
        vertical: AppPadding.l,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.borderPrimary, width: AppStroke.s),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: AppIconSize.m),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeL,
                fontWeight: AppTypography.fontWeightSemibold,
                height: AppFont.lineheightL / AppFont.sizeL,
                color: colors.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.close,
              size: AppIconSize.m,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class DsBottomSheetFooter extends StatelessWidget {
  const DsBottomSheetFooter({super.key, required this.actions});

  final DsBottomSheetFooterActions actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppPadding.xl,
        AppPadding.l,
        AppPadding.xl,
        AppPadding.l,
      ),
      child: Row(
        children: [
          Expanded(
            child: DsButton(
              label: actions.resetLabel,
              type: DsButtonType.outline,
              size: DsButtonSize.medium,
              onPressed: actions.onReset,
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: DsButton(
              label: actions.confirmLabel,
              size: DsButtonSize.medium,
              onPressed: actions.onConfirm,
            ),
          ),
        ],
      ),
    );
  }
}

class DsBottomSheetTextList<T> extends StatelessWidget {
  const DsBottomSheetTextList({
    super.key,
    required this.options,
    required this.onSelected,
  });

  final List<DsBottomSheetOption<T>> options;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: options.length,
      separatorBuilder: (_, _) => const SizedBox.shrink(),
      itemBuilder: (context, index) {
        final option = options[index];
        final isLast = index == options.length - 1;
        return DsBottomSheetItemTile(
          label: option.label,
          leading: option.leading,
          showDivider: !isLast,
          onTap: () => onSelected(option.value),
        );
      },
    );
  }
}

class DsBottomSheetRadioList<T> extends StatefulWidget {
  const DsBottomSheetRadioList({
    super.key,
    required this.options,
    this.initialValue,
    this.onConfirmed,
  });

  final List<DsBottomSheetOption<T>> options;
  final T? initialValue;
  final ValueChanged<T?>? onConfirmed;

  @override
  State<DsBottomSheetRadioList<T>> createState() =>
      _DsBottomSheetRadioListState<T>();
}

class _DsBottomSheetRadioListState<T> extends State<DsBottomSheetRadioList<T>> {
  late T? _selected = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: widget.options.length,
      separatorBuilder: (_, _) => const SizedBox.shrink(),
      itemBuilder: (context, index) {
        final option = widget.options[index];
        final isLast = index == widget.options.length - 1;

        return DsBottomSheetItemTile(
          label: option.label,
          showDivider: !isLast,
          useCompactPadding: true,
          leading: DsRadio<T>(
            value: option.value,
            groupValue: _selected,
          ),
          onTap: () {
            setState(() => _selected = option.value);
            widget.onConfirmed?.call(_selected);
          },
        );
      },
    );
  }
}

class DsBottomSheetCheckboxList<T> extends StatefulWidget {
  const DsBottomSheetCheckboxList({
    super.key,
    required this.options,
    this.initialValues = const [],
    this.onConfirmed,
  });

  final List<DsBottomSheetOption<T>> options;
  final List<T> initialValues;
  final ValueChanged<List<T>>? onConfirmed;

  @override
  State<DsBottomSheetCheckboxList<T>> createState() =>
      _DsBottomSheetCheckboxListState<T>();
}

class _DsBottomSheetCheckboxListState<T>
    extends State<DsBottomSheetCheckboxList<T>> {
  late final List<T> _selected = List<T>.from(widget.initialValues);

  void _toggle(T value, bool? checked) {
    setState(() {
      if (checked == true) {
        if (!_selected.contains(value)) _selected.add(value);
      } else {
        _selected.remove(value);
      }
    });
    widget.onConfirmed?.call(_selected);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: widget.options.length,
      separatorBuilder: (_, _) => const SizedBox.shrink(),
      itemBuilder: (context, index) {
        final option = widget.options[index];
        final isLast = index == widget.options.length - 1;
        final checked = _selected.contains(option.value);

        return DsBottomSheetItemTile(
          label: option.label,
          showDivider: !isLast,
          useCompactPadding: true,
          useLightDivider: true,
          leading: DsCheckbox(
            value: checked,
            onChanged: (value) => _toggle(option.value, value),
          ),
          onTap: () => _toggle(option.value, !checked),
        );
      },
    );
  }
}

class DsBottomSheetItemTile extends StatelessWidget {
  const DsBottomSheetItemTile({
    super.key,
    required this.label,
    this.leading,
    this.onTap,
    this.showDivider = true,
    this.useCompactPadding = false,
    this.useLightDivider = false,
  });

  final String label;
  final Widget? leading;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool useCompactPadding;
  final bool useLightDivider;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final dividerColor = useLightDivider
        ? colors.backgroundBrandPrimary5
        : colors.borderPrimary;

    return Material(
      color: colors.backgroundPrimary,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.xl),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: useCompactPadding ? AppPadding.m : 14,
            ),
            decoration: BoxDecoration(
              border: showDivider
                  ? Border(
                      bottom: BorderSide(
                        color: dividerColor,
                        width: AppStroke.s,
                      ),
                    )
                  : null,
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: AppSpacing.s),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: AppFont.sizeM,
                      fontWeight: AppTypography.fontWeightRegular,
                      height: AppFont.lineheightM / AppFont.sizeM,
                      letterSpacing: 0.25,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DsBottomSheetSearchField extends StatelessWidget {
  const DsBottomSheetSearchField({
    super.key,
    this.controller,
    this.hintText = 'Tìm kiếm',
    this.onChanged,
    this.onClear,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppPadding.xl,
        AppPadding.n2xl,
        AppPadding.xl,
        AppPadding.s,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: AppFont.sizeM,
          color: colors.textPrimary,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.all(AppPadding.m),
          prefixIcon: Icon(
            Icons.search,
            size: AppIconSize.m,
            color: colors.iconBrandPrimary1,
          ),
          suffixIcon: onClear != null
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    size: AppIconSize.s,
                    color: colors.iconBrandPrimary1,
                  ),
                  onPressed: onClear,
                )
              : null,
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeM,
            color: colors.textPrimary,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.xs),
            borderSide: BorderSide(color: colors.borderPrimary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.xs),
            borderSide: BorderSide(color: colors.borderBrandTertiary),
          ),
          filled: true,
          fillColor: colors.backgroundPrimary,
        ),
      ),
    );
  }
}

class DsBottomSheetEmptyState extends StatelessWidget {
  const DsBottomSheetEmptyState({
    super.key,
    required this.message,
    this.title,
    this.illustration = DsIllustrationName.empty,
    this.icon,
  });

  final String message;
  final String? title;
  final DsIllustrationName illustration;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.xl,
        vertical: AppPadding.n2xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            SizedBox(
              width: 100,
              height: 100,
              child: Icon(
                icon,
                size: AppIconSize.n2xl,
                color: colors.borderTertiary,
              ),
            )
          else
            DsIllustration(
              name: illustration,
              width: 100,
              height: 100,
            ),
          const SizedBox(height: AppSpacing.l),
          if (title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeM,
                fontWeight: AppTypography.fontWeightSemibold,
                height: AppFont.lineheightM / AppFont.sizeM,
                letterSpacing: 0.5,
                color: colors.textPrimary,
              ),
            ),
          if (title != null) const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: title == null ? AppFont.sizeM : AppFont.sizeS,
              fontWeight: AppTypography.fontWeightRegular,
              height: title == null
                  ? AppFont.lineheightM / AppFont.sizeM
                  : AppFont.lineheightS / AppFont.sizeS,
              letterSpacing: title == null ? 0.25 : 0,
              color: title == null ? colors.textSecondary : colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
