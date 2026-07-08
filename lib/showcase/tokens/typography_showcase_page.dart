import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../doc/showcase_doc_page.dart';
import '../showcase_section.dart';
import 'token_showcase_widgets.dart';

class TypographyShowcasePage extends StatelessWidget {
  const TypographyShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return ShowcaseTokenDocPage(
      title: 'Typography',
      figmaName: 'Typography Token',
      description:
          'Token typography: font family, sizes, weights và line heights.',
      body: [
        _TokenDocSection(
          section: ShowcaseSection(
            title: 'Font Family',
            wrap: false,
            children: [
              TokenRow(name: 'AppTypography.fontFamily', value: AppTypography.fontFamily),
              TokenRow(
                name: 'PrimitiveTypography',
                value: PrimitiveTypography.fontFamilyDisplay,
              ),
            ],
          ),
        ),
        _TokenDocSection(
          section: ShowcaseSection(
            title: 'Font Sizes',
            wrap: false,
            children: [
              _TypeSample(
                label: 'sizeXs — ${AppFont.sizeXs}px',
                fontSize: AppFont.sizeXs,
                lineHeight: AppFont.lineheightXs,
                color: textColor,
              ),
              _TypeSample(
                label: 'sizeS — ${AppFont.sizeS}px',
                fontSize: AppFont.sizeS,
                lineHeight: AppFont.lineheightS,
                color: textColor,
              ),
              _TypeSample(
                label: 'sizeM — ${AppFont.sizeM}px',
                fontSize: AppFont.sizeM,
                lineHeight: AppFont.lineheightM,
                color: textColor,
              ),
              _TypeSample(
                label: 'sizeL — ${AppFont.sizeL}px',
                fontSize: AppFont.sizeL,
                lineHeight: AppFont.lineheightL,
                color: textColor,
              ),
              _TypeSample(
                label: 'sizeXl — ${AppFont.sizeXl}px',
                fontSize: AppFont.sizeXl,
                lineHeight: AppFont.lineheightXl,
                color: textColor,
              ),
              _TypeSample(
                label: 'size2xl — ${AppFont.size2xl}px',
                fontSize: AppFont.size2xl,
                lineHeight: AppFont.lineheight2xl,
                color: textColor,
              ),
            ],
          ),
        ),
        _TokenDocSection(
          section: ShowcaseSection(
            title: 'Font Weights',
            wrap: false,
            children: [
              _TypeSample(
                label: 'Regular (400)',
                fontSize: AppFont.sizeM,
                lineHeight: AppFont.lineheightM,
                fontWeight: AppTypography.fontWeightRegular,
                color: textColor,
              ),
              _TypeSample(
                label: 'Semibold (600)',
                fontSize: AppFont.sizeM,
                lineHeight: AppFont.lineheightM,
                fontWeight: AppTypography.fontWeightSemibold,
                color: textColor,
              ),
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

class _TypeSample extends StatelessWidget {
  const _TypeSample({
    required this.label,
    required this.fontSize,
    required this.lineHeight,
    required this.color,
    this.fontWeight = AppTypography.fontWeightRegular,
  });

  final String label;
  final double fontSize;
  final double lineHeight;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
              color: color.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'The quick brown fox jumps over the lazy dog',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: fontSize,
              fontWeight: fontWeight,
              height: lineHeight / fontSize,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
