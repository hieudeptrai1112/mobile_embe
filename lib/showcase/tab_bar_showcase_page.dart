import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class TabBarShowcasePage extends StatefulWidget {
  const TabBarShowcasePage({super.key});

  @override
  State<TabBarShowcasePage> createState() => _TabBarShowcasePageState();
}

class _TabBarShowcasePageState extends State<TabBarShowcasePage> {
  int _makerIndex = 0;
  int _checkerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Tab Bar',
      figmaName: 'O Tab Bar/ Maker · O Tab Bar/ Checker',
      description:
          'Bottom navigation bar với 2 case:\n'
          '• Maker: Trang chủ, Tài khoản, Thanh toán, Thẻ, Thêm\n'
          '• Checker: Trang chủ, Phê duyệt, Tài khoản, Thẻ, Thêm\n'
          'Tab active dùng icon Bold, label trắng, glow highlight.',
      sections: [
        // ── Maker ────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Maker – Interactive',
          description: 'Figma: O Tab Bar/ Maker. Tap để đổi tab.',
          wrap: false,
          children: [
            DsTabBar(
              items: kDsTabBarMakerItems,
              currentIndex: _makerIndex,
              onTap: (i) => setState(() => _makerIndex = i),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Maker – All states',
          description: 'Trang chủ, Tài khoản, Thanh toán, Thẻ, Thêm.',
          wrap: false,
          children: [
            for (var i = 0; i < kDsTabBarMakerItems.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DsTabBar(
                  items: kDsTabBarMakerItems,
                  currentIndex: i,
                  onTap: (_) {},
                  showOverlay: false,
                ),
              ),
          ],
        ),

        // ── Checker ──────────────────────────────────────────────
        ShowcaseSection(
          title: 'Checker – Interactive',
          description: 'Figma: O Tab Bar/ Checker. Tap để đổi tab.',
          wrap: false,
          children: [
            DsTabBar(
              items: kDsTabBarCheckerItems,
              currentIndex: _checkerIndex,
              onTap: (i) => setState(() => _checkerIndex = i),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Checker – All states',
          description: 'Trang chủ, Phê duyệt, Tài khoản, Thẻ, Thêm.',
          wrap: false,
          children: [
            for (var i = 0; i < kDsTabBarCheckerItems.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DsTabBar(
                  items: kDsTabBarCheckerItems,
                  currentIndex: i,
                  onTap: (_) {},
                  showOverlay: false,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
