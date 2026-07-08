/// Icon assets from Figma `A Icons` (Design System V2 Mobile).
///
/// Thêm icon mới:
///   1. Đặt file .svg vào  assets/icons/<group>/<name>.svg
///   2. Chạy: python tool/generate_assets.py
abstract final class DsIconAssets {
  static const _base = 'assets/icons';

  // ── Actions ─────────────────────────────────────────────────
  static const aboldError = '$_base/actions/ABold_Error.webp';
  static const aboldInfo = '$_base/actions/ABold_Info.webp';
  static const alinearAdd4x = '$_base/actions/ALinear_Add_4x.webp';
  static const alinearBottom = '$_base/actions/ALinear_Bottom.webp';
  static const alinearCalendar = '$_base/actions/ALinear_Calendar.webp';
  static const alinearCancel = '$_base/actions/ALinear_Cancel.webp';
  static const alinearDownload4x = '$_base/actions/ALinear_Download_4x.webp';
  static const alinearHide = '$_base/actions/ALinear_Hide.webp';
  static const alinearLeft = '$_base/actions/ALinear_Left.webp';
  static const alinearLoading = '$_base/actions/ALinear_Loading.webp';
  static const alinearRight = '$_base/actions/ALinear_Right.webp';
  static const alinearSearch4x = '$_base/actions/ALinear_Search_4x.webp';
  static const alinearUp = '$_base/actions/ALinear_Up.webp';
  static const alinearUpload4x = '$_base/actions/ALinear_Upload_4x.webp';
  static const alinearVisible = '$_base/actions/ALinear_Visible.webp';
  static const add = '$_base/actions/add.svg';
  static const check = '$_base/actions/check.svg';
  static const close = '$_base/actions/close.svg';
  static const copy = '$_base/actions/copy.svg';
  static const delete = '$_base/actions/delete.svg';
  static const download = '$_base/actions/download.svg';
  static const edit = '$_base/actions/edit.svg';
  static const filter = '$_base/actions/filter.svg';
  static const more = '$_base/actions/more.svg';
  static const refresh = '$_base/actions/refresh.svg';
  static const search = '$_base/actions/search.svg';
  static const share = '$_base/actions/share.svg';
  static const sort = '$_base/actions/sort.svg';
  static const upload = '$_base/actions/upload.svg';

  // ── Navigation ──────────────────────────────────────────────
  static const arrowDown = '$_base/navigation/arrow_down.svg';
  static const arrowLeft = '$_base/navigation/arrow_left.svg';
  static const arrowRight = '$_base/navigation/arrow_right.svg';
  static const arrowUp = '$_base/navigation/arrow_up.svg';
  static const back = '$_base/navigation/back.svg';
  static const chevronDown = '$_base/navigation/chevron_down.svg';
  static const chevronUp = '$_base/navigation/chevron_up.svg';
  static const forward = '$_base/navigation/forward.svg';
  static const home = '$_base/navigation/home.svg';
  static const menu = '$_base/navigation/menu.svg';
  static const settings = '$_base/navigation/settings.svg';

  // ── Social ──────────────────────────────────────────────────
  static const apple = '$_base/social/apple.svg';
  static const facebook = '$_base/social/facebook.svg';
  static const google = '$_base/social/google.svg';

  // ── Status ──────────────────────────────────────────────────
  static const badgeBalance = '$_base/status/badge_balance.webp';
  static const badgeBee = '$_base/status/badge_bee.webp';
  static const badgeDone = '$_base/status/badge_done.webp';
  static const badgeError = '$_base/status/badge_error.webp';
  static const badgeIntroduce = '$_base/status/badge_introduce.webp';
  static const badgeRemind = '$_base/status/badge_remind.webp';
  static const badgeReminder = '$_base/status/badge_reminder.webp';
  static const badgeWarning = '$_base/status/badge_warning.webp';
  static const error = '$_base/status/error.svg';
  static const info = '$_base/status/info.svg';
  static const success = '$_base/status/success.svg';
  static const warning = '$_base/status/warning.svg';

}

