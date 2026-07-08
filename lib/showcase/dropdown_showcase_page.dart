import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class DropdownShowcasePage extends StatefulWidget {
  const DropdownShowcasePage({super.key});

  @override
  State<DropdownShowcasePage> createState() => _DropdownShowcasePageState();
}

class _DropdownShowcasePageState extends State<DropdownShowcasePage> {
  static const _items = [
    DsDropdownItem(value: 'a', label: 'Lựa chọn A'),
    DsDropdownItem(value: 'b', label: 'Lựa chọn B'),
    DsDropdownItem(value: 'c', label: 'Lựa chọn C'),
    DsDropdownItem(value: 'd', label: 'Lựa chọn D'),
    DsDropdownItem(value: 'e', label: 'Lựa chọn E'),
    DsDropdownItem(value: 'f', label: 'Lựa chọn F'),
  ];

  String? _singleOutside;
  String? _singleInside;
  List<String> _multiOutside = [];
  List<String> _multiInside = [];

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Dropdown',
      figmaName: 'MDropdownNormal',
      description:
          'Dropdown chọn đơn hoặc nhiều, tiêu đề ngoài hoặc trong field.',
      sections: [
        const ShowcaseSection(
          title: 'Title Outside — Default',
          wrap: false,
          children: [
            DsDropdown<String>(
              label: 'Tiêu đề',
              hintText: 'Lựa chọn',
              items: _items,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Title Outside — Filled',
          wrap: false,
          children: [
            DsDropdown<String>(
              label: 'Tiêu đề',
              hintText: 'Lựa chọn',
              items: _items,
              value: _singleOutside,
              onChanged: (value) => setState(() => _singleOutside = value),
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Title Outside — Error',
          wrap: false,
          children: [
            DsDropdown<String>(
              label: 'Tiêu đề',
              hintText: 'Lựa chọn',
              items: _items,
              required: true,
              errorText: 'Error Message',
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Title Outside — Disabled',
          wrap: false,
          children: [
            DsDropdown<String>(
              label: 'Tiêu đề',
              hintText: 'Lựa chọn',
              items: _items,
              enabled: false,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Title Outside — Multiple',
          wrap: false,
          children: [
            DsDropdown<String>(
              label: 'Tiêu đề',
              hintText: 'Lựa chọn',
              items: _items,
              mode: DsDropdownMode.multiple,
              values: _multiOutside,
              onMultiChanged: (values) =>
                  setState(() => _multiOutside = values),
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Title Inside — Default',
          wrap: false,
          children: [
            DsDropdown<String>(
              label: 'Tiêu đề',
              hintText: 'Lựa chọn',
              items: _items,
              titlePlacement: DsDropdownTitlePlacement.inside,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Title Inside — Filled',
          wrap: false,
          children: [
            DsDropdown<String>(
              label: 'Tiêu đề',
              hintText: 'Lựa chọn',
              items: _items,
              titlePlacement: DsDropdownTitlePlacement.inside,
              value: _singleInside,
              onChanged: (value) => setState(() => _singleInside = value),
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Title Inside — Error',
          wrap: false,
          children: [
            DsDropdown<String>(
              label: 'Tiêu đề',
              hintText: 'Lựa chọn',
              items: _items,
              titlePlacement: DsDropdownTitlePlacement.inside,
              errorText: 'Error Message',
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Title Inside — Disabled',
          wrap: false,
          children: [
            DsDropdown<String>(
              label: 'Tiêu đề',
              hintText: 'Lựa chọn',
              items: _items,
              titlePlacement: DsDropdownTitlePlacement.inside,
              enabled: false,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Title Inside — Multiple',
          wrap: false,
          children: [
            DsDropdown<String>(
              label: 'Tiêu đề',
              hintText: 'Lựa chọn',
              items: _items,
              titlePlacement: DsDropdownTitlePlacement.inside,
              mode: DsDropdownMode.multiple,
              values: _multiInside,
              onMultiChanged: (values) => setState(() => _multiInside = values),
            ),
          ],
        ),
      ],
    );
  }
}
