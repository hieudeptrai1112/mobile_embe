import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../components/status/ds_status.dart';
import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../illustrations/ds_illustration.dart';
import '../../illustrations/ds_illustration_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../../utils/ds_file_download.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

enum DsUploadFileMode {
  /// `O Upload File / Creat New File` — picker + remove.
  upload,

  /// `O Upload File / View File` — read-only + download.
  view,
}

enum DsUploadFileStatus { uploading, success, error }

/// Represents a single file entry in [DsUploadFile].
class DsUploadFileItem {
  const DsUploadFileItem({
    required this.id,
    required this.name,
    this.path,
    this.url,
    this.sizeBytes,
    this.status = DsUploadFileStatus.success,
    this.uploadProgress,
    this.errorMessage,
  });

  final String id;
  final String name;

  /// Local path returned by the device file picker.
  final String? path;

  /// Remote URL used for download in [DsUploadFileMode.view].
  final String? url;
  final int? sizeBytes;
  final DsUploadFileStatus status;
  final double? uploadProgress;
  final String? errorMessage;

  DsUploadFileItem copyWith({
    String? id,
    String? name,
    String? path,
    String? url,
    int? sizeBytes,
    DsUploadFileStatus? status,
    double? uploadProgress,
    String? errorMessage,
  }) {
    return DsUploadFileItem(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      url: url ?? this.url,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      status: status ?? this.status,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ── Main widget ───────────────────────────────────────────────────────────────

/// Upload / view file component from Figma `O Upload File`.
///
/// [DsUploadFileMode.upload] (`Creat New File`):
/// - Bordered input with placeholder + upload icon.
/// - File list below a divider; collapse at [collapseThreshold].
///
/// [DsUploadFileMode.view] (`View File`):
/// - Read-only bordered card with in-box title.
/// - Download action per file; empty state when [files] is empty.
class DsUploadFile extends StatefulWidget {
  const DsUploadFile({
    super.key,
    this.mode = DsUploadFileMode.upload,
    this.label,
    this.required = false,
    this.helpText,
    this.errorText,
    this.description,
    this.statusLabel,
    this.statusVariant = DsStatusVariant.warning,
    this.emptyMessage = 'Bạn chưa có tệp tin',
    this.showEmptyMessage = true,
    this.enabled = true,
    this.files = const [],
    this.onTap,
    this.onFilesPicked,
    this.onRemove,
    this.onDownload,
    this.placeholder = 'Input text',
    this.collapseThreshold = 2,
    this.allowMultiple = true,
    this.allowedExtensions,
  });

  final DsUploadFileMode mode;
  final String? label;
  final bool required;
  final String? helpText;
  final String? errorText;

  /// Description shown inside the bordered box in [DsUploadFileMode.view].
  final String? description;

  /// Optional status tag below the title in [DsUploadFileMode.view].
  final String? statusLabel;
  final DsStatusVariant statusVariant;
  final String emptyMessage;

  /// When false and [files] is empty, only the title row is shown (no empty text).
  final bool showEmptyMessage;
  final bool enabled;
  final List<DsUploadFileItem> files;

  /// Custom tap handler. When set, overrides the built-in file picker.
  final VoidCallback? onTap;

  /// Called after the user picks file(s) from the device.
  final ValueChanged<List<DsUploadFileItem>>? onFilesPicked;
  final ValueChanged<String>? onRemove;
  /// Called when the user taps download. When omitted, [DsUploadFile] downloads
  /// from [DsUploadFileItem.url] or [DsUploadFileItem.path] automatically.
  final Future<void> Function(String id)? onDownload;

  /// Placeholder text shown in the input header row.
  final String placeholder;

  /// Number of files visible when collapsed. Figma default: 2.
  final int collapseThreshold;

  /// Allow selecting multiple files in one picker session.
  final bool allowMultiple;

  /// Restrict picker to specific extensions, e.g. `['pdf', 'jpg']`.
  final List<String>? allowedExtensions;

  @override
  State<DsUploadFile> createState() => _DsUploadFileState();
}

class _DsUploadFileState extends State<DsUploadFile> {
  bool _expanded = false;
  bool _picking = false;
  final List<DsUploadFileItem> _localFiles = [];

  bool get _isControlled => widget.onFilesPicked != null;

  List<DsUploadFileItem> get _effectiveFiles =>
      _isControlled ? widget.files : [...widget.files, ..._localFiles];

  bool get _hasInputError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  bool get _hasExtraFiles =>
      _effectiveFiles.length > widget.collapseThreshold;

  List<DsUploadFileItem> get _visibleFiles {
    if (!_hasExtraFiles || _expanded) return _effectiveFiles;
    return _effectiveFiles.sublist(0, widget.collapseThreshold);
  }

  void _handleRemove(String id) {
    if (widget.onRemove != null) {
      widget.onRemove!(id);
      return;
    }
    setState(() => _localFiles.removeWhere((f) => f.id == id));
  }

  Future<void> _handleDownload(String id) async {
    if (!widget.enabled) return;

    final index = _effectiveFiles.indexWhere((file) => file.id == id);
    if (index < 0) return;
    final item = _effectiveFiles[index];

    try {
      if (widget.onDownload != null) {
        await widget.onDownload!(id);
        return;
      }

      await DsFileDownload.download(
        fileName: item.name,
        path: item.path,
        url: item.url,
      );
    } catch (error, stackTrace) {
      debugPrint('DsUploadFile: download failed — $error\n$stackTrace');
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(
              error is StateError ? error.message : 'Không thể tải file: $error',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleUploadTap() async {
    if (!widget.enabled || _picking) return;

    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    setState(() => _picking = true);
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: widget.allowMultiple,
        type: widget.allowedExtensions != null
            ? FileType.custom
            : FileType.any,
        allowedExtensions: widget.allowedExtensions,
        withData: false,
        withReadStream: false,
      );

      if (!mounted || result == null || result.files.isEmpty) return;

      final picked = <DsUploadFileItem>[];
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      for (var i = 0; i < result.files.length; i++) {
        final file = result.files[i];
        picked.add(
          DsUploadFileItem(
            id: '${file.identifier ?? file.name}_${timestamp}_$i',
            name: file.name,
            path: file.path,
            sizeBytes: file.size,
          ),
        );
      }

      if (widget.onFilesPicked != null) {
        widget.onFilesPicked!(picked);
      } else {
        setState(() => _localFiles.addAll(picked));
      }
    } catch (error, stackTrace) {
      debugPrint('DsUploadFile: file picker failed — $error\n$stackTrace');
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text('Không thể chọn file: $error'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    if (widget.mode == DsUploadFileMode.view) {
      return _buildViewMode(colors);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          _ExternalLabel(
            label: widget.label!,
            required: widget.required,
            colors: colors,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.backgroundPrimary,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(
              color: _borderColor(colors),
              width: AppStroke.s,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _InputHeader(
                placeholder: widget.placeholder,
                required: widget.required && widget.label == null,
                enabled: widget.enabled && !_picking,
                colors: colors,
                onTap: widget.enabled && !_picking ? _handleUploadTap : null,
              ),
              if (_effectiveFiles.isNotEmpty) _buildUploadFileList(colors),
            ],
          ),
        ),
        if (_hasInputError) ...[
          const SizedBox(height: AppSpacing.xs),
          _InputErrorMessage(
            message: widget.errorText!,
            colors: colors,
          ),
        ] else if (widget.helpText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.helpText!,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
              color: colors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUploadFileList(SemanticColors colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppPadding.m,
        0,
        AppPadding.m,
        AppPadding.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(
            height: AppStroke.s,
            thickness: AppStroke.s,
            color: colors.borderPrimary,
          ),
          const SizedBox(height: AppSpacing.m),
          _buildFileItems(colors),
        ],
      ),
    );
  }

  Widget _buildFileItems(SemanticColors colors) {
    return Column(
      children: [
        for (var i = 0; i < _visibleFiles.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s),
          _FileItem(
            item: _visibleFiles[i],
            colors: colors,
            mode: widget.mode,
            onRemove: widget.enabled
                ? () => _handleRemove(_visibleFiles[i].id)
                : null,
            onDownload: widget.mode == DsUploadFileMode.view && widget.enabled
                ? () => _handleDownload(_visibleFiles[i].id)
                : null,
          ),
        ],
        if (_hasExtraFiles) ...[
          const SizedBox(height: AppSpacing.s),
          _ExpandToggle(
            expanded: _expanded,
            colors: colors,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
        ],
      ],
    );
  }

  Widget _buildViewMode(SemanticColors colors) {
    final hasFiles = _effectiveFiles.isNotEmpty;
    final showTitle = widget.label != null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.backgroundPrimary,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(
          color: colors.borderBrandPrimary4,
          width: AppStroke.s,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppPadding.m,
          hasFiles ? AppPadding.m : AppPadding.l,
          AppPadding.m,
          AppPadding.l,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showTitle) ...[
              _ViewTitleBlock(
                title: widget.label!,
                required: widget.required,
                description: widget.description,
                statusLabel: widget.statusLabel,
                statusVariant: widget.statusVariant,
                colors: colors,
                showDivider: hasFiles,
              ),
              if (hasFiles) const SizedBox(height: AppSpacing.m),
            ],
            if (hasFiles)
              _buildFileItems(colors)
            else if (showTitle && widget.showEmptyMessage)
              _ViewEmptyMessage(
                message: widget.emptyMessage,
                colors: colors,
              )
            else if (!showTitle)
              _ViewEmptyMessage(
                message: widget.emptyMessage,
                colors: colors,
              ),
          ],
        ),
      ),
    );
  }

  Color _borderColor(SemanticColors colors) {
    if (!widget.enabled) return colors.borderDisable1;
    if (_hasInputError) return colors.borderError1;
    return colors.borderBrandPrimary4;
  }
}

// ── View mode ─────────────────────────────────────────────────────────────────

class _ViewTitleBlock extends StatelessWidget {
  const _ViewTitleBlock({
    required this.title,
    required this.required,
    required this.colors,
    this.description,
    this.statusLabel,
    this.statusVariant = DsStatusVariant.warning,
    this.showDivider = false,
  });

