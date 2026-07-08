import 'package:flutter/material.dart';

import 'ds_illustration_assets.dart';

/// Illustration widget from Figma `A Illustration`.
class DsIllustration extends StatelessWidget {
  const DsIllustration({
    super.key,
    required this.name,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.contain,
    this.semanticLabel,
  }) : _asset = null;

  const DsIllustration.asset({
    super.key,
    required String this._asset,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.contain,
    this.semanticLabel,
  }) : name = null;

  final DsIllustrationName? name;
  final String? _asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? semanticLabel;

  String get assetPath => _asset ?? name!.assetPath;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? name?.label,
      image: true,
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
