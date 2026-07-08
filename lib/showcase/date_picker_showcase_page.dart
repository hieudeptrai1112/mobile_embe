import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class DatePickerShowcasePage extends StatefulWidget {
  const DatePickerShowcasePage({super.key});

  @override
  State<DatePickerShowcasePage> createState() => _DatePickerShowcasePageState();
}

class _DatePickerShowcasePageState extends State<DatePickerShowcasePage> {
  DateTime? _single;
  DateTimeRange? _range;
  DsDatePickerInterestResult? _interest;
  DsMonthRange? _monthRange;
  int? _year;
  TimeOfDay? _time;

  static Map<DateTime, String> get _demoInterestRates => {
        DateTime(2023, 8, 1): '2.3%',
        DateTime(2023, 8, 2): '2.3%',
        DateTime(2023, 8, 27): '2.3%',
        DateTime(2023, 8, 28): '2.3%',
        DateTime(2023, 8, 29): '2.3%',
      };

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Date Picker',
      figmaName: 'TDatePickerNormal',
      description:
          'Date picker modal cho ngày đơn, khoảng ngày, khoảng tháng, lãi suất, năm và giờ.',
      sections: [
        ShowcaseSection(
          title: 'Single Date',
          wrap: false,
          children: [
            DsButton(
              label: _single == null
                  ? 'Chọn ngày'
                  : _formatDate(_single!),
              size: DsButtonSize.medium,
              onPressed: () async {
                final picked = await DsDatePicker.showSingle(context: context);
                if (picked != null) setState(() => _single = picked);
              },
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Date Range',
          wrap: false,
          children: [
            DsButton(
              label: _range == null
                  ? 'Chọn khoảng ngày'
                  : '${_formatDate(_range!.start)} → ${_formatDate(_range!.end)}',
              size: DsButtonSize.medium,
              onPressed: () async {
                final picked = await DsDatePicker.showRange(context: context);
                if (picked != null) setState(() => _range = picked);
              },
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Range + Time',
          wrap: false,
          children: [
            DsButton(
              label: 'Khoảng thời gian + giờ',
              size: DsButtonSize.medium,
              onPressed: () => DsDatePicker.showRange(
                context: context,
                showTime: true,
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Interest',
          description: 'Chọn ngày có hiển thị lãi suất (Figma date_picker_interest).',
          wrap: false,
          children: [
            DsButton(
              label: _interest == null
                  ? 'Chọn ngày lãi suất'
                  : '${_formatDate(_interest!.date)} · ${_interest!.interestLabel}',
              size: DsButtonSize.medium,
              onPressed: () async {
                final picked = await DsDatePicker.showInterest(
                  context: context,
                  interestByDate: _demoInterestRates,
                  initialDate: DateTime(2023, 8, 1),
                  firstDate: DateTime(2023, 8, 1),
                  lastDate: DateTime(2023, 8, 31),
                );
                if (picked != null) setState(() => _interest = picked);
              },
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Month Range',
          description:
              'Chọn khoảng tháng (Figma MItemBuildingBlocksMonth).',
          wrap: false,
          children: [
            DsButton(
              label: _monthRange == null
                  ? 'Chọn khoảng tháng'
                  : '${_formatMonth(_monthRange!.start)} → ${_formatMonth(_monthRange!.end)}',
              size: DsButtonSize.medium,
              onPressed: () async {
                final picked = await DsDatePicker.showMonthRange(
                  context: context,
                  initialRange: _monthRange,
                );
                if (picked != null) setState(() => _monthRange = picked);
              },
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Year',
          wrap: false,
          children: [
            DsButton(
              label: _year == null ? 'Chọn năm' : 'Năm $_year',
              size: DsButtonSize.medium,
              onPressed: () async {
                final picked = await DsDatePicker.showYear(context: context);
                if (picked != null) setState(() => _year = picked);
              },
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Time',
          wrap: false,
          children: [
            DsButton(
              label: _time == null
                  ? 'Chọn giờ'
                  : '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}',
              size: DsButtonSize.medium,
              onPressed: () async {
                final picked = await DsDatePicker.showTime(context: context);
                if (picked != null) setState(() => _time = picked);
              },
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    return '$dd/$mm/${date.year}';
  }

  String _formatMonth(DateTime date) => 'Tháng ${date.month}/${date.year}';
}
