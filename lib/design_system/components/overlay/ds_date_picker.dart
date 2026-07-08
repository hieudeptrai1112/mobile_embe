import 'package:flutter/material.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../button/ds_button.dart';

enum DsDatePickerMode { single, range, interest }

/// Selected date and its interest label from [DsDatePicker.showInterest].
class DsDatePickerInterestResult {
  const DsDatePickerInterestResult({
    required this.date,
    required this.interestLabel,
  });

  final DateTime date;
  final String interestLabel;
}

/// A month-level range (inclusive), each bound is the first day of a month.
class DsMonthRange {
  const DsMonthRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

/// Date picker from Figma `TDatePickerNormal` (Design System V2 Mobile).
abstract final class DsDatePicker {
  static Future<DateTime?> showSingle({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String title = 'Thời gian',
    String resetLabel = 'Thiết lập lại',
    String applyLabel = 'Áp dụng',
  }) {
    return showDialog<DateTime>(
      context: context,
      barrierColor: _colors(context).overlayPrimary,
      builder: (context) => _DsDatePickerDialog(
        mode: DsDatePickerMode.single,
        title: title,
        resetLabel: resetLabel,
        applyLabel: applyLabel,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
  }

  static Future<DateTimeRange?> showRange({
    required BuildContext context,
    DateTimeRange? initialRange,
    DateTime? firstDate,
    DateTime? lastDate,
    String title = 'Khoảng thời gian',
    String resetLabel = 'Thiết lập lại',
    String applyLabel = 'Áp dụng',
    bool showQuickSelect = true,
    bool showTime = false,
    List<int> quickSelectDays = const [7, 15, 30, 45],
  }) {
    return showDialog<DateTimeRange>(
      context: context,
      barrierColor: _colors(context).overlayPrimary,
      builder: (context) => _DsDatePickerDialog(
        mode: DsDatePickerMode.range,
        title: title,
        resetLabel: resetLabel,
        applyLabel: applyLabel,
        initialRange: initialRange,
        firstDate: firstDate,
        lastDate: lastDate,
        showQuickSelect: showQuickSelect,
        showTime: showTime,
        quickSelectDays: quickSelectDays,
      ),
    );
  }

  /// Interest date picker from Figma `date_picker_interest`.
  ///
  /// Only dates present in [interestByDate] are selectable. Each day shows its
  /// interest label (e.g. `2.3%`) below the date number.
  static Future<DsDatePickerInterestResult?> showInterest({
    required BuildContext context,
    required Map<DateTime, String> interestByDate,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String title = 'Khoảng thời gian',
    String resetLabel = 'Thiết lập lại',
    String applyLabel = 'Áp dụng',
  }) {
    return showDialog<DsDatePickerInterestResult>(
      context: context,
      barrierColor: _colors(context).overlayPrimary,
      builder: (context) => _DsDatePickerDialog(
        mode: DsDatePickerMode.interest,
        title: title,
        resetLabel: resetLabel,
        applyLabel: applyLabel,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        interestByDate: interestByDate,
      ),
    );
  }

  static Future<DsMonthRange?> showMonthRange({
    required BuildContext context,
    DsMonthRange? initialRange,
    DateTime? firstMonth,
    DateTime? lastMonth,
    String title = 'Thời gian',
    String resetLabel = 'Thiết lập lại',
    String applyLabel = 'Áp dụng',
  }) {
    return showDialog<DsMonthRange>(
      context: context,
      barrierColor: _colors(context).overlayPrimary,
      builder: (context) => _DsMonthRangePickerDialog(
        title: title,
        resetLabel: resetLabel,
        applyLabel: applyLabel,
        initialRange: initialRange,
        firstMonth: firstMonth,
        lastMonth: lastMonth,
      ),
    );
  }

  static Future<int?> showYear({
    required BuildContext context,
    int? initialYear,
    int? firstYear,
    int? lastYear,
    String title = 'Thời gian',
    String resetLabel = 'Thiết lập lại',
    String applyLabel = 'Áp dụng',
  }) {
    return showDialog<int>(
      context: context,
      barrierColor: _colors(context).overlayPrimary,
      builder: (context) => _DsYearPickerDialog(
        title: title,
        resetLabel: resetLabel,
        applyLabel: applyLabel,
        initialYear: initialYear,
        firstYear: firstYear,
        lastYear: lastYear,
      ),
    );
  }

  static Future<TimeOfDay?> showTime({
    required BuildContext context,
    TimeOfDay? initialTime,
    String title = 'Thời gian',
    String cancelLabel = 'Huỷ bỏ',
    String applyLabel = 'Áp dụng',
  }) {
    return showDialog<TimeOfDay>(
      context: context,
      barrierColor: _colors(context).overlayPrimary,
      builder: (context) => _DsTimePickerDialog(
        title: title,
        cancelLabel: cancelLabel,
        applyLabel: applyLabel,
        initialTime: initialTime,
      ),
    );
  }

  static SemanticColors _colors(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
  }
}

enum _DsCalendarView { day, month, year }

enum _DsDayCellState {
  normal,
  disabled,
  today,
  selected,
  rangeStart,
  rangeMiddle,
  rangeEnd,
}

class _DsDatePickerDialog extends StatefulWidget {
  const _DsDatePickerDialog({
    required this.mode,
    required this.title,
    required this.resetLabel,
    required this.applyLabel,
    this.initialDate,
    this.initialRange,
    this.firstDate,
    this.lastDate,
    this.showQuickSelect = false,
    this.showTime = false,
    this.quickSelectDays = const [7, 15, 30, 45],
    this.interestByDate = const {},
  });

  final DsDatePickerMode mode;
  final String title;
  final String resetLabel;
  final String applyLabel;
  final DateTime? initialDate;
  final DateTimeRange? initialRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showQuickSelect;
  final bool showTime;
  final List<int> quickSelectDays;
  final Map<DateTime, String> interestByDate;

  @override
  State<_DsDatePickerDialog> createState() => _DsDatePickerDialogState();
}

class _DsDatePickerDialogState extends State<_DsDatePickerDialog> {
  static const _weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  late DateTime _focusedMonth;
  late DateTime? _selectedDate;
  late DateTime? _rangeStart;
  late DateTime? _rangeEnd;
  late _DsCalendarView _view;
  late int _rangeTab;
  int? _quickDays;
  TimeOfDay _time = TimeOfDay.now();

  DateTime get _firstDate =>
      widget.firstDate ?? DateTime(DateTime.now().year - 10);
  DateTime get _lastDate =>
      widget.lastDate ?? DateTime(DateTime.now().year + 10);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    if (widget.mode == DsDatePickerMode.single ||
        widget.mode == DsDatePickerMode.interest) {
      _selectedDate = widget.initialDate;
      _focusedMonth = _selectedDate ?? now;
    } else {
      _rangeStart = widget.initialRange?.start;
      _rangeEnd = widget.initialRange?.end;
      _focusedMonth = _rangeStart ?? _rangeEnd ?? now;
      _rangeTab = 0;
    }
    _view = _DsCalendarView.day;
  }

  DateTime? get _activeDate => switch (widget.mode) {
        DsDatePickerMode.single || DsDatePickerMode.interest => _selectedDate,
        DsDatePickerMode.range => _rangeTab == 0 ? _rangeStart : _rangeEnd,
      };

  String? _interestLabelFor(DateTime day) {
    for (final entry in widget.interestByDate.entries) {
      if (_isSameDay(entry.key, day)) return entry.value;
    }
    return null;
  }

  void _reset() {
    setState(() {
      if (widget.mode == DsDatePickerMode.single ||
          widget.mode == DsDatePickerMode.interest) {
        _selectedDate = widget.initialDate;
        _focusedMonth = _selectedDate ?? DateTime.now();
      } else {
        _rangeStart = widget.initialRange?.start;
        _rangeEnd = widget.initialRange?.end;
        _focusedMonth = _rangeStart ?? DateTime.now();
        _quickDays = null;
        _rangeTab = 0;
      }
      _view = _DsCalendarView.day;
      _time = TimeOfDay.now();
    });
  }

  void _apply() {
    if (widget.mode == DsDatePickerMode.interest) {
      if (_selectedDate == null) return;
      final label = _interestLabelFor(_selectedDate!);
      if (label == null) return;
      Navigator.pop(
        context,
        DsDatePickerInterestResult(
          date: _selectedDate!,
          interestLabel: label,
        ),
      );
      return;
    }
    if (widget.mode == DsDatePickerMode.single) {
      Navigator.pop(context, _selectedDate);
      return;
    }
    if (_rangeStart != null && _rangeEnd != null) {
      var start = _rangeStart!;
      var end = _rangeEnd!;
      if (end.isBefore(start)) {
        final temp = start;
        start = end;
        end = temp;
      }
      if (widget.showTime) {
        start = DateTime(
          start.year,
          start.month,
          start.day,
          _time.hour,
          _time.minute,
        );
        end = DateTime(
          end.year,
          end.month,
          end.day,
          _time.hour,
          _time.minute,
        );
      }
      Navigator.pop(context, DateTimeRange(start: start, end: end));
    }
  }

  void _selectDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    if (normalized.isBefore(_dateOnly(_firstDate)) ||
        normalized.isAfter(_dateOnly(_lastDate))) {
      return;
    }
    setState(() {
      if (widget.mode == DsDatePickerMode.single ||
          widget.mode == DsDatePickerMode.interest) {
        if (widget.mode == DsDatePickerMode.interest &&
            _interestLabelFor(normalized) == null) {
          return;
        }
        _selectedDate = normalized;
      } else if (_rangeTab == 0) {
        _rangeStart = normalized;
        _quickDays = null;
      } else {
        _rangeEnd = normalized;
        _quickDays = null;
      }
    });
  }

