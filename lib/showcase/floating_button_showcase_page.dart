import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class FloatingButtonShowcasePage extends StatelessWidget {
  const FloatingButtonShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Floating Button',
      figmaName: 'MButtonIcon / MButtonFloatAction',
      description:
          'Nút nổi dạng vuông hoặc tròn, variant solid và outline. Icon mặc định: A Linear/Add.',
      sections: [
        ShowcaseSection(
          title: 'Default',
          children: [
            DsFloatingButton.square(onPressed: () {}),
          ],
        ),
        ShowcaseSection(
          title: 'Square — Solid',
          children: [
            DsFloatingButton.square(onPressed: () {}),
            const DsFloatingButton.square(),
          ],
        ),
        ShowcaseSection(
          title: 'Square — Outline',
          children: [
            DsFloatingButton.square(
              onPressed: () {},
              type: DsButtonType.outline,
            ),
            const DsFloatingButton.square(type: DsButtonType.outline),
          ],
        ),
        ShowcaseSection(
          title: 'Round — Solid',
          children: [
            DsFloatingButton.round(onPressed: () {}),
            const DsFloatingButton.round(),
          ],
        ),
        ShowcaseSection(
          title: 'Round — Outline',
          children: [
            DsFloatingButton.round(
              onPressed: () {},
              type: DsButtonType.outline,
            ),
            const DsFloatingButton.round(type: DsButtonType.outline),
          ],
        ),
      ],
    );
  }
}
