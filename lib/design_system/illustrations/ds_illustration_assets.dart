/// Illustration assets from Figma `A Illustration` (Design System V2 Mobile).
///
/// Thêm illustration mới:
///   1. Đặt file vào  assets/illustrations/ (hoặc subfolder)
///   2. Chạy: python tool/generate_assets.py
abstract final class DsIllustrationAssets {
  static const _base = 'assets/illustrations';

  static const clock = '$_base/clock.png';
  static const confirm = '$_base/confirm.png';
  static const delete = '$_base/delete.png';
  static const docx = '$_base/docx.png';
  static const empty = '$_base/empty.png';
  static const error = '$_base/error.png';
  static const errorFile = '$_base/error_file.png';
  static const feedback = '$_base/feedback.png';
  static const loading = '$_base/loading.png';
  static const notFound404 = '$_base/not_found_404.png';
  static const notification = '$_base/notification.png';
  static const pdf = '$_base/pdf.png';
  static const pngJpgJpeg = '$_base/png_jpg_jpeg.png';
  static const search = '$_base/search.png';
  static const success = '$_base/success.png';
  static const unableToLoadData = '$_base/unable_to_load_data.png';
  static const upload = '$_base/upload.png';
  static const warning = '$_base/warning.png';
  static const xlsx = '$_base/xlsx.png';
  static const xml = '$_base/xml.png';

  static const flagAuAustralia = '$_base/flags/au_australia.png';
  static const flagCaCanada = '$_base/flags/ca_canada.png';
  static const flagChSwitzerland = '$_base/flags/ch_switzerland.png';
  static const flagCnChina = '$_base/flags/cn_china.png';
  static const flagEuEuropeanUnion = '$_base/flags/eu_european_union.png';
  static const flagGbUnitedKingdom = '$_base/flags/gb_united_kingdom.png';
  static const flagHkHongKong = '$_base/flags/hk_hong_kong.png';
  static const flagJpJapan = '$_base/flags/jp_japan.png';
  static const flagKrKorea = '$_base/flags/kr_korea.png';
  static const flagNzNewZealand = '$_base/flags/nz_new_zealand.png';
  static const flagSgSingapore = '$_base/flags/sg_singapore.png';
  static const flagThThailand = '$_base/flags/th_thailand.png';
  static const flagUsUnitedStates = '$_base/flags/us_united_states.png';
  static const flagVnd = '$_base/flags/vnd.png';

  static const labelRemind = '$_base/labels/remind.png';

  static const all = [
    clock,
    confirm,
    delete,
    docx,
    empty,
    error,
    errorFile,
    feedback,
    loading,
    notFound404,
    notification,
    pdf,
    pngJpgJpeg,
    search,
    success,
    unableToLoadData,
    upload,
    warning,
    xlsx,
    xml,
    flagAuAustralia,
    flagCaCanada,
    flagChSwitzerland,
    flagCnChina,
    flagEuEuropeanUnion,
    flagGbUnitedKingdom,
    flagHkHongKong,
    flagJpJapan,
    flagKrKorea,
    flagNzNewZealand,
    flagSgSingapore,
    flagThThailand,
    flagUsUnitedStates,
    flagVnd,
    labelRemind,
  ];
}

enum DsIllustrationName {
  clock,
  confirm,
  delete,
  docx,
  empty,
  error,
  errorFile,
  feedback,
  loading,
  notFound404,
  notification,
  pdf,
  pngJpgJpeg,
  search,
  success,
  unableToLoadData,
  upload,
  warning,
  xlsx,
  xml,
  flagAuAustralia,
  flagCaCanada,
  flagChSwitzerland,
  flagCnChina,
  flagEuEuropeanUnion,
  flagGbUnitedKingdom,
  flagHkHongKong,
  flagJpJapan,
  flagKrKorea,
  flagNzNewZealand,
  flagSgSingapore,
  flagThThailand,
  flagUsUnitedStates,
  flagVnd,
  labelRemind,
}