  void _applyQuickDays(int days) {
    final end = _dateOnly(DateTime.now());
    final start = end.subtract(Duration(days: days - 1));
    setState(() {
      _quickDays = days;
      _rangeStart = start;
      _rangeEnd = end;
      _focusedMonth = start;
      _rangeTab = 0;
    });
  }

  void _toggleView() {
    setState(() {
      _view = switch (_view) {
        _DsCalendarView.day => _DsCalendarView.month,
        _DsCalendarView.month => _DsCalendarView.year,
        _DsCalendarView.year => _DsCalendarView.day,
      };
    });
  }

  void _navigatePrev() {
    setState(() {
      _focusedMonth = switch (_view) {
        _DsCalendarView.day => DateTime(
            _focusedMonth.year,
            _focusedMonth.month - 1,
          ),
        _DsCalendarView.month => DateTime(_focusedMonth.year - 1),
        _DsCalendarView.year => DateTime(_focusedMonth.year - 12),
      };
    });
  }

  void _navigateNext() {
    setState(() {
      _focusedMonth = switch (_view) {
        _DsCalendarView.day => DateTime(
            _focusedMonth.year,
            _focusedMonth.month + 1,
          ),
        _DsCalendarView.month => DateTime(_focusedMonth.year + 1),
        _DsCalendarView.year => DateTime(_focusedMonth.year + 12),
      };
    });
  }

