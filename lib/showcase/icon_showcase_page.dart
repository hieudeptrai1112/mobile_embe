import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Groups DsIconName.values by their folder group, preserving kDsIconGroupOrder.
Map<String, List<DsIconName>> _buildGroups() {
  final map = <String, List<DsIconName>>{};
  for (final name in DsIconName.values) {
    map.putIfAbsent(name.group, () => []).add(name);
  }
  // Return in declared order; append any unrecognised groups at the end.
  final ordered = <String, List<DsIconName>>{};
  for (final g in kDsIconGroupOrder) {
    if (map.containsKey(g)) ordered[g] = map[g]!;
  }
  for (final entry in map.entries) {
    ordered.putIfAbsent(entry.key, () => entry.value);
  }
  return ordered;
}

String _groupTitle(String group) =>
    group[0].toUpperCase() + group.substring(1);

const _kGroupDescriptions = <String, String>{
  'actions':    'Thao tác người dùng — thêm, sửa, xoá, tải, chia sẻ…',
  'navigation': 'Điều hướng — home, back, mũi tên, chevron…',
  'status':     'Trạng thái hệ thống — thành công, cảnh báo, lỗi, thông tin.',
  'social':     'Mạng xã hội và brand — đăng nhập bên thứ ba.',
};

const _kSizes = <({String label, double size})>[
  (label: '16', size: 16),
  (label: '20', size: 20),
  (label: '24', size: 24),
  (label: '32', size: 32),
  (label: '40', size: 40),
];

// ── Page ──────────────────────────────────────────────────────────────────────

class IconShowcasePage extends StatefulWidget {
  const IconShowcasePage({super.key});

  @override
  State<IconShowcasePage> createState() => _IconShowcasePageState();
}

class _IconShowcasePageState extends State<IconShowcasePage> {
  DsIconName _colorIcon = DsIconName.values.first;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    final groups = _buildGroups();

    return ShowcaseTokenDocPage(
      title: 'Icons',
      figmaName: 'A Icons',
      description:
          'Bộ icon SVG dùng trong Design System. Scalable, hỗ trợ đổi màu '
          'qua ColorFilter. Nhấn vào icon để copy tên enum.',
      body: [
        // ── Icon groups (auto from DsIconName.values) ──────────────────────
        for (final entry in groups.entries) ...[
          _SectionTitle(
            title: _groupTitle(entry.key),
            description: _kGroupDescriptions[entry.key] ??
                '${entry.value.length} icons',
            colors: colors,
          ),
          const SizedBox(height: AppSpacing.m),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final name in entry.value)
                _IconTile(name: name, colors: colors),
            ],
          ),
          const SizedBox(height: AppSpacing.n3xl),
        ],

        // ── Sizes ─────────────────────────────────────────────────────────
        _SectionTitle(
          title: 'Sizes',
          description:
              'DsIcon hỗ trợ size tuỳ ý qua tham số size (mặc định 24).',
          colors: colors,
        ),
        const SizedBox(height: AppSpacing.m),
        _SizesDemo(icon: _colorIcon, colors: colors),
        const SizedBox(height: AppSpacing.n3xl),

        // ── Colors ────────────────────────────────────────────────────────
        _SectionTitle(
          title: 'Colors',
          description:
              'Icon kế thừa màu từ IconTheme hoặc truyền trực tiếp qua color. '
              'Nhấn để chọn icon preview.',
          colors: colors,
        ),
        const SizedBox(height: AppSpacing.m),
        _ColorsDemo(
          selectedIcon: _colorIcon,
          onIconChanged: (n) => setState(() => _colorIcon = n),
          colors: colors,
        ),
        const SizedBox(height: AppSpacing.n4xl),
      ],
    );
  }
}

// ── Section title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.description,
    required this.colors,
  });

  final String title;
  final String description;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeL,
            fontWeight: AppTypography.fontWeightSemibold,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          description,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeS,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        Divider(color: colors.borderPrimary, height: 1),
      ],
    );
  }
}

