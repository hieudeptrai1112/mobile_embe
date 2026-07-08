import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../showcase_section.dart';
import 'phone_preview.dart';

/// Breakpoint matching the shell — below this width, use mobile layout.
const double _kWideBreakpoint = 960.0;

/// Arco-style component doc page: doc left (scroll), sticky phone right.
///
/// On narrow screens (mobile) the phone-frame wrapper is hidden and sections
/// are rendered directly as scrollable content — since we're already on device.
class ShowcaseDocPage extends StatelessWidget {
  const ShowcaseDocPage({
    super.key,
    required this.title,
    required this.description,
    required this.sections,
    this.figmaName,
  });

  final String title;
  final String? figmaName;
  final String description;
  final List<ShowcaseSection> sections;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= _kWideBreakpoint;
        final phoneHeight =
            (constraints.maxHeight - AppPadding.l * 2).clamp(560.0, 780.0);

        // ── Mobile: scrollable sections with real widgets, no phone frame ──
        if (!wide) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppPadding.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DocIntro(
                  colors: colors,
                  title: title,
                  figmaName: figmaName,
                  description: description,
                ),
                const SizedBox(height: AppSpacing.n2xl),
                for (final section in sections) ...[
                  _MobileSectionBlock(section: section, colors: colors),
                  const SizedBox(height: AppSpacing.n2xl),
                ],
              ],
            ),
          );
        }

        // ── Desktop / tablet: doc left + phone preview right ─────────────
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.n2xl,
            AppPadding.l,
            AppPadding.n2xl,
            AppPadding.l,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DocIntro(
                        colors: colors,
                        title: title,
                        figmaName: figmaName,
                        description: description,
                      ),
                      const SizedBox(height: AppSpacing.n2xl),
                      for (final section in sections) ...[
                        _DocSectionHeader(colors: colors, section: section),
                        const SizedBox(height: AppSpacing.n3xl),
                      ],
                      const SizedBox(height: AppSpacing.n4xl),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.n4xl),
              ShowcasePhonePreview(
                appTitle: title,
                height: phoneHeight,
                child: _PhoneDemoPanel(
                  colors: colors,
                  sections: sections,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Shared intro ──────────────────────────────────────────────────────────────

class _DocIntro extends StatelessWidget {
  const _DocIntro({
    required this.colors,
    required this.title,
    required this.description,
    this.figmaName,
  });

  final SemanticColors colors;
  final String title;
  final String? figmaName;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.size2xl,
            fontWeight: AppTypography.fontWeightSemibold,
            height: AppFont.lineheight2xl / AppFont.size2xl,
            color: colors.textPrimary,
          ),
        ),
        if (figmaName != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            figmaName!,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
              color: colors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.l),
        Text(
          description,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeM,
            fontWeight: AppTypography.fontWeightRegular,
            height: AppFont.lineheightM / AppFont.sizeM,
            letterSpacing: 0.25,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ── Mobile section: title + description + actual widget ──────────────────────

class _MobileSectionBlock extends StatelessWidget {
  const _MobileSectionBlock({
    required this.section,
    required this.colors,
  });

  final ShowcaseSection section;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeL,
            fontWeight: AppTypography.fontWeightSemibold,
            height: AppFont.lineheightL / AppFont.sizeL,
            color: colors.textPrimary,
          ),
        ),
        if (section.description != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            section.description!,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              fontWeight: AppTypography.fontWeightRegular,
              height: AppFont.lineheightM / AppFont.sizeM,
              letterSpacing: 0.25,
              color: colors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.m),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppPadding.m),
          decoration: BoxDecoration(
            color: colors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(color: colors.borderPrimary, width: AppStroke.s),
          ),
          child: ShowcaseSectionBody(section: section),
        ),
      ],
    );
  }
}

// ── Desktop-only: section placeholder header in doc column ───────────────────

class _DocSectionHeader extends StatelessWidget {
  const _DocSectionHeader({
    required this.colors,
    required this.section,
  });

  final SemanticColors colors;
  final ShowcaseSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeL,
            fontWeight: AppTypography.fontWeightSemibold,
            height: AppFont.lineheightL / AppFont.sizeL,
            color: colors.textPrimary,
          ),
        ),
        if (section.description != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            section.description!,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              fontWeight: AppTypography.fontWeightRegular,
              height: AppFont.lineheightM / AppFont.sizeM,
              letterSpacing: 0.25,
              color: colors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.m),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppPadding.m),
          decoration: BoxDecoration(
            color: colors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(color: colors.borderPrimary, width: AppStroke.s),
          ),
          child: Text(
            '// Preview: ${section.title}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: AppFont.sizeS,
              height: AppFont.lineheightS / AppFont.sizeS,
              color: colors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Phone demo panel (desktop only) ──────────────────────────────────────────

class _PhoneDemoPanel extends StatelessWidget {
  const _PhoneDemoPanel({
    required this.colors,
    required this.sections,
  });

  final SemanticColors colors;
  final List<ShowcaseSection> sections;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppPadding.l),
      itemCount: sections.length,
      separatorBuilder: (_, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
        child: Divider(color: colors.borderPrimary, height: AppStroke.s),
      ),
      itemBuilder: (context, index) {
        final section = sections[index];
        return _PhoneSectionBlock(section: section, colors: colors);
      },
    );
  }
}

class _PhoneSectionBlock extends StatelessWidget {
  const _PhoneSectionBlock({
    required this.section,
    required this.colors,
  });

  final ShowcaseSection section;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeM,
            fontWeight: AppTypography.fontWeightSemibold,
            height: AppFont.lineheightM / AppFont.sizeM,
            letterSpacing: 0.5,
            color: colors.textPrimary,
          ),
        ),
        if (section.description != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            section.description!,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
              color: colors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.m),
        ShowcaseSectionBody(section: section),
      ],
    );
  }
}

// ── Full-width token doc page (no phone preview) ──────────────────────────────

class ShowcaseTokenDocPage extends StatelessWidget {
  const ShowcaseTokenDocPage({
    super.key,
    required this.title,
    required this.description,
    required this.body,
    this.figmaName,
    this.header,
  });

  final String title;
  final String? figmaName;
  final String description;
  final List<Widget> body;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppPadding.n2xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DocIntro(
            colors: colors,
            title: title,
            figmaName: figmaName,
            description: description,
          ),
          if (header != null) ...[
            const SizedBox(height: AppSpacing.l),
            header!,
          ],
          const SizedBox(height: AppSpacing.n2xl),
          ...body,
        ],
      ),
    );
  }
}
