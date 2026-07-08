import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'ds_icon_assets.dart';

/// Icon widget from Figma `A Icons`.
///
/// Tự phát hiện SVG hay raster (png/webp/jpg) và render đúng widget.
///
/// Usage:
/// ```dart
/// DsIcon(name: DsIconName.add)
/// DsIcon(name: DsIconName.close, size: 20, color: Colors.red)
/// DsIcon.asset('assets/icons/actions/custom.svg', size: 24)
/// ```
class DsIcon extends StatelessWidget {
  const DsIcon({
    super.key,
    required this.name,
    this.size = 24,
    this.color,
    this.semanticLabel,
  }) : _asset = null;

  const DsIcon.asset({
    super.key,
    required String this._asset,
    this.size = 24,
    this.color,
    this.semanticLabel,
  }) : name = null;

  final DsIconName? name;
  final String? _asset;
  final double size;
  final Color? color;
  final String? semanticLabel;

  String get assetPath => _asset ?? name!.assetPath;

  bool get _isSvg => assetPath.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    Widget icon;
    if (_isSvg) {
      final effectiveColor = color ?? IconTheme.of(context).color;
      icon = SvgPicture.asset(
        assetPath,
        width: size,
        height: size,
        colorFilter: effectiveColor != null
            ? ColorFilter.mode(effectiveColor, BlendMode.srcIn)
            : null,
      );
    } else {
      // Raster (webp / png / jpg) — only tint when [color] is set explicitly.
      // Full-color assets (e.g. badge_*.webp) must not inherit IconTheme.
      Widget img = Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
      if (color != null) {
        img = ColorFiltered(
          colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
          child: img,
        );
      }
      icon = img;
    }

    return Semantics(
      label: semanticLabel ?? name?.label,
      image: true,
      child: SizedBox(width: size, height: size, child: icon),
    );
  }
}
