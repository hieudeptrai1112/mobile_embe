import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../showcase_theme.dart';
import 'primitive_colors_showcase_page.dart';
import 'semantic_colors_showcase_page.dart';
import 'typography_showcase_page.dart';
import 'dimension_showcase_page.dart';

class TokenShowcaseHomePage extends StatelessWidget {
  const TokenShowcaseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokens'),
        actions: const [ShowcaseThemeToggle()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppPadding.l),
        children: [
          _TokenTile(
            title: 'Primitive Colors',
            subtitle: 'Global palette — blue, red, purple…',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const PrimitiveColorsShowcasePage(),
              ),
            ),
          ),
          _TokenTile(
            title: 'Semantic Colors',
            subtitle: 'Alias tokens — light & dark mode',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const SemanticColorsShowcasePage(),
              ),
            ),
          ),
          _TokenTile(
            title: 'Typography',
            subtitle: 'Font family, sizes, weights',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const TypographyShowcasePage(),
              ),
            ),
          ),
          _TokenTile(
            title: 'Dimensions',
            subtitle: 'Spacing, radius, padding, stroke',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const DimensionShowcasePage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenTile extends StatelessWidget {
  const _TokenTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeM,
            fontWeight: AppTypography.fontWeightSemibold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeS,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