  final String title;
  final bool required;
  final String? description;
  final String? statusLabel;
  final DsStatusVariant statusVariant;
  final bool showDivider;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppFont.sizeM,
                    fontWeight: AppTypography.fontWeightSemibold,
                    height: AppFont.lineheightM / AppFont.sizeM,
                    letterSpacing: 0.5,
                    color: colors.textPrimary,
                  ),
                ),
                if (required) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '*',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: AppFont.sizeM,
                      fontWeight: AppTypography.fontWeightSemibold,
                      height: AppFont.lineheightM / AppFont.sizeM,
                      letterSpacing: 0.5,
                      color: colors.iconError,
                    ),
                  ),
                ],
              ],
            ),
            if (statusLabel != null) ...[
              const SizedBox(height: AppSpacing.xs),
              DsStatus(
                label: statusLabel!,
                variant: statusVariant,
              ),
            ],
            if (description != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                description!,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: AppFont.sizeS,
                  height: AppFont.lineheightS / AppFont.sizeS,
                  letterSpacing: 0,
                  color: colors.textPrimary3,
                ),
              ),
            ],
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: AppSpacing.l),
          Divider(
            height: AppStroke.s,
            thickness: AppStroke.s,
            color: colors.borderPrimary,
          ),
        ],
      ],
    );
  }
}

