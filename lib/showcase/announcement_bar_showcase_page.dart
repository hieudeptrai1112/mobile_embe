import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class AnnouncementBarShowcasePage extends StatelessWidget {
  const AnnouncementBarShowcasePage({super.key});

  static const _shortMessage =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ';

  static const _longMessage =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.';

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Announcement Bar',
      figmaName: 'M Announcement Bar/ Top · O Announcement Bar · M Announcement Bar/ Fix',
      description:
          'Thanh thông báo top, inline ghi chú và fixed bar với action buttons.',
      sections: [
        ShowcaseSection(
          title: 'Top — Primary',
          description: 'M Announcement Bar/ Top, style Primary',
          wrap: false,
          children: [
            for (final type in DsAnnouncementBarTopType.values) ...[
              DsAnnouncementBarTop(
                type: type,
                style: DsAnnouncementBarTopStyle.primary,
              ),
              const SizedBox(height: AppSpacing.m),
            ],
          ],
        ),
        ShowcaseSection(
          title: 'Top — Secondary',
          description: 'M Announcement Bar/ Top, style Secondary',
          wrap: false,
          children: [
            for (final type in DsAnnouncementBarTopType.values) ...[
              DsAnnouncementBarTop(
                type: type,
                style: DsAnnouncementBarTopStyle.secondary,
              ),
              const SizedBox(height: AppSpacing.m),
            ],
          ],
        ),
        const ShowcaseSection(
          title: 'Inline — Collapsed',
          description: 'O Announcement Bar, ≤3 dòng',
          wrap: false,
          children: [
            DsAnnouncementBarInline(
              label: 'Label 1',
              message: _shortMessage,
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Inline — Expanded',
          description: 'O Announcement Bar, >3 dòng + Tìm hiểu thêm',
          wrap: false,
          children: [
            DsAnnouncementBarInline(
              label: 'Label 1',
              message: _longMessage,
              initiallyExpanded: true,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Fixed',
          description: 'M Announcement Bar/ Fix',
          wrap: false,
          children: [
            DsAnnouncementBarFixed(
              onPrimary: () {},
              onSecondary: () {},
              onClose: () {},
            ),
          ],
        ),
      ],
    );
  }
}