// ── Icon tile ─────────────────────────────────────────────────────────────────

class _IconTile extends StatelessWidget {
  const _IconTile({required this.name, required this.colors});

  final DsIconName name;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'DsIconName.${name.name}',
      child: InkWell(
        onTap: () => _copy(context, 'DsIconName.${name.name}'),
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: Container(
          width: 84,
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.xs,
            vertical: AppPadding.s,
          ),
          decoration: BoxDecoration(
            color: colors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(
              color: colors.borderPrimary,
              width: AppStroke.s,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DsIcon(name: name, size: 24, color: colors.textPrimary),
              const SizedBox(height: AppSpacing.xs),
              Text(
                name.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: AppFont.sizeXs,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('Copied: $text'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          width: 300,
        ),
      );
  }
}

// ── Sizes demo ────────────────────────────────────────────────────────────────

class _SizesDemo extends StatelessWidget {
  const _SizesDemo({required this.icon, required this.colors});

  final DsIconName icon;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.l),
      decoration: BoxDecoration(
        color: colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppRadius.s),
        border: Border.all(color: colors.borderPrimary, width: AppStroke.s),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final s in _kSizes)
            Column(
              children: [
                DsIcon(name: icon, size: s.size, color: colors.textPrimary),
                const SizedBox(height: AppSpacing.s),
                Text(
                  '${s.label}px',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppFont.sizeXs,
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ── Colors demo ───────────────────────────────────────────────────────────────

class _ColorsDemo extends StatelessWidget {
  const _ColorsDemo({
    required this.selectedIcon,
    required this.onIconChanged,
    required this.colors,
  });

  final DsIconName selectedIcon;
  final ValueChanged<DsIconName> onIconChanged;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    final palette = <({String label, Color color})>[
      (label: 'textPrimary',   color: colors.textPrimary),
      (label: 'textSecondary', color: colors.textSecondary),
      (label: 'textTertiary',  color: colors.textTertiary),
      (label: 'iconSuccess',   color: colors.iconSuccess),
      (label: 'iconWarning',   color: colors.iconWarning),
      (label: 'iconError',     color: colors.iconError),
      (label: 'iconNeutral1',  color: colors.iconNeutral1),
      (label: 'brandPrimary1', color: colors.textBrandPrimary1),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon picker — all icons as small chips, scrollable
        Text(
          'Chọn icon:',
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeS,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final name in DsIconName.values)
              _IconPickerChip(
                name: name,
                selected: name == selectedIcon,
                onTap: () => onIconChanged(name),
                colors: colors,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.l),
        // Color grid
        Container(
          padding: const EdgeInsets.all(AppPadding.l),
          decoration: BoxDecoration(
            color: colors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppRadius.s),
            border: Border.all(color: colors.borderPrimary, width: AppStroke.s),
          ),
          child: Wrap(
            spacing: AppSpacing.n2xl,
            runSpacing: AppSpacing.l,
            children: [
              for (final entry in palette)
                Column(
                  children: [
                    DsIcon(
                      name: selectedIcon,
                      size: 28,
                      color: entry.color,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      entry.label,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: AppFont.sizeXs,
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconPickerChip extends StatelessWidget {
  const _IconPickerChip({
    required this.name,
    required this.selected,
    required this.onTap,
    required this.colors,
  });

  final DsIconName name;
  final bool selected;
  final VoidCallback onTap;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: name.label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(AppPadding.s),
          decoration: BoxDecoration(
            color: selected
                ? colors.textBrandPrimary1.withValues(alpha: 0.12)
                : colors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(
              color: selected ? colors.textBrandPrimary1 : colors.borderPrimary,
              width: selected ? AppStroke.m : AppStroke.s,
            ),
          ),
          child: DsIcon(
            name: name,
            size: 20,
            color: selected ? colors.textBrandPrimary1 : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
