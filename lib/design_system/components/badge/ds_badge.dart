import 'package:flutter/material.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';

enum DsBadgeType { notification, role }

enum DsBadgeNotificationStatus {
  reminder,
  balance,
  done,
  error,
  warning,
  remind,
  bee,
  introduce,
}

enum DsBadgeRoleStatus {
  maker,
  checker,
  avatarMaker,
  avatarChecker,
}

/// Badge from Figma `ABadgeNotification` (Design System V2 Mobile).
class DsBadge extends StatelessWidget {
  const DsBadge.notification({
    super.key,
    required this.status,
  })  : type = DsBadgeType.notification,
        roleStatus = null;

  const DsBadge.role({
    super.key,
    required this.roleStatus,
  })  : type = DsBadgeType.role,
        status = null;

  final DsBadgeType type;
  final DsBadgeNotificationStatus? status;
  final DsBadgeRoleStatus? roleStatus;

  @override
  Widget build(BuildContext context) {
    final colors = _colors(context);

    return switch (type) {
      DsBadgeType.notification => _NotificationBadge(status: status!),
      DsBadgeType.role => _RoleBadge(
          status: roleStatus!,
          colors: colors,
        ),
    };
  }
}

class _NotificationBadge extends StatelessWidget {
  const _NotificationBadge({required this.status});

  final DsBadgeNotificationStatus status;

  static const _size = AppIconSize.m;

  @override
  Widget build(BuildContext context) {
    return DsIcon(
      name: _assetForStatus(status),
      size: _size,
    );
  }

  static DsIconName _assetForStatus(DsBadgeNotificationStatus status) {
    return switch (status) {
      DsBadgeNotificationStatus.reminder => DsIconName.badgeReminder,
      DsBadgeNotificationStatus.balance => DsIconName.badgeBalance,
      DsBadgeNotificationStatus.done => DsIconName.badgeDone,
      DsBadgeNotificationStatus.error => DsIconName.badgeError,
      DsBadgeNotificationStatus.warning => DsIconName.badgeWarning,
      DsBadgeNotificationStatus.remind => DsIconName.badgeRemind,
      DsBadgeNotificationStatus.bee => DsIconName.badgeBee,
      DsBadgeNotificationStatus.introduce => DsIconName.badgeIntroduce,
    };
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({
    required this.status,
    required this.colors,
  });

  final DsBadgeRoleStatus status;
  final SemanticColors colors;

  bool get _isAvatar =>
      status == DsBadgeRoleStatus.avatarMaker ||
      status == DsBadgeRoleStatus.avatarChecker;

  String get _label => switch (status) {
        DsBadgeRoleStatus.maker || DsBadgeRoleStatus.avatarMaker =>
          'Người tạo',
        DsBadgeRoleStatus.checker || DsBadgeRoleStatus.avatarChecker =>
          'Người duyệt',
      };

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.backgroundBrandPrimary4,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: _isAvatar
            ? Border.all(
                color: colors.borderBrandPrimary3,
                width: AppStroke.s,
              )
            : null,
        boxShadow: _isAvatar
            ? [
                BoxShadow(
                  color: colors.backgroundBrandPrimary1.withValues(alpha: 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _isAvatar ? AppPadding.s : AppPadding.l,
          vertical: _isAvatar ? AppPadding.xs : AppPadding.s,
        ),
        child: Text(
          _label,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeS,
            fontWeight: AppTypography.fontWeightSemibold,
            height: AppFont.lineheightS / AppFont.sizeS,
            letterSpacing: 0.25,
            color: colors.textBrandPrimary1,
          ),
        ),
      ),
    );
  }
}

SemanticColors _colors(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? SemanticColors.dark
      : SemanticColors.light;
}
