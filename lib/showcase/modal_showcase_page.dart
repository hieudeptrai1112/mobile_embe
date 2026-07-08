import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class ModalShowcasePage extends StatelessWidget {
  const ModalShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Modal',
      figmaName: 'TModalNormal',
      description:
          'Modal thông báo với illustration, nội dung và các nút hành động.',
      sections: [
        ShowcaseSection(
          title: 'Warning',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở modal Warning',
              size: DsButtonSize.medium,
              onPressed: () => _openWarning(context),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Success',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở modal Success',
              size: DsButtonSize.medium,
              onPressed: () => _openSuccess(context),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Error',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở modal Error',
              size: DsButtonSize.medium,
              onPressed: () => _openError(context),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Confirm',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở modal Confirm',
              size: DsButtonSize.medium,
              onPressed: () => _openConfirm(context),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Destructive',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở modal Destructive',
              size: DsButtonSize.medium,
              onPressed: () => _openDestructive(context),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Notification',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở modal Notification',
              size: DsButtonSize.medium,
              onPressed: () => _openNotification(context),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Multi-page',
          description: 'Modal với pagination dots (moreModal).',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở modal nhiều trang',
              size: DsButtonSize.medium,
              onPressed: () => _openMultiPage(context),
            ),
          ],
        ),
      ],
    );
  }

  static void _openWarning(BuildContext context) {
    DsModal.show(
      context: context,
      config: DsModalConfig(
        type: DsModalType.warning,
        title: 'Tittle',
        message: 'Lorem ipsum is placeholder text commonly used.',
        linkLabel: 'Text Link',
        onLinkPressed: () {},
        actions: _threeButtonActions(context, primaryLabel: 'Primary button'),
      ),
    );
  }

  static void _openSuccess(BuildContext context) {
    DsModal.show(
      context: context,
      config: DsModalConfig(
        type: DsModalType.success,
        title: 'Tittle',
        message: 'Lorem ipsum is placeholder text commonly used.',
        actions: [
          DsModalAction(
            label: 'Primary button',
            onPressed: () => Navigator.pop(context),
          ),
          DsModalAction(
            label: 'Secondary button',
            type: DsButtonType.outline,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  static void _openError(BuildContext context) {
    DsModal.show(
      context: context,
      config: DsModalConfig(
        type: DsModalType.error,
        title: 'Thông báo lỗi',
        message: 'Lorem ipsum is placeholder text commonly used.',
        errorCode: 'GW1234',
        linkLabel: 'Text Link',
        onLinkPressed: () {},
        actions: _threeButtonActions(context, primaryLabel: 'Primary button'),
      ),
    );
  }

  static void _openConfirm(BuildContext context) {
    DsModal.show(
      context: context,
      config: DsModalConfig(
        type: DsModalType.confirm,
        title: 'Tittle',
        message: 'Lorem ipsum is placeholder text commonly used.',
        actions: [
          DsModalAction(
            label: 'Xác nhận',
            onPressed: () => Navigator.pop(context),
          ),
          DsModalAction(
            label: 'Secondary button',
            type: DsButtonType.outline,
            onPressed: () => Navigator.pop(context),
          ),
          DsModalAction(
            label: 'Đóng',
            type: DsButtonType.outline,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  static void _openDestructive(BuildContext context) {
    DsModal.show(
      context: context,
      config: DsModalConfig(
        type: DsModalType.destructive,
        title: 'Tittle',
        message: 'Lorem ipsum is placeholder text commonly used.',
        actions: _threeButtonActions(context, primaryLabel: 'Primary button'),
      ),
    );
  }

  static void _openNotification(BuildContext context) {
    DsModal.show(
      context: context,
      config: DsModalConfig(
        type: DsModalType.notification,
        title: 'Tittle',
        message: 'Lorem ipsum is placeholder text commonly used.',
        linkLabel: 'Text Link',
        onLinkPressed: () {},
        actions: _threeButtonActions(context, primaryLabel: 'Primary button'),
      ),
    );
  }

  static void _openMultiPage(BuildContext context) {
    DsModal.show(
      context: context,
      config: DsModalConfig(
        type: DsModalType.warning,
        title: 'Tittle',
        message: 'Lorem ipsum is placeholder text commonly used.',
        pageCount: 4,
        currentPage: 0,
        actions: _threeButtonActions(context, primaryLabel: 'Primary button'),
      ),
    );
  }

  static List<DsModalAction> _threeButtonActions(
    BuildContext context, {
    required String primaryLabel,
  }) {
    return [
      DsModalAction(
        label: primaryLabel,
        onPressed: () => Navigator.pop(context),
      ),
      DsModalAction(
        label: 'Secondary button',
        type: DsButtonType.outline,
        onPressed: () => Navigator.pop(context),
      ),
      DsModalAction(
        label: 'Secondary button',
        type: DsButtonType.outline,
        onPressed: () => Navigator.pop(context),
      ),
    ];
  }
}
