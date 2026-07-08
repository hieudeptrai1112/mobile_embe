import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class ButtonPillShowcasePage extends StatelessWidget {
  const ButtonPillShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Button Pill',
      figmaName: 'MButtonPill',
      description:
          'Nút pill với các variant Primary, Outline và nhiều kích cỡ Large, Medium, Small.',
      sections: [
        ShowcaseSection(
          title: 'Default',
          children: [
            DsButton(label: 'Text', onPressed: () {}, size: DsButtonSize.large),
          ],
        ),
        ShowcaseSection(
          title: 'Primary — Large',
          children: [
            DsButton(label: 'Text', onPressed: () {}, size: DsButtonSize.large),
            DsButton(
              label: 'Text',
              onPressed: () {},
              size: DsButtonSize.large,
              showLeadingIcon: true,
            ),
            DsButton(
              label: 'Text',
              onPressed: () {},
              size: DsButtonSize.large,
              showTrailingIcon: true,
            ),
            const DsButton(
              label: 'Text',
              size: DsButtonSize.large,
              isLoading: true,
            ),
            const DsButton(label: 'Text', size: DsButtonSize.large),
          ],
        ),
        ShowcaseSection(
          title: 'Outline — Medium',
          children: [
            DsButton(
              label: 'Text',
              onPressed: () {},
              type: DsButtonType.outline,
              size: DsButtonSize.medium,
            ),
            DsButton(
              label: 'Text',
              onPressed: () {},
              type: DsButtonType.outline,
              size: DsButtonSize.medium,
              showLeadingIcon: true,
            ),
            const DsButton(
              label: 'Text',
              type: DsButtonType.outline,
              size: DsButtonSize.medium,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Primary — Small',
          children: [
            DsButton(label: 'Text', onPressed: () {}, size: DsButtonSize.small),
            DsButton(
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