enum DsIconName {
  // Actions
  aboldError,
  aboldInfo,
  alinearAdd4x,
  alinearBottom,
  alinearCalendar,
  alinearCancel,
  alinearDownload4x,
  alinearHide,
  alinearLeft,
  alinearLoading,
  alinearRight,
  alinearSearch4x,
  alinearUp,
  alinearUpload4x,
  alinearVisible,
  add,
  check,
  close,
  copy,
  delete,
  download,
  edit,
  filter,
  more,
  refresh,
  search,
  share,
  sort,
  upload,

  // Navigation
  arrowDown,
  arrowLeft,
  arrowRight,
  arrowUp,
  back,
  chevronDown,
  chevronUp,
  forward,
  home,
  menu,
  settings,

  // Social
  apple,
  facebook,
  google,

  // Status
  badgeBalance,
  badgeBee,
  badgeDone,
  badgeError,
  badgeIntroduce,
  badgeRemind,
  badgeReminder,
  badgeWarning,
  error,
  info,
  success,
  warning,
}

/// Ordered group names for showcase and tooling.
const kDsIconGroupOrder = [
  'actions',
  'navigation',
  'social',
  'status',
];

extension DsIconNameX on DsIconName {
  String get assetPath => switch (this) {
        DsIconName.aboldError => DsIconAssets.aboldError,
        DsIconName.aboldInfo => DsIconAssets.aboldInfo,
        DsIconName.alinearAdd4x => DsIconAssets.alinearAdd4x,
        DsIconName.alinearBottom => DsIconAssets.alinearBottom,
        DsIconName.alinearCalendar => DsIconAssets.alinearCalendar,
        DsIconName.alinearCancel => DsIconAssets.alinearCancel,
        DsIconName.alinearDownload4x => DsIconAssets.alinearDownload4x,
        DsIconName.alinearHide => DsIconAssets.alinearHide,
        DsIconName.alinearLeft => DsIconAssets.alinearLeft,
        DsIconName.alinearLoading => DsIconAssets.alinearLoading,
        DsIconName.alinearRight => DsIconAssets.alinearRight,
        DsIconName.alinearSearch4x => DsIconAssets.alinearSearch4x,
        DsIconName.alinearUp => DsIconAssets.alinearUp,
        DsIconName.alinearUpload4x => DsIconAssets.alinearUpload4x,
        DsIconName.alinearVisible => DsIconAssets.alinearVisible,
        DsIconName.add => DsIconAssets.add,
        DsIconName.check => DsIconAssets.check,
        DsIconName.close => DsIconAssets.close,
        DsIconName.copy => DsIconAssets.copy,
        DsIconName.delete => DsIconAssets.delete,
        DsIconName.download => DsIconAssets.download,
        DsIconName.edit => DsIconAssets.edit,
        DsIconName.filter => DsIconAssets.filter,
        DsIconName.more => DsIconAssets.more,
        DsIconName.refresh => DsIconAssets.refresh,
        DsIconName.search => DsIconAssets.search,
        DsIconName.share => DsIconAssets.share,
        DsIconName.sort => DsIconAssets.sort,
        DsIconName.upload => DsIconAssets.upload,
        DsIconName.arrowDown => DsIconAssets.arrowDown,
        DsIconName.arrowLeft => DsIconAssets.arrowLeft,
        DsIconName.arrowRight => DsIconAssets.arrowRight,
        DsIconName.arrowUp => DsIconAssets.arrowUp,
        DsIconName.back => DsIconAssets.back,
        DsIconName.chevronDown => DsIconAssets.chevronDown,
        DsIconName.chevronUp => DsIconAssets.chevronUp,
        DsIconName.forward => DsIconAssets.forward,
        DsIconName.home => DsIconAssets.home,
        DsIconName.menu => DsIconAssets.menu,
        DsIconName.settings => DsIconAssets.settings,
        DsIconName.apple => DsIconAssets.apple,
        DsIconName.facebook => DsIconAssets.facebook,
        DsIconName.google => DsIconAssets.google,
        DsIconName.badgeBalance => DsIconAssets.badgeBalance,
        DsIconName.badgeBee => DsIconAssets.badgeBee,
        DsIconName.badgeDone => DsIconAssets.badgeDone,
        DsIconName.badgeError => DsIconAssets.badgeError,
        DsIconName.badgeIntroduce => DsIconAssets.badgeIntroduce,
        DsIconName.badgeRemind => DsIconAssets.badgeRemind,
        DsIconName.badgeReminder => DsIconAssets.badgeReminder,
        DsIconName.badgeWarning => DsIconAssets.badgeWarning,
        DsIconName.error => DsIconAssets.error,
        DsIconName.info => DsIconAssets.info,
        DsIconName.success => DsIconAssets.success,
        DsIconName.warning => DsIconAssets.warning,
      };