  void _selectMonth(int month) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, month);
      _view = _DsCalendarView.day;
    });
  }

  void _selectYear(int year) {
    setState(() {
      _focusedMonth = DateTime(year, _focusedMonth.month);
      _view = _DsCalendarView.month;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppPadding.s),
      child: Container(
        width: AppWidth.xl,
        decoration: BoxDecoration(
          color: colors.backgroundPrimary,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DsPickerHeader(
              title: widget.title,
              onClose: () => Navigator.pop(context),
            ),
            if (widget.mode == DsDatePickerMode.range && widget.showQuickSelect)
              _DsQuickSelectRow(
                days: widget.quickSelectDays,
                selectedDays: _quickDays,
                onSelected: _applyQuickDays,
              ),
            if (widget.mode == DsDatePickerMode.range)
              _DsRangeTabs(
                selectedIndex: _rangeTab,
                onChanged: (index) => setState(() => _rangeTab = index),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.m),
              child: Column(
                children: [
                  _DsPickerNavBar(
                    title: _navTitle(),
                    showUpChevron: _view == _DsCalendarView.year,
                    onTitleTap: _toggleView,
                    onPrev: _navigatePrev,
                    onNext: _navigateNext,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: switch (_view) {
                      _DsCalendarView.day => widget.mode ==
                              DsDatePickerMode.interest
                          ? _buildInterestDayGrid(colors)
                          : _buildDayGrid(colors),
                      _DsCalendarView.month => _buildMonthGrid(colors),
                      _DsCalendarView.year => _buildYearGrid(colors),
                    },
                  ),
                  if (widget.showTime && widget.mode == DsDatePickerMode.range)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.m,
                        bottom: AppSpacing.l,
                      ),
                      child: _DsTimeField(
                        time: _time,
                        onTap: () async {
                          final picked = await DsDatePicker.showTime(
                            context: context,
                            initialTime: _time,
                          );
                          if (picked != null) {
                            setState(() => _time = picked);
                          }
                        },
                      ),
                    )
                  else
                    const SizedBox(height: AppSpacing.l),
                ],
              ),
            ),
            _DsPickerFooter(
              resetLabel: widget.resetLabel,
              applyLabel: widget.applyLabel,
              onReset: _reset,
              onApply: _apply,
            ),
          ],
        ),
      ),
    );
  }

  String _navTitle() {
    return switch (_view) {
      _DsCalendarView.day =>
        'Tháng ${_focusedMonth.month} ${_focusedMonth.year}',
      _DsCalendarView.month => '${_focusedMonth.year}',
      _DsCalendarView.year => _yearRangeLabel(_focusedMonth.year),
    };
  }

  Widget _buildDayGrid(SemanticColors colors) {
    final weeks = _buildWeeks(_focusedMonth);
    return Column(
      key: const ValueKey('day'),
      children: [
        Row(
          children: _weekdays
              .map(
                (label) => Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: _dayLabelStyle(colors, selected: false),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.l),
        ...weeks.map(
          (week) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: week.map((day) {
                if (day == null) {
                  return const Expanded(child: SizedBox(height: 42));
                }
                final inMonth = day.month == _focusedMonth.month;
                final enabled = !day.isBefore(_dateOnly(_firstDate)) &&
                    !day.isAfter(_dateOnly(_lastDate));
                return Expanded(
                  child: _DsDayCell(
                    day: day.day,
                    state: _dayCellState(day, inMonth: inMonth, enabled: enabled),
                    onTap: enabled ? () => _selectDay(day) : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  _DsDayCellState _dayCellState(
    DateTime day, {
    required bool inMonth,
    required bool enabled,
  }) {
    if (!inMonth) return _DsDayCellState.normal;
    if (!enabled) return _DsDayCellState.disabled;

    final normalized = _dateOnly(day);
    final isToday = _isSameDay(day, DateTime.now());

    if (widget.mode == DsDatePickerMode.single) {
      if (_isSameDay(day, _selectedDate)) return _DsDayCellState.selected;
      if (isToday) return _DsDayCellState.today;
      return _DsDayCellState.normal;
    }

    final start = _rangeStart;
    final end = _rangeEnd;

    if (start != null && end != null) {
      var rangeStart = _dateOnly(start);
      var rangeEnd = _dateOnly(end);
      if (rangeEnd.isBefore(rangeStart)) {
        final temp = rangeStart;
        rangeStart = rangeEnd;
        rangeEnd = temp;
      }

      if (_isSameDay(day, rangeStart) && _isSameDay(day, rangeEnd)) {
        return _DsDayCellState.selected;
      }
      if (_isSameDay(day, rangeStart)) return _DsDayCellState.rangeStart;
      if (_isSameDay(day, rangeEnd)) return _DsDayCellState.rangeEnd;
      if (normalized.isAfter(rangeStart) && normalized.isBefore(rangeEnd)) {
        return _DsDayCellState.rangeMiddle;
      }
    } else {
      final active = _activeDate;
      if (active != null && _isSameDay(day, active)) {
        return _DsDayCellState.selected;
      }
    }

    if (isToday) return _DsDayCellState.today;
    return _DsDayCellState.normal;
  }

  Widget _buildInterestDayGrid(SemanticColors colors) {
    final weeks = _buildWeeks(_focusedMonth);
    return Padding(
      key: const ValueKey('interest-day'),
      padding: const EdgeInsets.all(AppPadding.m),
      child: Column(
        children: [
          Row(
            children: _weekdays
                .map(
                  (label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: AppFont.sizeS,
                          fontWeight: AppTypography.fontWeightRegular,
                          height: AppFont.lineheightS / AppFont.sizeS,
                          letterSpacing: 0.25,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.l),
          ...weeks.map(
            (week) => Row(
              children: week.map((day) {
                if (day == null) {
                  return const Expanded(child: SizedBox(height: 48));
                }
                final inMonth = day.month == _focusedMonth.month;
                if (!inMonth) {
                  return const Expanded(child: SizedBox(height: 48));
                }
                final interestLabel = _interestLabelFor(day);
                final inRange = !day.isBefore(_dateOnly(_firstDate)) &&
                    !day.isAfter(_dateOnly(_lastDate));
                final selectable = interestLabel != null && inRange;
                return Expanded(
                  child: _DsInterestDayCell(
                    day: day.day,
                    interestLabel: interestLabel,
                    selected: _isSameDay(day, _selectedDate),
                    onTap: selectable ? () => _selectDay(day) : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(SemanticColors colors) {
    return SizedBox(
      key: const ValueKey('month'),
      height: 220,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: AppSpacing.m,
          crossAxisSpacing: AppSpacing.s,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          final selected = month == _activeDate?.month &&
              _focusedMonth.year == _activeDate?.year;
          return _DsGridCell(
            label: 'Tháng $month',
            selected: selected,
            onTap: () => _selectMonth(month),
          );
        },
      ),
    );
  }

  Widget _buildYearGrid(SemanticColors colors) {
    final startYear = _yearPageStart(_focusedMonth.year);
    final years = List.generate(12, (i) => startYear + i);

    return SizedBox(
      key: const ValueKey('year'),
      height: 220,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: AppSpacing.m,
          crossAxisSpacing: AppSpacing.s,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final year = years[index];
          final selected = year == _activeDate?.year;
          return _DsGridCell(
            label: '$year',
            selected: selected,
            outlined: year == _focusedMonth.year && !selected,
            onTap: () => _selectYear(year),
          );
        },
      ),
    );
  }

  List<List<DateTime?>> _buildWeeks(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final startOffset = first.weekday - 1;
    final cells = <DateTime?>[];

    for (var i = 0; i < startOffset; i++) {
      cells.add(null);
    }
    for (var day = 1; day <= daysInMonth; day++) {
      cells.add(DateTime(month.year, month.month, day));
    }
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    final weeks = <List<DateTime?>>[];
    for (var i = 0; i < cells.length; i += 7) {
      weeks.add(cells.sublist(i, i + 7));
    }
    return weeks;
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool _isSameDay(DateTime a, DateTime? b) {
    if (b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static int _yearPageStart(int year) => year - (year % 12);

  static String _yearRangeLabel(int year) {
    final start = _yearPageStart(year);
    return '$start-${start + 11}';
  }

  static TextStyle _dayLabelStyle(
    SemanticColors colors, {
    required bool selected,
  }) {
    return TextStyle(
      fontFamily: AppTypography.fontFamily,
      fontSize: AppFont.sizeM,
      fontWeight: selected
          ? AppTypography.fontWeightSemibold
          : AppTypography.fontWeightRegular,
      height: AppFont.lineheightM / AppFont.sizeM,
      letterSpacing: selected ? 0.5 : 0.25,
      color: selected ? colors.textPrimary : colors.textSecondary,
    );
  }
}

class _DsYearPickerDialog extends StatefulWidget {
  const _DsYearPickerDialog({
    required this.title,
    required this.resetLabel,
    required this.applyLabel,
    this.initialYear,
    this.firstYear,
    this.lastYear,
  });

  final String title;
  final String resetLabel;
  final String applyLabel;
  final int? initialYear;
  final int? firstYear;
  final int? lastYear;

  @override
  State<_DsYearPickerDialog> createState() => _DsYearPickerDialogState();
}

class _DsYearPickerDialogState extends State<_DsYearPickerDialog> {
  late int _focusedYear;
  late int? _selectedYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().year;
    _selectedYear = widget.initialYear;
    _focusedYear = _selectedYear ?? now;
  }

  void _navigatePrev() => setState(() => _focusedYear -= 12);
  void _navigateNext() => setState(() => _focusedYear += 12);

  @override
  Widget build(BuildContext context) {
    final start = _DsDatePickerDialogState._yearPageStart(_focusedYear);
    final years = List.generate(12, (i) => start + i);
    final first = widget.firstYear ?? start;
    final last = widget.lastYear ?? start + 11;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppPadding.s),
      child: Container(
        width: AppWidth.xl,
        decoration: BoxDecoration(
          color: DsDatePicker._colors(context).backgroundPrimary,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DsPickerHeader(
              title: widget.title,
              onClose: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.m),
              child: Column(
                children: [
                  _DsPickerNavBar(
                    title: _DsDatePickerDialogState._yearRangeLabel(_focusedYear),
                    showUpChevron: true,
                    onTitleTap: () {},
                    onPrev: _navigatePrev,
                    onNext: _navigateNext,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  SizedBox(
                    height: 220,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: AppSpacing.m,
                        crossAxisSpacing: AppSpacing.s,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final year = years[index];
                        final enabled = year >= first && year <= last;
                        return _DsGridCell(
                          label: '$year',
                          selected: year == _selectedYear,
                          outlined: year == _focusedYear && year != _selectedYear,
                          enabled: enabled,
                          onTap: enabled
                              ? () => setState(() {
                                    _selectedYear = year;
                                    _focusedYear = year;
                                  })
                              : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),
                ],
              ),
            ),
            _DsPickerFooter(
              resetLabel: widget.resetLabel,
              applyLabel: widget.applyLabel,
              onReset: () => setState(() {
                _selectedYear = widget.initialYear;
                _focusedYear = _selectedYear ?? DateTime.now().year;
              }),
              onApply: () => Navigator.pop(context, _selectedYear),
            ),
          ],
        ),
      ),
    );
  }
}

enum _DsMonthPickerView { month, year }

enum _DsMonthCellState {
  normal,
  disabled,
  present,
  selected,
  rangeStart,
  rangeMiddle,
  rangeEnd,
}

class _DsMonthRangePickerDialog extends StatefulWidget {
  const _DsMonthRangePickerDialog({
    required this.title,
    required this.resetLabel,
    required this.applyLabel,
    this.initialRange,
    this.firstMonth,
    this.lastMonth,
  });

  final String title;
  final String resetLabel;
  final String applyLabel;
  final DsMonthRange? initialRange;
  final DateTime? firstMonth;
  final DateTime? lastMonth;

  @override
  State<_DsMonthRangePickerDialog> createState() =>
      _DsMonthRangePickerDialogState();
}

class _DsMonthRangePickerDialogState extends State<_DsMonthRangePickerDialog> {
  late int _focusedYear;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  _DsMonthPickerView _view = _DsMonthPickerView.month;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialRange;
    _rangeStart = initial?.start != null
        ? DateTime(initial!.start.year, initial.start.month)
        : null;
    _rangeEnd = initial?.end != null
        ? DateTime(initial!.end.year, initial.end.month)
        : null;
    _focusedYear = _rangeStart?.year ?? DateTime.now().year;
  }

  static int _monthOrdinal(DateTime date) => date.year * 12 + date.month;

  bool _isMonthEnabled(DateTime month) {
    final ord = _monthOrdinal(month);
    final first = widget.firstMonth;
    final last = widget.lastMonth;
    if (first != null &&
        ord < _monthOrdinal(DateTime(first.year, first.month))) {
      return false;
    }
    if (last != null && ord > _monthOrdinal(DateTime(last.year, last.month))) {
      return false;
    }
    return true;
  }

  void _toggleView() {
    setState(() {
      _view = _view == _DsMonthPickerView.month
          ? _DsMonthPickerView.year
          : _DsMonthPickerView.month;
    });
  }

  void _navigatePrev() {
    setState(() {
      _focusedYear += _view == _DsMonthPickerView.year ? -12 : -1;
    });
  }

  void _navigateNext() {
    setState(() {
      _focusedYear += _view == _DsMonthPickerView.year ? 12 : 1;
    });
  }

  void _selectYear(int year) {
    setState(() {
      _focusedYear = year;
      _view = _DsMonthPickerView.month;
    });
  }

  void _selectMonth(int month) {
    final picked = DateTime(_focusedYear, month);
    if (!_isMonthEnabled(picked)) return;

    setState(() {
      if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
        _rangeStart = picked;
        _rangeEnd = null;
      } else {
        _rangeEnd = picked;
      }
    });
  }

  String _navTitle() {
    return switch (_view) {
      _DsMonthPickerView.month => '$_focusedYear',
      _DsMonthPickerView.year =>
        _DsDatePickerDialogState._yearRangeLabel(_focusedYear),
    };
  }

  _DsMonthCellState _monthCellState(int month) {
    final date = DateTime(_focusedYear, month);
    if (!_isMonthEnabled(date)) return _DsMonthCellState.disabled;

    final ord = _monthOrdinal(date);
    final start = _rangeStart;

    if (start != null) {
      final startOrd = _monthOrdinal(start);

      if (_rangeEnd == null) {
        if (ord == startOrd) return _DsMonthCellState.selected;
      } else {
        final endOrd = _monthOrdinal(_rangeEnd!);
        final lo = startOrd < endOrd ? startOrd : endOrd;
        final hi = startOrd < endOrd ? endOrd : startOrd;

        if (lo == hi && ord == lo) return _DsMonthCellState.selected;
        if (ord == lo) return _DsMonthCellState.rangeStart;
        if (ord == hi) return _DsMonthCellState.rangeEnd;
        if (ord > lo && ord < hi) return _DsMonthCellState.rangeMiddle;
      }
    }

    final now = DateTime.now();
    if (now.year == _focusedYear && now.month == month) {
      return _DsMonthCellState.present;
    }

    return _DsMonthCellState.normal;
  }

  DsMonthRange? _resultRange() {
    final start = _rangeStart;
    if (start == null) return null;
    final end = _rangeEnd ?? start;
    final startOrd = _monthOrdinal(start);
    final endOrd = _monthOrdinal(end);
    if (startOrd <= endOrd) {
      return DsMonthRange(start: start, end: end);
    }
    return DsMonthRange(start: end, end: start);
  }

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);
    final yearPageStart =
        _DsDatePickerDialogState._yearPageStart(_focusedYear);
    final years = List.generate(12, (i) => yearPageStart + i);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppPadding.s),
      child: Container(
        width: AppWidth.xl,
        decoration: BoxDecoration(
          color: colors.backgroundPrimary,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DsPickerHeader(
              title: widget.title,
              onClose: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.m),
              child: Column(
                children: [
                  _DsPickerNavBar(
                    title: _navTitle(),
                    showUpChevron: _view == _DsMonthPickerView.year,
                    onTitleTap: _toggleView,
                    onPrev: _navigatePrev,
                    onNext: _navigateNext,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: switch (_view) {
                      _DsMonthPickerView.month => _buildMonthGrid(),
                      _DsMonthPickerView.year => _buildYearGrid(years),
                    },
                  ),
                  const SizedBox(height: AppSpacing.l),
                ],
              ),
            ),
            _DsPickerFooter(
              resetLabel: widget.resetLabel,
              applyLabel: widget.applyLabel,
              onReset: () => setState(() {
                final initial = widget.initialRange;
                _rangeStart = initial?.start != null
                    ? DateTime(initial!.start.year, initial.start.month)
                    : null;
                _rangeEnd = initial?.end != null
                    ? DateTime(initial!.end.year, initial.end.month)
                    : null;
                _focusedYear = _rangeStart?.year ?? DateTime.now().year;
                _view = _DsMonthPickerView.month;
              }),
              onApply: () {
                final result = _resultRange();
                if (result != null) Navigator.pop(context, result);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthGrid() {
    return SizedBox(
      key: const ValueKey('month'),
      height: 298,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var row = 0; row < 4; row++)
            Row(
              children: [
                for (var col = 0; col < 3; col++) ...[
                  if (col > 0) const SizedBox(width: AppSpacing.s),
                  Expanded(
                    child: _DsMonthCell(
                      label: 'Tháng ${row * 3 + col + 1}',
                      state: _monthCellState(row * 3 + col + 1),
                      onTap: () => _selectMonth(row * 3 + col + 1),
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildYearGrid(List<int> years) {
    return SizedBox(
      key: const ValueKey('year'),
      height: 220,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: AppSpacing.m,
          crossAxisSpacing: AppSpacing.s,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final year = years[index];
          return _DsGridCell(
            label: '$year',
            selected: year == _focusedYear,
            outlined: false,
            enabled: true,
            onTap: () => _selectYear(year),
          );
        },
      ),
    );
  }
}

class _DsTimePickerDialog extends StatefulWidget {
  const _DsTimePickerDialog({
    required this.title,
    required this.cancelLabel,
    required this.applyLabel,
    this.initialTime,
  });

  final String title;
  final String cancelLabel;
  final String applyLabel;
  final TimeOfDay? initialTime;

  @override
  State<_DsTimePickerDialog> createState() => _DsTimePickerDialogState();
}

class _DsTimePickerDialogState extends State<_DsTimePickerDialog> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    final time = widget.initialTime ?? TimeOfDay.now();
    _hourController = FixedExtentScrollController(initialItem: time.hour);
    _minuteController = FixedExtentScrollController(initialItem: time.minute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  TimeOfDay get _time => TimeOfDay(
        hour: _hourController.selectedItem,
        minute: _minuteController.selectedItem,
      );

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppPadding.s),
      child: Container(
        width: AppWidth.xl,
        decoration: BoxDecoration(
          color: colors.backgroundPrimary,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DsPickerHeader(
              title: widget.title,
              showClose: false,
              onClose: () => Navigator.pop(context),
            ),
            Container(
              height: 182,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colors.backgroundBrandPrimary4,
                    width: AppStroke.s,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _DsWheelColumn(
                      controller: _hourController,
                      itemCount: 24,
                      formatter: (v) => v.toString().padLeft(2, '0'),
                    ),
                  ),
                  Expanded(
                    child: _DsWheelColumn(
                      controller: _minuteController,
                      itemCount: 60,
                      formatter: (v) => v.toString().padLeft(2, '0'),
                    ),
                  ),
                ],
              ),
            ),
            _DsPickerFooter(
              resetLabel: widget.cancelLabel,
              applyLabel: widget.applyLabel,
              onReset: () => Navigator.pop(context),
              onApply: () => Navigator.pop(context, _time),
            ),
          ],
        ),
      ),
    );
  }
}

class _DsPickerHeader extends StatelessWidget {
  const _DsPickerHeader({
    required this.title,
    required this.onClose,
    this.showClose = true,
  });

  final String title;
  final VoidCallback onClose;
  final bool showClose;

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);

    return Padding(
      padding: const EdgeInsets.all(AppPadding.m),
      child: SizedBox(
        height: AppFont.lineheightL,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: AppFont.sizeL,
                  fontWeight: AppTypography.fontWeightSemibold,
                  height: AppFont.lineheightL / AppFont.sizeL,
                  color: colors.textPrimary,
                ),
              ),
            ),
            if (showClose)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onClose,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: AppIconSize.m,
                    height: AppIconSize.m,
                    child: Center(
                      child: DsIcon(
                        name: DsIconName.alinearCancel,
                        size: AppIconSize.m,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DsPickerNavBar extends StatelessWidget {
  const _DsPickerNavBar({
    required this.title,
    required this.onTitleTap,
    required this.onPrev,
    required this.onNext,
    this.showUpChevron = false,
  });

  final String title;
  final VoidCallback onTitleTap;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final bool showUpChevron;

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.s,
        vertical: AppPadding.m,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTitleTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppFont.sizeL,
                    fontWeight: AppTypography.fontWeightSemibold,
                    height: AppFont.lineheightL / AppFont.sizeL,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  showUpChevron
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: AppIconSize.m,
                  color: colors.textPrimary,
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onPrev,
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.chevron_left,
              size: AppIconSize.m,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.l),
          GestureDetector(
            onTap: onNext,
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.chevron_right,
              size: AppIconSize.m,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DsQuickSelectRow extends StatelessWidget {
  const _DsQuickSelectRow({
    required this.days,
    required this.selectedDays,
    required this.onSelected,
  });

  final List<int> days;
  final int? selectedDays;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppPadding.m,
        AppSpacing.xs,
        AppPadding.m,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          for (var i = 0; i < days.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.l),
            GestureDetector(
              onTap: () => onSelected(days[i]),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.m,
                  vertical: AppPadding.s,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.round),
                  border: Border.all(
                    color: selectedDays == days[i]
                        ? colors.textBrandPrimary1
                        : colors.backgroundBrandPrimary4,
                    width: AppStroke.s,
                  ),
                ),
                child: Text(
                  '${days[i]} ngày',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppFont.sizeM,
                    fontWeight: AppTypography.fontWeightRegular,
                    height: AppFont.lineheightM / AppFont.sizeM,
                    letterSpacing: 0.25,
                    color: selectedDays == days[i]
                        ? colors.textBrandPrimary1
                        : colors.textTertiary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DsRangeTabs extends StatelessWidget {
  const _DsRangeTabs({
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.backgroundBrandPrimary4,
            width: AppStroke.s,
          ),
        ),
      ),
      child: Row(
        children: [
          _tab(context, label: 'Từ ngày', index: 0),
          _tab(context, label: 'Đến ngày', index: 1),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, {required String label, required int index}) {
    final colors = DsDatePicker._colors(context);
    final selected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: selected ? AppPadding.xl : AppPadding.s,
            vertical: AppPadding.m,
          ),
          decoration: BoxDecoration(
            border: selected
                ? Border(
                    bottom: BorderSide(
                      color: colors.textBrandPrimary1,
                      width: AppStroke.l,
                    ),
                  )
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              fontWeight: selected
                  ? AppTypography.fontWeightSemibold
                  : AppTypography.fontWeightRegular,
              height: AppFont.lineheightM / AppFont.sizeM,
              letterSpacing: selected ? 0.5 : 0.25,
              color: selected
                  ? colors.textBrandPrimary1
                  : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _DsDayCell extends StatelessWidget {
  const _DsDayCell({
    required this.day,
    required this.state,
    this.onTap,
  });

  final int day;
  final _DsDayCellState state;
  final VoidCallback? onTap;

  static const _pillRadius = Radius.circular(30);

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);
    final isSelected = state == _DsDayCellState.selected ||
        state == _DsDayCellState.rangeStart ||
        state == _DsDayCellState.rangeEnd ||
        state == _DsDayCellState.rangeMiddle;

    final textColor = switch (state) {
      _DsDayCellState.disabled => colors.textQuaternary,
      _DsDayCellState.rangeStart || _DsDayCellState.rangeEnd =>
        colors.backgroundPrimary,
      _DsDayCellState.today => colors.textBrandPrimary1,
      _DsDayCellState.selected || _DsDayCellState.rangeMiddle =>
        colors.textPrimary,
      _ => colors.textSecondary,
    };

    final decoration = switch (state) {
      _DsDayCellState.selected => BoxDecoration(
          color: colors.backgroundBrandPrimary4,
          borderRadius: const BorderRadius.all(_pillRadius),
        ),
      _DsDayCellState.rangeStart => BoxDecoration(
          color: colors.backgroundBrandPrimary1,
          borderRadius: const BorderRadius.horizontal(left: _pillRadius),
        ),
      _DsDayCellState.rangeMiddle => BoxDecoration(
          color: colors.backgroundBrandPrimary5,
        ),
      _DsDayCellState.rangeEnd => BoxDecoration(
          color: colors.backgroundBrandPrimary1,
          borderRadius: const BorderRadius.horizontal(right: _pillRadius),
        ),
      _DsDayCellState.today => BoxDecoration(
          border: Border.all(
            color: colors.textBrandPrimary1,
            width: AppStroke.s,
          ),
          borderRadius: const BorderRadius.all(_pillRadius),
        ),
      _ => null,
    };

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: decoration,
        child: Text(
          '$day',
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeM,
            fontWeight: isSelected || state == _DsDayCellState.today
                ? AppTypography.fontWeightSemibold
                : AppTypography.fontWeightRegular,
            height: AppFont.lineheightM / AppFont.sizeM,
            letterSpacing:
                isSelected || state == _DsDayCellState.today ? 0.5 : 0.25,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _DsInterestDayCell extends StatelessWidget {
  const _DsInterestDayCell({
    required this.day,
    required this.selected,
    this.interestLabel,
    this.onTap,
  });

  final int day;
  final bool selected;
  final String? interestLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);
    final hasInterest = interestLabel != null;

    final dayColor = !hasInterest
        ? colors.textTertiary
        : selected
            ? colors.textPrimary
            : colors.textPrimary4;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.s,
            AppSpacing.xs,
            AppPadding.s,
            AppPadding.s,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: selected
                    ? BoxDecoration(
                        color: colors.backgroundBrandPrimary4,
                        borderRadius: BorderRadius.circular(AppRadius.round),
                      )
                    : null,
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppFont.sizeM,
                    fontWeight: selected
                        ? AppTypography.fontWeightSemibold
                        : AppTypography.fontWeightRegular,
                    height: AppFont.lineheightM / AppFont.sizeM,
                    letterSpacing: 0.25,
                    color: dayColor,
                  ),
                ),
              ),
              if (hasInterest) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  interestLabel!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppFont.sizeS,
                    fontWeight: AppTypography.fontWeightRegular,
                    height: AppFont.lineheightS / AppFont.sizeS,
                    letterSpacing: 0.25,
                    color: colors.textPrimary4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DsMonthCell extends StatelessWidget {
  const _DsMonthCell({
    required this.label,
    required this.state,
    this.onTap,
  });

  final String label;
  final _DsMonthCellState state;
  final VoidCallback? onTap;

  static const _pillRadius = Radius.circular(AppRadius.xl);

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);
    final isSelected = state == _DsMonthCellState.selected ||
        state == _DsMonthCellState.rangeStart ||
        state == _DsMonthCellState.rangeEnd ||
        state == _DsMonthCellState.rangeMiddle;

    final textColor = switch (state) {
      _DsMonthCellState.disabled => colors.textQuaternary,
      _DsMonthCellState.rangeStart || _DsMonthCellState.rangeEnd =>
        colors.backgroundPrimary,
      _DsMonthCellState.present => colors.textBrandPrimary1,
      _DsMonthCellState.selected || _DsMonthCellState.rangeMiddle =>
        colors.textPrimary,
      _ => colors.textSecondary,
    };

    final decoration = switch (state) {
      _DsMonthCellState.selected => BoxDecoration(
          color: colors.backgroundBrandPrimary4,
          borderRadius: const BorderRadius.all(_pillRadius),
        ),
      _DsMonthCellState.rangeStart => BoxDecoration(
          color: colors.backgroundBrandPrimary1,
          borderRadius: const BorderRadius.horizontal(left: _pillRadius),
        ),
      _DsMonthCellState.rangeMiddle => BoxDecoration(
          color: colors.backgroundBrandPrimary4,
        ),
      _DsMonthCellState.rangeEnd => BoxDecoration(
          color: colors.backgroundBrandPrimary1,
          borderRadius: const BorderRadius.horizontal(right: _pillRadius),
        ),
      _DsMonthCellState.present => BoxDecoration(
          border: Border.all(
            color: colors.textBrandPrimary1,
            width: AppStroke.s,
          ),
          borderRadius: const BorderRadius.all(_pillRadius),
        ),
      _ => null,
    };

    return GestureDetector(
      onTap: state == _DsMonthCellState.disabled ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.l,
          vertical: AppPadding.s,
        ),
        decoration: decoration,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeM,
            fontWeight: isSelected || state == _DsMonthCellState.present
                ? AppTypography.fontWeightSemibold
                : AppTypography.fontWeightRegular,
            height: AppFont.lineheightM / AppFont.sizeM,
            letterSpacing:
                isSelected || state == _DsMonthCellState.present ? 0.5 : 0.25,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _DsGridCell extends StatelessWidget {
  const _DsGridCell({
    required this.label,
    required this.onTap,
    this.selected = false,
    this.outlined = false,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final bool outlined;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.l,
          vertical: AppPadding.s,
        ),
        decoration: BoxDecoration(
          color: selected ? colors.backgroundBrandPrimary4 : null,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: outlined
              ? Border.all(
                  color: colors.backgroundBrandPrimary1,
                  width: AppStroke.s,
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeM,
            fontWeight: selected || outlined
                ? AppTypography.fontWeightSemibold
                : AppTypography.fontWeightRegular,
            height: AppFont.lineheightM / AppFont.sizeM,
            letterSpacing: selected || outlined ? 0.5 : 0.25,
            color: selected || outlined
                ? (outlined && !selected
                    ? colors.backgroundBrandPrimary1
                    : colors.textPrimary)
                : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _DsTimeField extends StatelessWidget {
  const _DsTimeField({
    required this.time,
    required this.onTap,
  });

  final TimeOfDay time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);
    final label =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppPadding.m),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(
            color: colors.backgroundBrandPrimary4,
            width: AppStroke.s,
          ),
        ),
        child: Row(
          children: [
            Text(
              'Thời gian',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeM,
                fontWeight: AppTypography.fontWeightSemibold,
                height: AppFont.lineheightM / AppFont.sizeM,
                letterSpacing: 0.5,
                color: colors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeM,
                fontWeight: AppTypography.fontWeightSemibold,
                height: AppFont.lineheightM / AppFont.sizeM,
                letterSpacing: 0.5,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DsWheelColumn extends StatelessWidget {
  const _DsWheelColumn({
    required this.controller,
    required this.itemCount,
    required this.formatter,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final String Function(int value) formatter;

  @override
  Widget build(BuildContext context) {
    final colors = DsDatePicker._colors(context);

    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 48,
      perspective: 0.003,
      diameterRatio: 1.4,
      physics: const FixedExtentScrollPhysics(),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final selected = controller.selectedItem == index;
          return Center(
            child: Text(
              formatter(index),
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: selected ? AppFont.sizeXl : AppFont.sizeL,
                fontWeight: selected
                    ? AppTypography.fontWeightSemibold
                    : AppTypography.fontWeightRegular,
                height: selected
                    ? AppFont.lineheightXl / AppFont.sizeXl
                    : AppFont.lineheightL / AppFont.sizeL,
                letterSpacing: selected ? 0.25 : 0,
                color: selected ? colors.textPrimary : colors.textDisable1,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DsPickerFooter extends StatelessWidget {
  const _DsPickerFooter({
    required this.resetLabel,
    required this.applyLabel,
    required this.onReset,
    required this.onApply,
  });

  final String resetLabel;
  final String applyLabel;
  final VoidCallback onReset;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppPadding.xl,
        AppPadding.l,
        AppPadding.xl,
        34,
      ),
      child: Row(
        children: [
          Expanded(
            child: DsButton(
              label: resetLabel,
              type: DsButtonType.outline,
              size: DsButtonSize.medium,
              onPressed: onReset,
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: DsButton(
              label: applyLabel,
              size: DsButtonSize.medium,
              onPressed: onApply,
            ),
          ),
        ],
      ),
    );
  }
}