class _ViewEmptyMessage extends StatelessWidget {
  const _ViewEmptyMessage({
    required this.message,
    required this.colors,
  });

  final String message;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppFont.sizeS,
        height: AppFont.lineheightS / AppFont.sizeS,
        letterSpacing: 0,
        color: colors.textSecondary,
      ),
    );
  }
}

// ── External label ────────────────────────────────────────────────────────────

class _ExternalLabel extends StatelessWidget {
  const _ExternalLabel({
    required this.label,
    required this.required,
    required this.colors,
  });

  final String label;
  final bool required;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeM,
            fontWeight: AppTypography.fontWeightSemibold,
            letterSpacing: 0.5,
            color: colors.textPrimary,
          ),
        ),
        if (required) ...[
          const SizedBox(width: AppSpacing.xs),
          Text(
            '*',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              fontWeight: AppTypography.fontWeightSemibold,
              color: colors.textError,
            ),
          ),
        ],
      ],
    );
  }
}

// ── Input header ──────────────────────────────────────────────────────────────

class _InputHeader extends StatelessWidget {
  const _InputHeader({
    required this.placeholder,
    required this.required,
    required this.enabled,
    required this.colors,
    this.onTap,
  });

  final String placeholder;
  final bool required;
  final bool enabled;
  final SemanticColors colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.m,
            vertical: 14,
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        placeholder,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: AppFont.sizeM,
                          fontWeight: AppTypography.fontWeightSemibold,
                          letterSpacing: 0.5,
                          color: enabled
                              ? colors.textPrimary
                              : colors.textDisable1,
                        ),
                      ),
                    ),
                    if (required) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '*',
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: AppFont.sizeM,
                          fontWeight: AppTypography.fontWeightSemibold,
                          color: colors.textError,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: DsIcon(
                  name: DsIconName.alinearUpload,
                  size: AppIconSize.m,
                  color: enabled
                      ? colors.textBrandPrimary1
                      : colors.iconDisable2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── File item ─────────────────────────────────────────────────────────────────

class _FileItem extends StatelessWidget {
  const _FileItem({
    required this.item,
    required this.colors,
    this.mode = DsUploadFileMode.upload,
    this.onRemove,
    this.onDownload,
  });

  final DsUploadFileItem item;
  final SemanticColors colors;
  final DsUploadFileMode mode;
  final VoidCallback? onRemove;
  final VoidCallback? onDownload;

  bool get _isView => mode == DsUploadFileMode.view;

  @override
  Widget build(BuildContext context) {
    final hasError =
        !_isView && item.status == DsUploadFileStatus.error;
    final nameParts = _splitFileName(item.name);

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FileTypeIllustration(fileName: item.name),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FileNameRow(
                      baseName: nameParts.$1,
                      extension: nameParts.$2,
                      colors: colors,
                    ),
                    if (item.sizeBytes != null)
                      Text(
                        _formatBytes(item.sizeBytes!),
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: AppFont.sizeS,
                          height: AppFont.lineheightS / AppFont.sizeS,
                          letterSpacing: 0,
                          color: _isView || hasError
                              ? colors.textSecondary
                              : colors.textTertiary,
                        ),
                      ),
                    if (hasError && item.errorMessage != null)
                      Text(
                        item.errorMessage!,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: AppFont.sizeS,
                          height: AppFont.lineheightS / AppFont.sizeS,
                          letterSpacing: 0,
                          color: colors.iconError,
                        ),
                      ),
                    if (!_isView &&
                        item.status == DsUploadFileStatus.uploading) ...[
                      const SizedBox(height: AppSpacing.xs),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppRadius.round),
                        child: LinearProgressIndicator(
                          value:
                              (item.uploadProgress ?? 0).clamp(0.0, 1.0),
                          minHeight: 4,
                          backgroundColor: colors.borderPrimary,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colors.textBrandPrimary1,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isView && onDownload != null) ...[
          GestureDetector(
            onTap: onDownload,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: DsIcon(
                name: DsIconName.alinearDownload,
                size: AppIconSize.m,
                color: colors.textBrandPrimary1,
              ),
            ),
          ),
        ] else if (!_isView && onRemove != null) ...[
          const SizedBox(width: AppSpacing.s),
          Opacity(
            opacity: 0.5,
            child: GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: AppIconSize.s,
                height: AppIconSize.s,
                child: Center(
                  child: DsIcon(
                    name: DsIconName.alinearCancel,
                    size: AppIconSize.s,
                    color: colors.iconNeutral1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );

    if (_isView) return content;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.xs,
        vertical: 6,
      ),
      decoration: hasError
          ? BoxDecoration(
              color: colors.backgroundDisable3,
              borderRadius: BorderRadius.circular(AppRadius.xs),
            )
          : null,
      child: content,
    );
  }

  static (String, String) _splitFileName(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex <= 0) return (fileName, '');
    return (fileName.substring(0, dotIndex), fileName.substring(dotIndex));
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return kb == kb.roundToDouble()
          ? '${kb.round()} KB'
          : '${kb.toStringAsFixed(1)} KB';
    }
    final mb = bytes / (1024 * 1024);
    return mb == mb.roundToDouble()
        ? '${mb.round()} MB'
        : '${mb.toStringAsFixed(1)} MB';
  }
}

