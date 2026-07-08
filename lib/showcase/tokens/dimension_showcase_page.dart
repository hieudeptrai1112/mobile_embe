import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../doc/showcase_doc_page.dart';
import '../showcase_section.dart';
import 'token_showcase_widgets.dart';

class DimensionShowcasePage extends StatelessWidget {
  const DimensionShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final barColor = Theme.of(context).colorScheme.primary;

    return ShowcaseTokenDocPage(
      title: 'Dimensions',
      figmaName: 'Dimension Token',
      description:
          'Token kích thước: spacing, padding, radius, icon size, stroke và width.',
      body: [
        _TokenDocSection(
          section: ShowcaseSection(
            title: 'Spacing (AppSpacing)',
            wrap: false,
            children: [
              DimensionBar(name: 'xxs', value: AppSpacing.xxs, color: barColor),
              DimensionBar(name: 'xs', value: AppSpacing.xs, color: barColor),
              DimensionBar(name: 's', value: AppSpacing.s, color: barColor),
              DimensionBar(name: 'm', value: AppSpacing.m, color: barColor),
              DimensionBar(name: 'l', value: AppSpacing.l, color: barColor),
              DimensionBar(name: 'xl', value: AppSpacing.xl, color: barColor),
              DimensionBar(name: 'n2xl', value: AppSpacing.n2xl, color: barColor),
              DimensionBar(name: 'n3xl', value: AppSpacing.n3xl, color: barColor),
              DimensionBar(name: 'n4xl', value: AppSpacing.n4xl, color: barColor),
              DimensionBar(name: 'n5xl', value: AppSpacing.n5xl, color: barColor),
            ],
          ),
        ),
        _TokenDocSection(
          section: ShowcaseSection(
            title: 'Padding (AppPadding)',
            wrap: false,
            children: [
              DimensionBar(name: 'xxs', value: AppPadding.xxs, color: barColor),
              DimensionBar(name: 'xs', value: AppPadding.xs, color: barColor),
              DimensionBar(name: 's', value: AppPadding.s, color: barColor),
              DimensionBar(name: 'm', value: AppPadding.m, color: barColor),
              DimensionBar(name: 'l', value: AppPadding.l, color: barColor),
              DimensionBar(name: 'xl', value: AppPadding.xl, color: barColor),
              DimensionBar(name: 'n2xl', value: AppPadding.n2xl, color: barColor),
              DimensionBar(name: 'size3xl', value: AppPadding.size3xl, color: barColor),
            ],
          ),
        ),
        _TokenDocSection(
          section: ShowcaseSection(
            title: 'Radius (AppRadius)',
            wrap: false,
            children: [
              _RadiusSample(name: 'xxs', radius: AppRadius.xxs),
              _RadiusSample(name: 'xs', radius: AppRadius.xs),
              _RadiusSample(name: 's', radius: AppRadius.s),
              _RadiusSample(name: 'm', radius: AppRadius.m),
              _RadiusSample(name: 'l', radius: AppRadius.l),
              _RadiusSample(name: 'xl', radius: AppRadius.xl),
              _RadiusSample(name: 'n2xl', radius: AppRadius.n2xl),
              _RadiusSample(name: 'round', radius: AppRadius.round, capped: true),
            ],
          ),
        ),
        _TokenDocSection(
          section: ShowcaseSection(
            title: 'Icon Size (AppIconSize)',
            wrap: false,
            children: [
              DimensionBar(name: 'xs', value: AppIconSize.xs, color: barColor),
              DimensionBar(name: 's', value: AppIconSize.s, color: barColor),
              DimensionBar(name: 'm', value: AppIconSize.m, color: barColor),
              DimensionBar(name: 'l', value: AppIconSize.l, color: barColor),
              DimensionBar(name: 'xl', value: AppIconSize.xl, color: barColor),
              DimensionBar(name: 'n2xl', value: AppIconSize.n2xl, color: barColor),
            ],
          ),
        ),
        _TokenDocSection(
          section: ShowcaseSection(
            title: 'Stroke (AppStroke)',
            wrap: false,
            children: [
              TokenRow(name: 's', value: '${AppStroke.s}px'),
              TokenRow(name: 'm', value: '${AppStroke.m}px'),
              TokenRow(name: 'l', value: '${AppStroke.l}px'),
            ],
          ),
        ),
        _TokenDocSection(
          section: ShowcaseSection(
            title: 'Width (AppWidth)',
            wrap: false,
            children: [
              TokenRow(name: 's', value: '${AppWidth.s}px'),
              TokenRow(name: 'm', value: '${AppWidth.m}px'),
              TokenRow(name: 'l', value: '${AppWidth.l}px'),
              TokenRow(name: 'xl', value: '${AppWidth.xl}px'),
              TokenRow(name: 'n2xl', value: '${AppWidth.n2xl}px'),
            ],
          ),
        ),
      ],
    );
  }
}

class _TokenDocSection extends StatelessWidget {
  const _TokenDocSection({required this.section});

  final ShowcaseSection section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: const TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              fontWeight: AppTypography.fontWeightSemibold,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          ShowcaseSectionBody(section: section),
        ],
      ),
    );
  }
}

class _RadiusSample extends StatelessWidget {
  const _RadiusSample({
    required this.name,
    required this.radius,
    this.capped = false,
  });

  final String name;
  final double radius;
  final bool capped;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = capped ? 20.0 : radius;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeS,
              ),
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(effectiveRadius),
              border: Border.all(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Text(
            capped ? '$radius (demo: 20px)' : '${radius}px',
            style: const TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
            ),
          ),
        ],
      ),
    );
  }
}
