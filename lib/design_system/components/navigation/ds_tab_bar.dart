import 'package:flutter/material.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Bottom tab identifiers for [DsTabBar] (Figma `M Tab Bar/ Item *`).
enum DsTabBarItem {
  home,
  pheDuyet,
  account,
  payment,
  cards,
  more,
}

/// Data for a single tab in [DsTabBar].
class DsTabBarItemData {
  const DsTabBarItemData({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
  });

  final String label;
  final DsIconName activeIcon;
  final DsIconName inactiveIcon;
}

/// Bottom navigation tab bar from Figma `M Tab Bar` / `O Tab Bar`.
///
/// Hai case: [kDsTabBarMakerItems] và [kDsTabBarCheckerItems].
/// Active tab shows a bold icon, white label, and a soft glow highlight.
class DsTabBar extends StatelessWidget {
  const DsTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = kDsTabBarMakerItems,
    this.showOverlay = true,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<DsTabBarItemData> items;
  final bool showOverlay;

  static const _inactiveOpacity = 0.7;
  static const _inactiveContentColor = Color(0xFFECF5FA);
  static const _itemHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    // Figma `M Tab Bar` luôn Clip content (`overflow-clip`) theo bo góc.
    final barRadius = BorderRadius.circular(AppRadius.s);
    final bar = ClipRRect(
      borderRadius: barRadius,
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.s),
        decoration: BoxDecoration(
          color: colors.backgroundTertiary,
          borderRadius: barRadius,
        ),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: _DsTabBarItemWidget(
                  data: items[i],
                  selected: i == currentIndex,
                  onTap: () => onTap(i),
                  colors: colors,
                ),
              ),
          ],
        ),
      ),
    );

    if (!showOverlay) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppPadding.l,
          0,
          AppPadding.l,
          AppSpacing.n2xl,
        ),
        child: bar,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.4093, 1.0],
          colors: [
            colors.backgroundSecondary.withValues(alpha: 0),
            colors.backgroundSecondary,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppPadding.l,
          0,
          AppPadding.l,
          AppSpacing.n2xl,
        ),
        child: bar,
      ),
    );
  }
}

class _DsTabBarItemWidget extends StatelessWidget {
  const _DsTabBarItemWidget({
    required this.data,
    required this.selected,
    required this.onTap,
    required this.colors,
  });

  final DsTabBarItemData data;
  final bool selected;
  final VoidCallback onTap;
  final SemanticColors colors;

  static const _itemHeight = DsTabBar._itemHeight;
  static const _inactiveOpacity = DsTabBar._inactiveOpacity;
  static const _inactiveContentColor = DsTabBar._inactiveContentColor;

  @override
  Widget build(BuildContext context) {
    final contentColor =
        selected ? colors.textBrandOnPrimary : _inactiveContentColor;

    return Semantics(
      button: true,
      selected: selected,
      label: data.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: _itemHeight,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              if (selected) _ActiveGlow(colors: colors),
              Opacity(
                opacity: selected ? 1 : _inactiveOpacity,
                child: Padding(
                  padding: const EdgeInsets.only(top: AppPadding.m),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DsIcon(
                        name: selected ? data.activeIcon : data.inactiveIcon,
                        size: AppIconSize.m,
                        color: contentColor,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        data.label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: AppFont.sizeXs,
                          fontWeight: AppTypography.fontWeightSemibold,
                          height: AppFont.lineheightXs / AppFont.sizeXs,
                          letterSpacing: 0.25,
                          color: contentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveGlow extends StatelessWidget {
  const _ActiveGlow({required this.colors});

  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 35,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 66,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: RadialGradient(
              colors: [
                colors.blur1.withValues(alpha: 0.85),
                colors.blur1.withValues(alpha: 0.35),
                colors.blur1.withValues(alpha: 0),
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

/// Item data cho từng tab — dùng để compose tab bar tuỳ theo vai trò người dùng.
const kTabItemHome = DsTabBarItemData(
  label: 'Trang chủ',
  activeIcon: DsIconName.aboldHome,
  inactiveIcon: DsIconName.alinearHome,
);

/// Figma: `M Tab Bar/ Item Giao dịch chờ phê duyệt`.
/// Cả active lẫn inactive đều dùng ALinear/Mission (Figma không có ABold/Mission).
const kTabItemPheDuyet = DsTabBarItemData(
  label: 'Phê duyệt',
  activeIcon: DsIconName.alinearMission,
  inactiveIcon: DsIconName.alinearMission,
);

const kTabItemAccount = DsTabBarItemData(
  label: 'Tài khoản',
  activeIcon: DsIconName.aboldWallet,
  inactiveIcon: DsIconName.alinearWallet,
);

const kTabItemPayment = DsTabBarItemData(
  label: 'Thanh toán',
  activeIcon: DsIconName.aboldPayment,
  inactiveIcon: DsIconName.alinearPayment,
);

const kTabItemCards = DsTabBarItemData(
  label: 'Thẻ',
  activeIcon: DsIconName.aboldCards,
  inactiveIcon: DsIconName.alinearCards,
);

const kTabItemMore = DsTabBarItemData(
  label: 'Thêm',
  activeIcon: DsIconName.aboldMore,
  inactiveIcon: DsIconName.alinearMore,
);

/// Tab bar Maker — Figma `O Tab Bar/ Maker`.
/// Thứ tự: Trang chủ → Tài khoản → Thanh toán → Thẻ → Thêm.
const kDsTabBarMakerItems = <DsTabBarItemData>[
  kTabItemHome,
  kTabItemAccount,
  kTabItemPayment,
  kTabItemCards,
  kTabItemMore,
];

/// Tab bar Checker — Figma `O Tab Bar/ Checker`.
/// Thứ tự: Trang chủ → Phê duyệt → Tài khoản → Thẻ → Thêm.
const kDsTabBarCheckerItems = <DsTabBarItemData>[
  kTabItemHome,
  kTabItemPheDuyet,
  kTabItemAccount,
  kTabItemCards,
  kTabItemMore,
];
