import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class IllustrationShowcasePage extends StatelessWidget {
  const IllustrationShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final general = DsIllustrationName.values
        .where((name) => !name.name.startsWith('flag'))
        .where((name) => name != DsIllustrationName.labelRemind)
        .toList();
    final flags =
        DsIllustrationName.values.where((name) => name.name.startsWith('flag'));

    return ShowcaseDocPage(
      title: 'Illustration',
      figmaName: 'A Illustration',
      description:
          'Bộ illustration dùng cho empty state, thông báo và cờ quốc gia.',
      sections: [
        const ShowcaseSection(
          title: 'Default',
          children: [
            DsIllustration(
              name: DsIllustrationName.empty,
              width: 80,
              height: 80,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'General',
          children: [
            for (final name in general) _IllustrationTile(name: name),
          ],
        ),
        ShowcaseSection(
          title: 'Labels',
          children: [
            _IllustrationTile(name: DsIllustrationName.labelRemind),
          ],
        ),
        ShowcaseSection(
          title: 'Flags',
          children: [
            for (final name in flags) _IllustrationTile(name: name, size: 48),
          ],
        ),
        const ShowcaseSection(
          title: 'Empty state usage',
          wrap: false,
          children: [
            DsBottomSheetEmptyState(
              illustration: DsIllustrationName.empty,
              message: 'Bạn chưa có ...',
            ),
          ],
        ),
      ],
    );
  }
}

class _IllustrationTile extends StatelessWidget {
  const _IllustrationTile({
    required this.name,
    this.size = 80,
  });

  final DsIllustrationName name;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      child: Column(
        children: [
          DsIllustration(
            name: name,
            width: size,
            height: size,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            name.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
