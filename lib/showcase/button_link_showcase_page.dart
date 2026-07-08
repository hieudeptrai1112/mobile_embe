import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class ButtonLinkShowcasePage extends StatelessWidget {
  const ButtonLinkShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Button Link',
      figmaName: 'MButtonLink',
      description:
          'Nút dạng link với các kích cỡ Large, Medium, Small và trạng thái loading.',
      sections: [
        ShowcaseSection(
          title: 'Default',
          children: [
            DsButtonLink(label: 'Text', onPressed: () {}, size: DsButtonSize.large),
          ],
        ),
        ShowcaseSection(
          title: 'Large',
          children: [
            DsButtonLink(label: 'Text', onPressed: () {}, size: DsButtonSize.large),
            const DsButtonLink(label: 'Text', size: DsButtonSize.large),
            const DsButtonLink(
              label: 'Text',
              size: DsButtonSize.large,
              isLoading: true,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Medium',
          children: [
            DsButtonLink(label: 'Text', onPressed: () {}, size: DsButtonSize.medium),
            const DsButtonLink(label: 'Text', size: DsButtonSize.medium),
          ],
        ),
        ShowcaseSection(
          title: 'Small',
          children: [
            DsButtonLink(label: 'Text', onPressed: () {}, size: DsButtonSize.small),
            const DsButtonLink(
              label: 'Text',
              size: DsButtonSize.small,
              isLoading: true,
            ),
          ],
        ),
      ],
    );
  }
}
