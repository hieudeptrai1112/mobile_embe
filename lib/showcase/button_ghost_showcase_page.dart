import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class ButtonGhostShowcasePage extends StatelessWidget {
  const ButtonGhostShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Button Ghost',
      figmaName: 'MButtonGhost',
      description:
          'Nút ghost trong suốt, hỗ trợ icon đầu/cuối và nhiều kích cỡ.',
      sections: [
        ShowcaseSection(
          title: 'Default',
          children: [
            DsButtonGhost(label: 'Text', onPressed: () {}, size: DsButtonSize.large),
          ],
        ),
        ShowcaseSection(
          title: 'Large',
          children: [
            DsButtonGhost(label: 'Text', onPressed: () {}, size: DsButtonSize.large),
            DsButtonGhost(
              label: 'Text',
              onPressed: () {},
              size: DsButtonSize.large,
              showLeadingIcon: true,
            ),
            DsButtonGhost(
              label: 'Text',
              onPressed: () {},
              size: DsButtonSize.large,
              showTrailingIcon: true,
            ),
            const DsButtonGhost(label: 'Text', size: DsButtonSize.large),
          ],
        ),
        ShowcaseSection(
          title: 'Medium',
          children: [
            DsButtonGhost(label: 'Text', onPressed: () {}, size: DsButtonSize.medium),
            DsButtonGhost(
              label: 'Text',
              onPressed: () {},
              size: DsButtonSize.medium,
              showLeadingIcon: true,
            ),
            const DsButtonGhost(label: 'Text', size: DsButtonSize.medium),
          ],
        ),
        ShowcaseSection(
          title: 'Small',
          children: [
            DsButtonGhost(label: 'Text', onPressed: () {}, size: DsButtonSize.small),
            DsButtonGhost(
              label: 'Text',
              onPressed: () {},
              size: DsButtonSize.small,
              showTrailingIcon: true,
            ),
          ],
        ),
      ],
    );
  }
}