extension DsIllustrationNameX on DsIllustrationName {
  String get assetPath => switch (this) {
        DsIllustrationName.clock => DsIllustrationAssets.clock,
        DsIllustrationName.confirm => DsIllustrationAssets.confirm,
        DsIllustrationName.delete => DsIllustrationAssets.delete,
        DsIllustrationName.docx => DsIllustrationAssets.docx,
        DsIllustrationName.empty => DsIllustrationAssets.empty,
        DsIllustrationName.error => DsIllustrationAssets.error,
        DsIllustrationName.errorFile => DsIllustrationAssets.errorFile,
        DsIllustrationName.feedback => DsIllustrationAssets.feedback,
        DsIllustrationName.loading => DsIllustrationAssets.loading,
        DsIllustrationName.notFound404 => DsIllustrationAssets.notFound404,
        DsIllustrationName.notification => DsIllustrationAssets.notification,
        DsIllustrationName.pdf => DsIllustrationAssets.pdf,
        DsIllustrationName.pngJpgJpeg => DsIllustrationAssets.pngJpgJpeg,
        DsIllustrationName.search => DsIllustrationAssets.search,
        DsIllustrationName.success => DsIllustrationAssets.success,
        DsIllustrationName.unableToLoadData => DsIllustrationAssets.unableToLoadData,
        DsIllustrationName.upload => DsIllustrationAssets.upload,
        DsIllustrationName.warning => DsIllustrationAssets.warning,
        DsIllustrationName.xlsx => DsIllustrationAssets.xlsx,
        DsIllustrationName.xml => DsIllustrationAssets.xml,
        DsIllustrationName.flagAuAustralia => DsIllustrationAssets.flagAuAustralia,
        DsIllustrationName.flagCaCanada => DsIllustrationAssets.flagCaCanada,
        DsIllustrationName.flagChSwitzerland => DsIllustrationAssets.flagChSwitzerland,
        DsIllustrationName.flagCnChina => DsIllustrationAssets.flagCnChina,
        DsIllustrationName.flagEuEuropeanUnion => DsIllustrationAssets.flagEuEuropeanUnion,
        DsIllustrationName.flagGbUnitedKingdom => DsIllustrationAssets.flagGbUnitedKingdom,
        DsIllustrationName.flagHkHongKong => DsIllustrationAssets.flagHkHongKong,
        DsIllustrationName.flagJpJapan => DsIllustrationAssets.flagJpJapan,
        DsIllustrationName.flagKrKorea => DsIllustrationAssets.flagKrKorea,
        DsIllustrationName.flagNzNewZealand => DsIllustrationAssets.flagNzNewZealand,
        DsIllustrationName.flagSgSingapore => DsIllustrationAssets.flagSgSingapore,
        DsIllustrationName.flagThThailand => DsIllustrationAssets.flagThThailand,
        DsIllustrationName.flagUsUnitedStates => DsIllustrationAssets.flagUsUnitedStates,
        DsIllustrationName.flagVnd => DsIllustrationAssets.flagVnd,
        DsIllustrationName.labelRemind => DsIllustrationAssets.labelRemind,
      };

  String get label => switch (this) {
        DsIllustrationName.clock => 'Clock',
        DsIllustrationName.confirm => 'Confirm',
        DsIllustrationName.delete => 'Delete',
        DsIllustrationName.docx => 'Docx',
        DsIllustrationName.empty => 'Empty',
        DsIllustrationName.error => 'Error',
        DsIllustrationName.errorFile => 'Error File',
        DsIllustrationName.feedback => 'Feedback',
        DsIllustrationName.loading => 'Loading',
        DsIllustrationName.notFound404 => 'Not Found 404',
        DsIllustrationName.notification => 'Notification',
        DsIllustrationName.pdf => 'Pdf',
        DsIllustrationName.pngJpgJpeg => 'Png Jpg Jpeg',
        DsIllustrationName.search => 'Search',
        DsIllustrationName.success => 'Success',
        DsIllustrationName.unableToLoadData => 'Unable To Load Data',
        DsIllustrationName.upload => 'Upload',
        DsIllustrationName.warning => 'Warning',
        DsIllustrationName.xlsx => 'Xlsx',
        DsIllustrationName.xml => 'Xml',
        DsIllustrationName.flagAuAustralia => 'Flag Au Australia',
        DsIllustrationName.flagCaCanada => 'Flag Ca Canada',
        DsIllustrationName.flagChSwitzerland => 'Flag Ch Switzerland',
        DsIllustrationName.flagCnChina => 'Flag Cn China',
        DsIllustrationName.flagEuEuropeanUnion => 'Flag Eu European Union',
        DsIllustrationName.flagGbUnitedKingdom => 'Flag Gb United Kingdom',
        DsIllustrationName.flagHkHongKong => 'Flag Hk Hong Kong',
        DsIllustrationName.flagJpJapan => 'Flag Jp Japan',
        DsIllustrationName.flagKrKorea => 'Flag Kr Korea',
        DsIllustrationName.flagNzNewZealand => 'Flag Nz New Zealand',
        DsIllustrationName.flagSgSingapore => 'Flag Sg Singapore',
        DsIllustrationName.flagThThailand => 'Flag Th Thailand',
        DsIllustrationName.flagUsUnitedStates => 'Flag Us United States',
        DsIllustrationName.flagVnd => 'Flag Vnd',
        DsIllustrationName.labelRemind => 'Label Remind',
      };
}
