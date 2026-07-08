import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class StatusShowcasePage extends StatelessWidget {
  const StatusShowcasePage({super.key});

  static const _variants = DsStatusVariant.values;

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Status',
      figmaName: 'ATagStatus / ATagState',
      description:
          'Tag trạng thái dạng dot hoặc pill với các variant màu sắc.',
      sections: [
        const ShowcaseSection(
          title: 'Default',
          wrap: false,
          children: [
            DsStatus(
              label: 'Text',
              style: DsStatusStyle.status,
              variant: DsStatusVariant.info,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Style — Status (dot)',
          wrap: false,
          children: [
            Wrap(
              spacing: AppSpacing.l,
              runSpacing: AppSpacing.l,
              children: [
                for (final variant in _variants)
                  DsStatus(
                    label: 'Text',
                    style: DsStatusStyle.status,
                    variant: variant,
                  ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Style — State (pill)',
          wrap: false,
          children: [
            Wrap(
              spacing: AppSpacing.l,
              runSpacing: AppSpacing.l,
              children: [
                for (final variant in _variants)
                  DsStatus(
                    label: 'Text',
                    style: DsStatusStyle.state,
                    variant: variant,
                  ),
              ],
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'With description — Status',
          wrap: false,
          children: [
            DsStatus(
              label: 'Text',
              style: DsStatusStyle.status,
              variant: DsStatusVariant.info,
              description: 'Text',
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'With description — State',
          wrap: false,
          children: [
            DsStatus(
              label: 'Text',
              style: DsStatusStyle.state,
              variant: DsStatusVariant.warning,
              description: 'Text',
            ),
          ],
        ),
      ],
    );
  }
}
