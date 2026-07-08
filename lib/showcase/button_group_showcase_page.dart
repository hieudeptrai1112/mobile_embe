import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class ButtonGroupShowcasePage extends StatelessWidget {
  const ButtonGroupShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return ShowcaseDocPage(
      title: 'Button Group',
      figmaName: 'TBottomButtonGroup',
      description:
          'Nhóm nút cố định ở cuối màn hình, hỗ trợ layout ngang/dọc và chế độ chọn nhiều.',
      sections: [
        ShowcaseSection(
          title: '1 Button — Horizontal',
          wrap: false,
          children: [
            _PreviewShell(
              backgroundColor: colors.backgroundBrandPrimary5,
              child: const DsButtonGroup(
                primaryLabel: 'Text',
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: '2 Buttons — Horizontal',
          wrap: false,
          children: [
            _PreviewShell(
              backgroundColor: colors.backgroundBrandPrimary5,
              child: const DsButtonGroup(
                primaryLabel: 'Text',
                secondaryLabel: 'Text',
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: '2 Buttons — Vertical',
          wrap: false,
          children: [
            _PreviewShell(
              backgroundColor: colors.backgroundBrandPrimary5,
              child: const DsButtonGroup(
                primaryLabel: 'Text',
                secondaryLabel: 'Text',
                axis: DsButtonGroupAxis.vertical,
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: '1 Button + Selection',
          wrap: false,
          children: [
            _PreviewShell(
              backgroundColor: colors.backgroundBrandPrimary5,
              child: const DsButtonGroup(
                primaryLabel: 'Text',
                selectedCount: 1,
                totalCount: 7,
                selectAllLabel: 'Chọn tất cả',
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: '2 Buttons + Selection — Horizontal',
          wrap: false,
          children: [
            _PreviewShell(
              backgroundColor: colors.backgroundBrandPrimary5,
              child: const DsButtonGroup(
                primaryLabel: 'Text',
                secondaryLabel: 'Text',
                selectedCount: 1,
                totalCount: 7,
                selectAllLabel: 'Chọn tất cả',
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: '2 Buttons + Selection — Vertical',
          wrap: false,
          children: [
            _PreviewShell(
              backgroundColor: colors.backgroundBrandPrimary5,
              child: const DsButtonGroup(
                primaryLabel: 'Text',
                secondaryLabel: 'Text',
                axis: DsButtonGroupAxis.vertical,
                selectedCount: 1,
                totalCount: 7,
                selectAllLabel: 'Chọn tất cả',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PreviewShell extends StatelessWidget {
  const _PreviewShell({
    required this.backgroundColor,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: child,
    );
  }
}
