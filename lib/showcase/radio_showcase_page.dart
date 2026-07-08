import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class RadioShowcasePage extends StatefulWidget {
  const RadioShowcasePage({super.key});

  @override
  State<RadioShowcasePage> createState() => _RadioShowcasePageState();
}

class _RadioShowcasePageState extends State<RadioShowcasePage> {
  String? _groupValue = 'a';

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Radio',
      figmaName: 'MRadioNormal',
      description:
          'Radio button cho phép chọn một lựa chọn trong nhóm. Hỗ trợ label và trạng thái disabled.',
      sections: [
        ShowcaseSection(
          title: 'Default',
          wrap: false,
          children: [
            DsRadio<String>(
              value: 'a',
              groupValue: _groupValue,
              label: 'Option A',
              onChanged: (value) => setState(() => _groupValue = value),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Selected',
          wrap: false,
          children: [
            DsRadio<String>(
              value: 'a',
              groupValue: 'a',
              onChanged: _noop,
            ),
            DsRadio<String>(
              value: 'a',
              groupValue: 'a',
              label: 'Text',
              onChanged: _noop,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Unselected',
          wrap: false,
          children: [
            DsRadio<String>(
              value: 'a',
              groupValue: 'b',
              onChanged: _noop,
            ),
            DsRadio<String>(
              value: 'a',
              groupValue: 'b',
              label: 'Text',
              onChanged: _noop,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Disabled',
          wrap: false,
          children: [
            DsRadio<String>(
              value: 'a',
              groupValue: 'a',
              enabled: false,
            ),
            DsRadio<String>(
              value: 'a',
              groupValue: 'b',
              enabled: false,
            ),
            DsRadio<String>(
              value: 'a',
              groupValue: 'a',
              label: 'Text',
              enabled: false,
            ),
            DsRadio<String>(
              value: 'a',
              groupValue: 'b',
              label: 'Text',
              enabled: false,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Interactive',
          wrap: false,
          children: [
            DsRadio<String>(
              value: 'a',
              groupValue: _groupValue,
              label: 'Option A',
              onChanged: (value) => setState(() => _groupValue = value),
            ),
            DsRadio<String>(
              value: 'b',
              groupValue: _groupValue,
              label: 'Option B',
              onChanged: (value) => setState(() => _groupValue = value),
            ),
            DsRadio<String>(
              value: 'c',
              groupValue: _groupValue,
              label: 'Option C',
              onChanged: (value) => setState(() => _groupValue = value),
            ),
          ],
        ),
      ],
    );
  }

  static void _noop(String? _) {}
}
