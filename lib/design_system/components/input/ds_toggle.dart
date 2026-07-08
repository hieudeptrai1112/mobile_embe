import 'package:flutter/material.dart';

import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';

/// Toggle from Figma `MToggleNormal` (Design System V2 Mobile).
///
/// Supports on/off, enabled/disabled, and two sizes (`m`, `l`).
class DsToggle extends StatelessWidget {
  const DsToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.size = DsToggleSize.m,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final DsToggleSize size;
  final bool enabled;

  bool get _isInteractive => enabled && onChanged != null;

  void _handleTap() {
    if (!_isInteractive) return;
    onChanged!(!value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
    final metrics = _DsToggleMetrics.forSize(size);
    final palette = _DsTogglePalette.resolve(
      colors: colors,
      enabled: enabled,
      value: value,
    );

    return Semantics(
      toggled: value,
      enabled: _isInteractive,
      label: 'Toggle',
      child: GestureDetector(
        onTap: _isInteractive ? _handleTap : null,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: metrics.trackWidth,
          height: metrics.trackHeight,
          decoration: BoxDecoration(
            color: palette.track,
            borderRadius: BorderRadius.circular(metrics.borderRadius),
          ),
          child: Padding(
            padding: EdgeInsets.all(metrics.padding),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment:
                  value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: metrics.thumbSize,
                height: metrics.thumbSize,
                decoration: BoxDecoration(
                  color: palette.thumb,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum DsToggleSize { m, l }

class _DsToggleMetrics {
  const _DsToggleMetrics({
    required this.trackWidth,
    required this.trackHeight,
    required this.thumbSize,
    required this.padding,
  });

  final double trackWidth;
  final double trackHeight;
  final double thumbSize;
  final double padding;

  double get borderRadius => trackHeight / 2;

  static _DsToggleMetrics forSize(DsToggleSize size) {
    return switch (size) {
      DsToggleSize.m => const _DsToggleMetrics(
          trackWidth: 32,
          trackHeight: 16,
          thumbSize: 12,
          padding: AppPadding.xxs,
        ),
      DsToggleSize.l => const _DsToggleMetrics(
          trackWidth: 40,
          trackHeight: 20,
          thumbSize: 16,
          padding: AppPadding.xxs,
        ),
    };
  }
}

class _DsTogglePalette {
  const _DsTogglePalette({
    required this.track,
    required this.thumb,
  });

  final Color track;
  final Color thumb;

  static _DsTogglePalette resolve({
    required SemanticColors colors,
    required bool enabled,
    required bool value,
  }) {
    if (!enabled) {
      return _DsTogglePalette(
        track: value ? colors.chart17 : colors.backgroundDisable3,
        thumb: colors.textWhite,
      );
    }

    if (value) {
      return _DsTogglePalette(
        track: colors.borderBrandTertiary,
        thumb: colors.textWhite,
      );
    }

    return _DsTogglePalette(
      track: colors.borderSecondary,
      thumb: colors.textWhite,
    );
  }
}