class _FileNameRow extends StatelessWidget {
  const _FileNameRow({
    required this.baseName,
    required this.extension,
    required this.colors,
  });

  final String baseName;
  final String extension;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: baseName,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              height: AppFont.lineheightM / AppFont.sizeM,
              letterSpacing: 0.25,
              color: colors.textBrandPrimary1,
            ),
          ),
          if (extension.isNotEmpty)
            TextSpan(
              text: extension,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeM,
                height: AppFont.lineheightM / AppFont.sizeM,
                letterSpacing: 0.25,
                color: colors.textBrandPrimary1,
              ),
            ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// ── File illustration ─────────────────────────────────────────────────────────

class _FileTypeIllustration extends StatelessWidget {
  const _FileTypeIllustration({required this.fileName});

  final String fileName;

  String get _ext {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  DsIllustrationName get _illustration {
    switch (_ext) {
      case 'pdf':
        return DsIllustrationName.pdf;
      case 'doc':
      case 'docx':
      case 'txt':
      case 'rtf':
        return DsIllustrationName.docx;
      case 'xls':
      case 'xlsx':
      case 'csv':
        return DsIllustrationName.xlsx;
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'webp':
      case 'gif':
      case 'svg':
        return DsIllustrationName.pngJpgJpeg;
      case 'xml':
        return DsIllustrationName.xml;
      default:
        return DsIllustrationName.errorFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DsIllustration(
      name: _illustration,
      width: 32,
      height: 32,
    );
  }
}

// ── Expand toggle ─────────────────────────────────────────────────────────────

class _ExpandToggle extends StatelessWidget {
  const _ExpandToggle({
    required this.expanded,
    required this.colors,
    required this.onTap,
  });

  final bool expanded;
  final SemanticColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            expanded ? 'Thu gọn' : 'Xem thêm',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
              fontWeight: AppTypography.fontWeightSemibold,
              height: AppFont.lineheightS / AppFont.sizeS,
              letterSpacing: 0.03,
              color: colors.textBrandPrimary1,
            ),
          ),
          DsIcon(
            name: expanded ? DsIconName.alinearUp : DsIconName.alinearBottom,
            size: AppIconSize.m,
            color: colors.textBrandPrimary1,
          ),
        ],
      ),
    );
  }
}

// ── Input error ───────────────────────────────────────────────────────────────

class _InputErrorMessage extends StatelessWidget {
  const _InputErrorMessage({
    required this.message,
    required this.colors,
  });

  final String message;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DsIcon(
          name: DsIconName.aboldError,
          size: AppIconSize.s,
          color: colors.textError,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeM,
              height: AppFont.lineheightM / AppFont.sizeM,
              letterSpacing: 0.25,
              color: colors.textError,
            ),
          ),
        ),
      ],
    );
  }
}
