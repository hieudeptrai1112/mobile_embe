import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';

typedef ColorEntry = ({String name, Color color});

String colorToHex(Color color) {
  final value = color.toARGB32();
  final a = (value >> 24) & 0xFF;
  final r = (value >> 16) & 0xFF;
  final g = (value >> 8) & 0xFF;
  final b = value & 0xFF;
  String channel(int v) => v.toRadixString(16).padLeft(2, '0').toUpperCase();
  if (a == 255) return '#${channel(r)}${channel(g)}${channel(b)}';
  return '#${channel(a)}${channel(r)}${channel(g)}${channel(b)}';
}

bool _isLightColor(Color color) {
  return color.computeLuminance() > 0.55;
}

class ColorSwatchTile extends StatelessWidget {
  const ColorSwatchTile({
    super.key,
    required this.name,
    required this.color,
  });

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final onSwatch = _isLightColor(color) ? Colors.black87 : Colors.white;
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: AppStroke.s,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              colorToHex(color),
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeS,
                fontWeight: AppTypography.fontWeightSemibold,
                color: onSwatch,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class ColorGroupSection extends StatelessWidget {
  const ColorGroupSection({
    super.key,
    required this.title,
    required this.entries,
  });

  final String title;
  final List<ColorEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              fontWeight: AppTypography.fontWeightSemibold,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              for (final entry in entries)
                ColorSwatchTile(name: entry.name, color: entry.color),
            ],
          ),
        ],
      ),
    );
  }
}

class DimensionBar extends StatelessWidget {
  const DimensionBar({
    super.key,
    required this.name,
    required this.value,
    this.color,
  });

  final String name;
  final double value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final barColor = color ?? Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeS,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 24,
              width: value,
              constraints: BoxConstraints(maxWidth: value, minWidth: value.clamp(0, 200)),
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Text(
            '${value % 1 == 0 ? value.toInt() : value}px',
            style: const TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
              fontWeight: AppTypography.fontWeightSemibold,
            ),
          ),
        ],
      ),
    );
  }
}

class TokenRow extends StatelessWidget {
  const TokenRow({
    super.key,
    required this.name,
    required this.value,
  });

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeS,
                fontWeight: AppTypography.fontWeightSemibold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeS,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
