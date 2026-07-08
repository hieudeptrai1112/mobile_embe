import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';

/// Section data for component doc pages (Arco-style).
class ShowcaseSection {
  const ShowcaseSection({
    required this.title,
    required this.children,
    this.description,
    this.wrap = true,
  });

  final String title;
  final String? description;
  final List<Widget> children;
  final bool wrap;
}

/// Renders [ShowcaseSection] children for token / non-phone pages.
class ShowcaseSectionBody extends StatelessWidget {
  const ShowcaseSectionBody({
    super.key,
    required this.section,
  });

  final ShowcaseSection section;

  @override
  Widget build(BuildContext context) {
    if (section.wrap) {
      return Wrap(
        spacing: AppSpacing.s,
        runSpacing: AppSpacing.s,
        children: section.children,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: section.children,
    );
  }
}
