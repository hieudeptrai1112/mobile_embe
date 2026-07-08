import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class CheckboxShowcasePage extends StatefulWidget {
  const CheckboxShowcasePage({super.key});

  @override
  State<CheckboxShowcasePage> createState() => _CheckboxShowcasePageState();
}

class _CheckboxShowcasePageState extends State<CheckboxShowcasePage> {
  bool _checked = true;
  bool _unchecked = false;
  bool? _indeterminate;

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Checkbox',
      figmaName: 'ACheckBoxNormal',
      description:
          'Checkbox hỗ trợ checked, unchecked, indeterminate và trạng thái disabled. Có thể kèm label tùy chọn.',
      sections: [
        ShowcaseSection(
          title: 'Default',
          wrap: false,
          children: [
            DsCheckbox(
              value: _checked,
              label: 'Option',
              onChanged: (value) => setState(() => _checked = value ?? false),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Checked',
          wrap: false,
          children: [
            DsCheckbox(value: true, onChanged: _noop),
            DsCheckbox(value: true, label: 'Text', onChanged: _noop),
          ],
        ),
        ShowcaseSection(
          title: 'Unchecked',
          wrap: false,
          children: [
            DsCheckbox(value: false, onChanged: _noop),
            DsCheckbox(value: false, label: 'Text', onChanged: _noop),
          ],
        ),
        ShowcaseSection(
          title: 'Indeterminate',
          wrap: false,
          children: [
            DsCheckbox(value: null, tristate: true, onChanged: _noop),
            DsCheckbox(
              value: null,
              tristate: true,
              label: 'Text',
              onChanged: _noop,
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Disabled',
          wrap: false,
          children: [
            DsCheckbox(value: true, enabled: false),
            DsCheckbox(value: false, enabled: false),
            DsCheckbox(value: null, tristate: true, enabled: false),
            DsCheckbox(value: true, label: 'Text', enabled: false),
            DsCheckbox(value: false, label: 'Text', enabled: false),
          ],
        ),
        ShowcaseSection(
          title: 'Interactive',
          wrap: false,
          children: [
            DsCheckbox(
              value: _checked,
              label: 'Checked',
              onChanged: (value) => setState(() => _checked = value ?? false),
            ),
            DsCheckbox(
              value: _unchecked,
              label: 'Unchecked',
              onChanged: (value) => setState(() => _unchecked = value ?? false),
            ),
            DsCheckbox(
              value: _indeterminate,
              tristate: true,
              label: 'Indeterminate',
              onChanged: (value) => setState(() => _indeterminate = value),
            ),
          ],
        ),
      ],
    );
  }

  static void _noop(bool? _) {}
}
