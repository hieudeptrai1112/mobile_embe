import 'package:flutter/material.dart';

import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';
import 'ds_button.dart';
import 'ds_button_link.dart';

enum DsButtonGroupAxis { horizontal, vertical }

/// Bottom button group from Figma `TBottomButtonGroup` (Design System V2 Mobile).
///
/// Supports single or dual buttons in horizontal/vertical layout,
/// optional selection count row, and sticky footer shell styling.
class DsButtonGroup extends StatelessWidget {
  const DsButtonGroup({
    super.key,
    required this.primaryLabel,
    this.secondaryLabel,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.axis = DsButtonGroupAxis.horizontal,
    this.showBackground = true,
    this.selectedCount,
    this.totalCount,
    this.selectionPrefix = 'Đã chọn:',
    this.selectAllLabel,
    this.onSelectAll,
  });

  final String primaryLabel;
  final String? secondaryLabel;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final DsButtonGroupAxis axis;
  final bool showBackground;
  final int? selectedCount;
  final int? totalCount;
  final String selectionPrefix;
  final String? selectAllLabel;
  final VoidCallback? onSelectAll;

  bool get _hasSecondary => secondaryLabel != null;
  bool get _showSelection =>
      selectedCount != null && totalCount != null;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_showSelection) ...[
          _DsButtonGroupSelectionRow(
            prefix: selectionPrefix,
            selectedCount: selectedCount!,
            totalCount: totalCount!,
            selectAllLabel: selectAllLabel,
            onSelectAll: onSelectAll,
          ),
          const SizedBox(height: AppSpacing.l),
        ],
        _buildButtons(),
      ],
    );

    if (!showBackground) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppPadding.xl,
          AppPadding.l,
          AppPadding.xl,
          34,
        ),
        child: content,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.backgroundPrimary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.l),
        ),
        border: Border(
          top: BorderSide(
            color: colors.backgroundBrandPrimary4,
            width: AppStroke.s,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppPadding.xl,
          AppPadding.l,
          AppPadding.xl,
          34,
        ),
        child: content,
      ),
    );
  }

  Widget _buildButtons() {
    if (!_hasSecondary) {
      return DsButton(
        label: primaryLabel,
        size: DsButtonSize.medium,
        onPressed: onPrimaryPressed,
      );
    }

    if (axis == DsButtonGroupAxis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DsButton(
            label: primaryLabel,
            size: DsButtonSize.medium,
            onPressed: onPrimaryPressed,
          ),
          const SizedBox(height: AppSpacing.m),
          DsButton(
            label: secondaryLabel!,
            type: DsButtonType.outline,
            size: DsButtonSize.medium,
            onPressed: onSecondaryPressed,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: DsButton(
            label: secondaryLabel!,
            type: DsButtonType.outline,
            size: DsButtonSize.medium,
            onPressed: onSecondaryPressed,
          ),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: DsButton(
            label: primaryLabel,
            size: DsButtonSize.medium,
            onPressed: onPrimaryPressed,
          ),
        ),
      ],
    );
  }
}

class _DsButtonGroupSelectionRow extends StatelessWidget {
  const _DsButtonGroupSelectionRow({
    required this.prefix,
    required this.selectedCount,
    required this.totalCount,
    this.selectAllLabel,
    this.onSelectAll,
  });

  final String prefix;
  final int selectedCount;
  final int totalCount;
  final String? selectAllLabel;
  final VoidCallback? onSelectAll;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return Row(
      children: [
        Expanded(
          child: Text(
            '$prefix $selectedCount/$totalCount',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              fontWeight: AppTypography.fontWeightSemibold,
              height: AppFont.lineheightM / AppFont.sizeM,
              letterSpacing: 0.5,
              color: colors.textPrimary,
            ),
          ),
        ),
        if (selectAllLabel != null)
          DsButtonLink(
            label: selectAllLabel!,
            size: DsButtonSize.medium,
            onPressed: onSelectAll,
          ),
      ],
    );
  }
}
