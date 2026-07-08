import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class DateFieldShowcasePage extends StatefulWidget {
  const DateFieldShowcasePage({super.key});

  @override
  State<DateFieldShowcasePage> createState() => _DateFieldShowcasePageState();
}

class _DateFieldShowcasePageState extends State<DateFieldShowcasePage> {
  DateTime? _single;
  DateTimeRange? _range;

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Date Field',
      figmaName: 'ODateFieldNormal',
      description:
          'Field chọn ngày đơn hoặc khoảng ngày, hỗ trợ error và disabled.',
      sections: [
        ShowcaseSection(
          title: 'Single - Default',
          wrap: false,
          children: [
            DsDateField.single(
              initialDate: _single,
              onDateChanged: (value) => setState(() => _single = value),
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Single - Disabled',
          wrap: false,
          children: [
            DsDateField.single(enabled: false),
          ],
        ),
        const ShowcaseSection(
          title: 'Single - Error',
          wrap: false,
          children: [
            DsDateField.single(errorText: 'Error message'),
          ],
        ),
        ShowcaseSection(
          title: 'Range - Default',
          wrap: false,
          children: [
            DsDateField.range(
              initialRange: _range,
              onRangeChanged: (value) => setState(() => _range = value),
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Range - Disabled',
          wrap: false,
          children: [
            DsDateField.range(enabled: false),
          ],
        ),
        const ShowcaseSection(
          title: 'Range - Error',
          wrap: false,
          children: [
            DsDateField.range(errorText: 'Error message'),
          ],
        ),
      ],
    );
  }
}
