import 'package:flutter/material.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../illustrations/ds_illustration.dart';
import '../../illustrations/ds_illustration_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../button/ds_button.dart';
import '../button/ds_button_link.dart';

enum DsModalType {
  warning,
  success,
  error,
  confirm,
  destructive,
  notification,
}

class DsModalAction {
  const DsModalAction({
    required this.label,
    this.onPressed,
    this.type = DsButtonType.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final DsButtonType type;
}

class DsModalConfig {
  const DsModalConfig({
    required this.type,
    required this.title,
    this.message,
    this.errorCode,
    this.linkLabel,
    this.onLinkPressed,
    this.actions = const [],
    this.showClose = true,
    this.pageCount,
    this.currentPage = 0,
    this.illustration,
  });

  final DsModalType type;
  final String title;
  final String? message;
  final String? errorCode;
  final String? linkLabel;
  final VoidCallback? onLinkPressed;
  final List<DsModalAction> actions;
  final bool showClose;
  final int? pageCount;
  final int currentPage;
  final Widget? illustration;
}

/// Modal from Figma `TModalNormal` (Design System V2 Mobile).
abstract final class DsModal {
  static Future<void> show({
    required BuildContext context,
    required DsModalConfig config,
    bool barrierDismissible = false,
  }) {
    final colors = _colors(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: colors.overlayPrimary,
      builder: (dialogContext) => _DsModalDialog(
        config: config,
        onClose: () => Navigator.pop(dialogContext),
      ),
    );
  }

  static SemanticColors _colors(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;
  }

  static DsIllustrationName illustrationForType(DsModalType type) {
    return switch (type) {
      DsModalType.warning => DsIllustrationName.warning,
      DsModalType.success => DsIllustrationName.success,
      DsModalType.error => DsIllustrationName.error,
      DsModalType.confirm => DsIllustrationName.confirm,
      DsModalType.destructive => DsIllustrationName.delete,
      DsModalType.notification => DsIllustrationName.notification,
    };
  }
}

class _DsModalDialog extends StatelessWidget {
  const _DsModalDialog({
    required this.config,
    required this.onClose,
  });

  final DsModalConfig config;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = DsModal._colors(context);
    final actions = _resolveActions(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppPadding.s),
      child: Container(
        width: AppWidth.xl,
        constraints: const BoxConstraints(
          minWidth: AppWidth.xl,
          maxWidth: AppWidth.xl,
        ),
        decoration: BoxDecoration(
          color: colors.backgroundPrimary,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppPadding.n2xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DsModalBody(config: config),
                  const SizedBox(height: AppSpacing.n4xl),
                  _DsModalActions(actions: actions),
                  if (config.pageCount != null && config.pageCount! > 1) ...[
                    const SizedBox(height: AppSpacing.n4xl),
                    _DsModalPageDots(
                      count: config.pageCount!,
                      currentIndex: config.currentPage,
                    ),
                  ],
                ],
              ),
            ),
            if (config.showClose)
              Positioned(
                top: AppPadding.l,
                right: AppPadding.l,
                child: GestureDetector(
                  onTap: onClose,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: AppIconSize.m,
                    height: AppIconSize.m,
                    child: Center(
                      child: DsIcon(
                        name: DsIconName.alinearCancel,
                        size: AppIconSize.m,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<DsModalAction> _resolveActions(BuildContext context) {
    if (config.actions.isNotEmpty) return config.actions;

    return [
      DsModalAction(
        label: 'Primary button',
        onPressed: () => Navigator.pop(context),
      ),
    ];
  }
}

class _DsModalBody extends StatelessWidget {
  const _DsModalBody({required this.config});

  final DsModalConfig config;

  @override
  Widget build(BuildContext context) {
    final colors = DsModal._colors(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        config.illustration ??
            DsIllustration(
              name: DsModal.illustrationForType(config.type),
              width: 150,
              height: 150,
            ),
        const SizedBox(height: AppSpacing.l),
        Column(
          children: [
            Text(
              config.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeXl,
                fontWeight: AppTypography.fontWeightRegular,
                height: AppFont.lineheightXl / AppFont.sizeXl,
                letterSpacing: 0.25,
                color: colors.textPrimary,
              ),
            ),
            if (config.message != null) ...[
              const SizedBox(height: AppSpacing.l),
              Text(
                config.message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: AppFont.sizeM,
                  fontWeight: AppTypography.fontWeightRegular,
                  height: AppFont.lineheightM / AppFont.sizeM,
                  letterSpacing: 0.25,
                  color: colors.textPrimary,
                ),
              ),
            ],
            if (config.errorCode != null) ...[
              const SizedBox(height: AppSpacing.l),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mã lỗi:',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: AppFont.sizeM,
                      fontWeight: AppTypography.fontWeightRegular,
                      height: AppFont.lineheightM / AppFont.sizeM,
                      letterSpacing: 0.25,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    config.errorCode!,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: AppFont.sizeM,
                      fontWeight: AppTypography.fontWeightSemibold,
                      height: AppFont.lineheightM / AppFont.sizeM,
                      letterSpacing: 0.25,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
            if (config.linkLabel != null) ...[
              const SizedBox(height: AppSpacing.l),
              DsButtonLink(
                label: config.linkLabel!,
                size: DsButtonSize.medium,
                onPressed: config.onLinkPressed,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _DsModalActions extends StatelessWidget {
  const _DsModalActions({required this.actions});

  final List<DsModalAction> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.m),
          DsButton(
            label: actions[i].label,
            type: actions[i].type,
            size: DsButtonSize.medium,
            expanded: true,
            onPressed: actions[i].onPressed,
          ),
        ],
      ],
    );
  }
}

class _DsModalPageDots extends StatelessWidget {
  const _DsModalPageDots({
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colors = DsModal._colors(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.s),
          Container(
            width: AppSpacing.s,
            height: AppSpacing.s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == currentIndex
                  ? colors.backgroundBrandPrimary1
                  : colors.textQuaternary,
            ),
          ),
        ],
      ],
    );
  }
}
