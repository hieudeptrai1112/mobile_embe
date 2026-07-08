import 'package:flutter/material.dart';

import '../../icons/ds_icon.dart';
import '../../icons/ds_icon_assets.dart';
import '../../tokens/dimension_tokens.dart';
import '../../tokens/semantic_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../badge/ds_badge.dart';
import '../button/ds_button.dart';

enum DsAnnouncementBarTopType {
  promotion,
  completed,
  warning,
  error,
  reminder,
  information,
}

enum DsAnnouncementBarTopStyle { primary, secondary }

/// Top announcement bar from Figma `M Announcement Bar/ Top`.
class DsAnnouncementBarTop extends StatelessWidget {
  const DsAnnouncementBarTop({
    super.key,
    required this.type,
    this.style = DsAnnouncementBarTopStyle.primary,
    this.title,
    this.description = 'Lorem ipsum dolor sit amet',
    this.learnMoreLabel = 'Tìm hiểu thêm',
    this.showTitle = true,
    this.showLearnMore = true,
    this.showClose = true,
    this.onLearnMore,
    this.onClose,
  });

  final DsAnnouncementBarTopType type;
  final DsAnnouncementBarTopStyle style;
  final String? title;
  final String description;
  final String learnMoreLabel;
  final bool showTitle;
  final bool showLearnMore;
  final bool showClose;
  final VoidCallback? onLearnMore;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final colors = _colors(context);
    final palette = _TopPalette.resolve(colors, type: type, style: style);
    final closeSize =
        type == DsAnnouncementBarTopType.promotion ? AppIconSize.xs : AppIconSize.s;
    final rowGap = type == DsAnnouncementBarTopType.promotion
        ? AppSpacing.s
        : AppSpacing.l;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          boxShadow: palette.shadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TopLeadingIcon(type: type, colors: colors),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: _AnnouncementTextBlock(
                            title: showTitle ? (title ?? 'Title') : null,
                            description: description,
                            descriptionMaxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showClose) ...[
                    SizedBox(width: rowGap),
                    _CloseButton(
                      size: closeSize,
                      onTap: onClose,
                      color: colors.textPrimary,
                    ),
                  ],
                ],
              ),
              if (showLearnMore) ...[
                const SizedBox(height: AppSpacing.s),
                _LearnMoreLink(
                  label: learnMoreLabel,
                  onTap: onLearnMore,
                  colors: colors,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Inline announcement from Figma `O Announcement Bar`.
///
/// Shows at most [maxCollapsedLines] when collapsed. If content exceeds that,
/// displays [learnMoreLabel] to expand.
class DsAnnouncementBarInline extends StatefulWidget {
  const DsAnnouncementBarInline({
    super.key,
    this.label,
    required this.message,
    this.learnMoreLabel = 'Tìm hiểu thêm',
    this.showLabel = true,
    this.maxCollapsedLines = 3,
    this.initiallyExpanded = false,
    this.onLearnMore,
  });

  final String? label;
  final String message;
  final String learnMoreLabel;
  final bool showLabel;
  final int maxCollapsedLines;
  final bool initiallyExpanded;
  final VoidCallback? onLearnMore;

  @override
  State<DsAnnouncementBarInline> createState() =>
      _DsAnnouncementBarInlineState();
}

class _DsAnnouncementBarInlineState extends State<DsAnnouncementBarInline> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  bool _exceedsCollapsedLines(double maxWidth) {
    if (_expanded) return false;
    final style = TextStyle(
      fontFamily: AppTypography.fontFamily,
      fontSize: AppFont.sizeS,
      fontWeight: AppTypography.fontWeightRegular,
      height: AppFont.lineheightS / AppFont.sizeS,
    );
    final painter = TextPainter(
      text: TextSpan(text: widget.message, style: style),
      maxLines: widget.maxCollapsedLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return painter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors(context);

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.backgroundWarningTertiary,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(
            color: colors.backgroundWarningSecondary,
            width: AppStroke.s,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.m),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DsIcon(
                name: DsIconName.aboldInfo,
                size: AppIconSize.m,
                color: colors.backgroundWarningPrimary,
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final showLearnMore =
                        _expanded || _exceedsCollapsedLines(constraints.maxWidth);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.showLabel) ...[
                          Text(
                            widget.label ?? 'Label 1',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: AppFont.sizeS,
                              fontWeight: AppTypography.fontWeightSemibold,
                              height: AppFont.lineheightS / AppFont.sizeS,
                              letterSpacing: 0.03,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ],
                        Text(
                          widget.message,
                          maxLines: _expanded ? null : widget.maxCollapsedLines,
                          overflow: _expanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: AppFont.sizeS,
                            fontWeight: AppTypography.fontWeightRegular,
                            height: AppFont.lineheightS / AppFont.sizeS,
                            color: colors.textPrimary,
                          ),
                        ),
                        if (showLearnMore) ...[
                          const SizedBox(height: AppSpacing.s),
                          _LearnMoreLink(
                            label: widget.learnMoreLabel,
                            onTap: () {
                              if (!_expanded) {
                                setState(() => _expanded = true);
                              }
                              widget.onLearnMore?.call();
                            },
                            colors: colors,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fixed announcement bar from Figma `M Announcement Bar/ Fix`.
class DsAnnouncementBarFixed extends StatelessWidget {
  const DsAnnouncementBarFixed({
    super.key,
    this.title = 'Title',
    this.amount,
    this.description = 'Description',
    this.primaryLabel = 'Text',
    this.secondaryLabel = 'Text',
    this.showTitle = true,
    this.showAmount = true,
    this.showDescription = true,
    this.showSecondary = true,
    this.showClose = true,
    this.onPrimary,
    this.onSecondary,
    this.onClose,
  });

  final String title;
  final String? amount;
  final String description;
  final String primaryLabel;
  final String secondaryLabel;
  final bool showTitle;
  final bool showAmount;
  final bool showDescription;
  final bool showSecondary;
  final bool showClose;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final colors = _colors(context);

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(
            color: colors.backgroundBrandPrimary4,
            width: AppStroke.s,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.m),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DsBadge.notification(status: DsBadgeNotificationStatus.remind),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showTitle)
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: AppFont.sizeM,
                                fontWeight: AppTypography.fontWeightSemibold,
                                height: AppFont.lineheightM / AppFont.sizeM,
                                letterSpacing: 0.5,
                                color: colors.textPrimary,
                              ),
                            ),
                          if (showTitle &&
                              (showAmount || showDescription))
                            const SizedBox(height: AppSpacing.xxs),
                          if (showAmount)
                            Text(
                              amount ?? '3,000,000,000 VND',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: AppFont.sizeM,
                                fontWeight: AppTypography.fontWeightSemibold,
                                height: AppFont.lineheightM / AppFont.sizeM,
                                letterSpacing: 0.25,
                                color: colors.textBrandPrimary1,
                              ),
                            ),
                          if (showAmount && showDescription)
                            const SizedBox(height: AppSpacing.xxs),
                          if (showDescription)
                            Text(
                              description,
                              style: TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: AppFont.sizeM,
                                fontWeight: AppTypography.fontWeightRegular,
                                height: AppFont.lineheightM / AppFont.sizeM,
                                letterSpacing: 0.25,
                                color: colors.textPrimary,
                              ),
                            ),
                          const SizedBox(height: AppSpacing.s),
                          Row(
                            children: [
                              DsButton(
                                label: primaryLabel,
                                size: DsButtonSize.small,
                                onPressed: onPrimary,
                              ),
                              if (showSecondary) ...[
                                const SizedBox(width: AppSpacing.s),
                                DsButton(
                                  label: secondaryLabel,
                                  type: DsButtonType.outline,
                                  size: DsButtonSize.small,
                                  onPressed: onSecondary,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (showClose) ...[
                const SizedBox(width: AppSpacing.l),
                _CloseButton(
                  size: AppIconSize.s,
                  onTap: onClose,
                  color: colors.textPrimary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TopLeadingIcon extends StatelessWidget {
  const _TopLeadingIcon({
    required this.type,
    required this.colors,
  });

  final DsAnnouncementBarTopType type;
  final SemanticColors colors;

  @override
  Widget build(BuildContext context) {
    if (type == DsAnnouncementBarTopType.information) {
      return DsIcon(
        name: DsIconName.aboldInfo,
        size: AppIconSize.m,
        color: colors.textBrandPrimary1,
      );
    }

    return DsBadge.notification(
      status: switch (type) {
        DsAnnouncementBarTopType.promotion => DsBadgeNotificationStatus.bee,
        DsAnnouncementBarTopType.completed => DsBadgeNotificationStatus.done,
        DsAnnouncementBarTopType.warning => DsBadgeNotificationStatus.warning,
        DsAnnouncementBarTopType.error => DsBadgeNotificationStatus.error,
        DsAnnouncementBarTopType.reminder => DsBadgeNotificationStatus.remind,
        DsAnnouncementBarTopType.information => DsBadgeNotificationStatus.remind,
      },
    );
  }
}

class _AnnouncementTextBlock extends StatelessWidget {
  const _AnnouncementTextBlock({
    this.title,
    required this.description,
    this.descriptionMaxLines,
  });

  final String? title;
  final String description;
  final int? descriptionMaxLines;

  @override
  Widget build(BuildContext context) {
    final colors = _colors(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
              fontWeight: AppTypography.fontWeightSemibold,
              height: AppFont.lineheightS / AppFont.sizeS,
              letterSpacing: 0.03,
              color: colors.textPrimary,
            ),
          ),
        if (title != null) const SizedBox(height: AppSpacing.xxs),
        Text(
          description,
          maxLines: descriptionMaxLines,
          overflow: descriptionMaxLines != null
              ? TextOverflow.ellipsis
              : TextOverflow.visible,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeS,
            fontWeight: AppTypography.fontWeightRegular,
            height: AppFont.lineheightS / AppFont.sizeS,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _LearnMoreLink extends StatelessWidget {
  const _LearnMoreLink({
    required this.label,
    required this.colors,
    this.onTap,
  });

  final String label;
  final SemanticColors colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Text(
          label,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeS,
            fontWeight: AppTypography.fontWeightRegular,
            height: AppFont.lineheightS / AppFont.sizeS,
            letterSpacing: 0.25,
            color: colors.hyperlinkPrimary,
            decoration: TextDecoration.underline,
            decorationColor: colors.hyperlinkPrimary,
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({
    required this.size,
    required this.color,
    this.onTap,
  });

  final double size;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: DsIcon(
        name: DsIconName.alinearCancel,
        size: size,
        color: color,
      ),
    );
  }
}

class _TopPalette {
  const _TopPalette({
    required this.background,
    this.shadow,
  });

  final Color background;
  final List<BoxShadow>? shadow;

  static _TopPalette resolve(
    SemanticColors colors, {
    required DsAnnouncementBarTopType type,
    required DsAnnouncementBarTopStyle style,
  }) {
    if (style == DsAnnouncementBarTopStyle.primary) {
      return _TopPalette(
        background: colors.backgroundPrimary,
        shadow: [
          BoxShadow(
            color: colors.backgroundGradient1Right.withValues(alpha: 0.35),
            offset: const Offset(0, 1),
            blurRadius: 5,
          ),
        ],
      );
    }

    final background = switch (type) {
      DsAnnouncementBarTopType.promotion ||
      DsAnnouncementBarTopType.information =>
        colors.backgroundSecondary,
      DsAnnouncementBarTopType.completed =>
        colors.backgroundSuccessQuaternary,
      DsAnnouncementBarTopType.warning => colors.backgroundWarningTertiary,
      DsAnnouncementBarTopType.error => colors.backgroundErrorTertiary,
      DsAnnouncementBarTopType.reminder => colors.backgroundBrandSecondary5,
    };

    return _TopPalette(background: background);
  }
}

SemanticColors _colors(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? SemanticColors.dark
      : SemanticColors.light;
}
