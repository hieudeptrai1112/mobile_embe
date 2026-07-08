import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class BottomSheetShowcasePage extends StatelessWidget {
  const BottomSheetShowcasePage({super.key});

  static const _options = [
    DsBottomSheetOption(value: 'all', label: 'Tất cả'),
    DsBottomSheetOption(value: '1', label: 'Title'),
    DsBottomSheetOption(value: '2', label: 'Title'),
    DsBottomSheetOption(value: '3', label: 'Title'),
    DsBottomSheetOption(value: '4', label: 'Title'),
    DsBottomSheetOption(value: '5', label: 'Title'),
  ];

  static const _iconOptions = [
    DsBottomSheetOption(
      value: '1',
      label: 'Title',
      leading: Icon(Icons.add, size: AppIconSize.s),
    ),
    DsBottomSheetOption(
      value: '2',
      label: 'Title',
      leading: Icon(Icons.add, size: AppIconSize.s),
    ),
    DsBottomSheetOption(
      value: '3',
      label: 'Title',
      leading: Icon(Icons.add, size: AppIconSize.s),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Bottom Sheet',
      figmaName: 'TBottomsheetDropdown',
      description:
          'Bottom sheet với danh sách text, radio, checkbox và trạng thái trống.',
      sections: [
        ShowcaseSection(
          title: 'Text list',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở bottom sheet',
              onPressed: () => _openTextList(context),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Text + Icon list',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở bottom sheet',
              onPressed: () => _openIconTextList(context),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Radio list',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở bottom sheet',
              onPressed: () => _openRadioList(context),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Checkbox list',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở bottom sheet',
              onPressed: () => _openCheckboxList(context),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Empty state',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở bottom sheet',
              onPressed: () => _openEmpty(context),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Search empty',
          wrap: false,
          children: [
            DsButton(
              label: 'Mở bottom sheet',
              onPressed: () => _openSearchEmpty(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openTextList(BuildContext context) {
    return DsBottomSheet.showTextList<String>(
      context: context,
      title: 'Title',
      options: List.generate(
        12,
        (i) => DsBottomSheetOption(value: '$i', label: 'Title'),
      ),
    );
  }

  Future<void> _openIconTextList(BuildContext context) {
    return DsBottomSheet.show<String>(
      context: context,
      title: 'Title',
      child: DsBottomSheetTextList<String>(
        options: List.generate(
          8,
          (i) => DsBottomSheetOption(
            value: '$i',
            label: 'Title',
            leading: _iconOptions[i % _iconOptions.length].leading,
          ),
        ),
        onSelected: (value) => Navigator.pop(context, value),
      ),
    );
  }

  Future<void> _openRadioList(BuildContext context) {
    return DsBottomSheet.show<String>(
      context: context,
      title: 'Title',
      footer: DsBottomSheetFooter(
        actions: DsBottomSheetFooterActions(
          onReset: () => Navigator.pop(context),
          onConfirm: () => Navigator.pop(context, 'confirmed'),
        ),
      ),
      child: DsBottomSheetRadioList<String>(
        options: _options,
        initialValue: 'all',
      ),
    );
  }

  Future<void> _openCheckboxList(BuildContext context) {
    return DsBottomSheet.show<List<String>>(
      context: context,
      title: 'Title',
      footer: DsBottomSheetFooter(
        actions: DsBottomSheetFooterActions(
          onReset: () => Navigator.pop(context),
          onConfirm: () => Navigator.pop(context, <String>['1', '2']),
        ),
      ),
      child: const DsBottomSheetCheckboxList<String>(
        options: _options,
        initialValues: ['1'],
      ),
    );
  }

  Future<void> _openEmpty(BuildContext context) {
    return DsBottomSheet.show<void>(
      context: context,
      title: 'Title',
      child: const DsBottomSheetEmptyState(
        message: 'Bạn chưa có ...',
      ),
    );
  }

  Future<void> _openSearchEmpty(BuildContext context) {
    return DsBottomSheet.show<void>(
      context: context,
      title: 'Title',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DsBottomSheetSearchField(),
          DsBottomSheetEmptyState(
            title: 'Không tìm được kết quả phù hợp',
            message: 'Vui lòng tìm kiếm bằng từ khoá khác',
            illustration: DsIllustrationName.search,
          ),
        ],
      ),
    );
  }
}
