import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class BadgeShowcasePage extends StatelessWidget {
  const BadgeShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Badge',
      figmaName: 'ABadgeNotification',
      description: 'Badge notification tròn và role pill từ Figma ABadgeNotification.',
      sections: [
        ShowcaseSection(
          title: 'Notification',
          description: 'Type: Notification',
          wrap: false,
          children: [
            Wrap(
              spacing: AppSpacing.l,
              runSpacing: AppSpacing.l,
              children: [
                for (final status in DsBadgeNotificationStatus.values)
                  DsBadge.notification(status: status),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Role',
          description: 'Type: Role',
          wrap: false,
          children: [
            Wrap(
              spacing: AppSpacing.l,
              runSpacing: AppSpacing.l,
              children: [
                for (final status in DsBadgeRoleStatus.values)
                  DsBadge.role(roleStatus: status),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
