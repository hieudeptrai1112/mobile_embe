import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class ToggleShowcasePage extends StatefulWidget {
  const ToggleShowcasePage({super.key});

  @override
  State<ToggleShowcasePage> createState() => _ToggleShowcasePageState();
}

class _ToggleShowcasePageState extends State<ToggleShowcasePage> {
  bool _valueM = true;
  bool _valueL = false;

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Toggle',
      figmaName: 'MToggleNormal',
      description:
          'Toggle bật/tắt với hai kích cỡ M và L, hỗ trợ trạng thái disabled.',
      sections: [
        ShowcaseSection(
          title: 'Default',
          wrap: false,
          children: [
            DsToggle(
              value: _valueM,
              onChanged: (value) => setState(() => _valueM = value),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Size M — Off',
          wrap: false,
          children: [
            DsToggle(value: false, onChanged: _noop),
            DsToggle(value: false, enabled: false),
          ],
        ),
        ShowcaseSection(
          title: 'Size M — On',
          wrap: false,
          children: [
            DsToggle(value: true, onChanged: _noop),
            DsToggle(value: true, enabled: false),
          ],
        ),
        ShowcaseSection(
          title: 'Size L — Off',
          wrap: false,
          children: [
            DsToggle(value: false, size: DsToggleSize.l, onChanged: _noop),
            DsToggle(value: false, size: DsToggleSize.l, enabled: false),
          ],
        ),
        ShowcaseSection(
          title: 'Size L — On',
          wrap: false,
          children: [
            DsToggle(value: true, size: DsToggleSize.l, onChanged: _noop),
            DsToggle(value: true, size: DsToggleSize.l, enabled: false),
          ],
        ),
        ShowcaseSection(
          title: 'Interactive',
          wrap: false,
          children: [
            DsToggle(
              value: _valueM,
              onChanged: (value) => setState(() => _valueM = value),
            ),
            DsToggle(
              value: _valueL,
              size: DsToggleSize.l,
              onChanged: (value) => setState(() => _valueL = value),
            ),
          ],
        ),
      ],
    );
  }

  static void _noop(bool _) {}
}