  String get label => switch (this) {
        DsIconName.aboldError => 'Abold Error',
        DsIconName.aboldInfo => 'Abold Info',
        DsIconName.alinearAdd4x => 'Alinear Add 4x',
        DsIconName.alinearBottom => 'Alinear Bottom',
        DsIconName.alinearCalendar => 'Alinear Calendar',
        DsIconName.alinearCancel => 'Alinear Cancel',
        DsIconName.alinearDownload4x => 'Alinear Download 4x',
        DsIconName.alinearHide => 'Alinear Hide',
        DsIconName.alinearLeft => 'Alinear Left',
        DsIconName.alinearLoading => 'Alinear Loading',
        DsIconName.alinearRight => 'Alinear Right',
        DsIconName.alinearSearch4x => 'Alinear Search 4x',
        DsIconName.alinearUp => 'Alinear Up',
        DsIconName.alinearUpload4x => 'Alinear Upload 4x',
        DsIconName.alinearVisible => 'Alinear Visible',
        DsIconName.add => 'Add',
        DsIconName.check => 'Check',
        DsIconName.close => 'Close',
        DsIconName.copy => 'Copy',
        DsIconName.delete => 'Delete',
        DsIconName.download => 'Download',
        DsIconName.edit => 'Edit',
        DsIconName.filter => 'Filter',
        DsIconName.more => 'More',
        DsIconName.refresh => 'Refresh',
        DsIconName.search => 'Search',
        DsIconName.share => 'Share',
        DsIconName.sort => 'Sort',
        DsIconName.upload => 'Upload',
        DsIconName.arrowDown => 'Arrow Down',
        DsIconName.arrowLeft => 'Arrow Left',
        DsIconName.arrowRight => 'Arrow Right',
        DsIconName.arrowUp => 'Arrow Up',
        DsIconName.back => 'Back',
        DsIconName.chevronDown => 'Chevron Down',
        DsIconName.chevronUp => 'Chevron Up',
        DsIconName.forward => 'Forward',
        DsIconName.home => 'Home',
        DsIconName.menu => 'Menu',
        DsIconName.settings => 'Settings',
        DsIconName.apple => 'Apple',
        DsIconName.facebook => 'Facebook',
        DsIconName.google => 'Google',
        DsIconName.badgeBalance => 'Badge Balance',
        DsIconName.badgeBee => 'Badge Bee',
        DsIconName.badgeDone => 'Badge Done',
        DsIconName.badgeError => 'Badge Error',
        DsIconName.badgeIntroduce => 'Badge Introduce',
        DsIconName.badgeRemind => 'Badge Remind',
        DsIconName.badgeReminder => 'Badge Reminder',
        DsIconName.badgeWarning => 'Badge Warning',
        DsIconName.error => 'Error',
        DsIconName.info => 'Info',
        DsIconName.success => 'Success',
        DsIconName.warning => 'Warning',
      };

  /// Folder group this icon belongs to (e.g. 'actions', 'navigation').
  String get group => assetPath.split('/')[2];
}
