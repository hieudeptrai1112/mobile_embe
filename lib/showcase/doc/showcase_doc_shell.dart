import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../showcase_theme.dart';
import 'showcase_catalog.dart';

/// Breakpoint: below this width the sidebar collapses into a Drawer.
const double _kMobileBreakpoint = 600.0;

/// Arco-style documentation shell: left sidebar on wide screens,
/// hamburger Drawer on mobile.
class ShowcaseDocShell extends StatefulWidget {
  const ShowcaseDocShell({super.key});

  @override
  State<ShowcaseDocShell> createState() => _ShowcaseDocShellState();
}

class _ShowcaseDocShellState extends State<ShowcaseDocShell> {
  late String _selectedId = ShowcaseCatalog.defaultItem.id;
  final _expandedGroups = <String>{
    for (final group in ShowcaseCatalog.groups) group.title,
  };

  ShowcaseCatalogItem get _selected =>
      ShowcaseCatalog.findById(_selectedId) ?? ShowcaseCatalog.defaultItem;

  void _selectItem(String id) => setState(() => _selectedId = id);

  void _toggleGroup(String title) {
    setState(() {
      if (_expandedGroups.contains(title)) {
        _expandedGroups.remove(title);
      } else {
        _expandedGroups.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < _kMobileBreakpoint;

        if (isMobile) {
          return _MobileShell(
            colors: colors,
            selected: _selected,
            selectedId: _selectedId,
            expandedGroups: _expandedGroups,
            onSelect: _selectItem,
            onToggleGroup: _toggleGroup,
          );
        }

        return _DesktopShell(
          colors: colors,
          selected: _selected,
          selectedId: _selectedId,
          expandedGroups: _expandedGroups,
          onSelect: _selectItem,
          onToggleGroup: _toggleGroup,
        );
      },
    );
  }
}

// ── Mobile layout ────────────────────────────────────────────────────────────

class _MobileShell extends StatelessWidget {
  const _MobileShell({
    required this.colors,
    required this.selected,
    required this.selectedId,
    required this.expandedGroups,
    required this.onSelect,
    required this.onToggleGroup,
  });

  final SemanticColors colors;
  final ShowcaseCatalogItem selected;
  final String selectedId;
  final Set<String> expandedGroups;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onToggleGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: colors.backgroundPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colors.backgroundBrandPrimary1,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              alignment: Alignment.center,
              child: Text(
                'DS',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 9,
                  fontWeight: AppTypography.fontWeightSemibold,
                  color: colors.textBrandOnPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: Text(
                selected.title,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: AppFont.sizeM,
                  fontWeight: AppTypography.fontWeightSemibold,
                  color: colors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: colors.borderPrimary,
          ),
        ),
        actions: const [
          ShowcaseThemeToggle(),
          SizedBox(width: AppSpacing.s),
        ],
      ),
      drawer: Drawer(
        width: 280,
        backgroundColor: colors.backgroundPrimary,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.l),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colors.borderPrimary,
                      width: AppStroke.s,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: colors.backgroundBrandPrimary1,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'DS',
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: AppFont.sizeS,
                          fontWeight: AppTypography.fontWeightSemibold,
                          color: colors.textBrandOnPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: Text(
                        'Design System V2',
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: AppFont.sizeM,
                          fontWeight: AppTypography.fontWeightSemibold,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppPadding.s),
                  children: [
                    for (final group in ShowcaseCatalog.groups) ...[
                      _SidebarGroupHeader(
                        title: group.title,
                        expanded: expandedGroups.contains(group.title),
                        onTap: () => onToggleGroup(group.title),
                      ),
                      if (expandedGroups.contains(group.title))
                        for (final item in group.items)
                          _SidebarItem(
                            title: item.title,
                            selected: item.id == selectedId,
                            onTap: () {
                              onSelect(item.id);
                              Navigator.of(context).pop();
                            },
                          ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: KeyedSubtree(
        key: ValueKey(selectedId),
        child: selected.builder(context),
      ),
    );
  }
}

// ── Desktop / tablet layout ───────────────────────────────────────────────────

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.colors,
    required this.selected,
    required this.selectedId,
    required this.expandedGroups,
    required this.onSelect,
    required this.onToggleGroup,
  });

  final SemanticColors colors;
  final ShowcaseCatalogItem selected;
  final String selectedId;
  final Set<String> expandedGroups;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onToggleGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundSecondary,
      body: Row(
        children: [
          _Sidebar(
            selectedId: selectedId,
            expandedGroups: expandedGroups,
            onSelect: onSelect,
            onToggleGroup: onToggleGroup,
          ),
          Expanded(
            child: Column(
              children: [
                _DocHeader(title: selected.title),
                Expanded(
                  child: ColoredBox(
                    color: colors.backgroundPrimary,
                    child: KeyedSubtree(
                      key: ValueKey(selectedId),
                      child: selected.builder(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _DocHeader extends StatelessWidget {
  const _DocHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.n2xl),
      decoration: BoxDecoration(
        color: colors.backgroundPrimary,
        border: Border(
          bottom: BorderSide(color: colors.borderPrimary, width: AppStroke.s),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Components',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
              color: colors.textSecondary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child:
                Icon(Icons.chevron_right, size: 14, color: colors.textTertiary),
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: AppFont.sizeS,
              fontWeight: AppTypography.fontWeightSemibold,
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
          const ShowcaseThemeToggle(),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.selectedId,
    required this.expandedGroups,
    required this.onSelect,
    required this.onToggleGroup,
  });

  final String selectedId;
  final Set<String> expandedGroups;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onToggleGroup;

  static const _width = 260.0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return Container(
      width: _width,
      decoration: BoxDecoration(
        color: colors.backgroundPrimary,
        border: Border(
          right: BorderSide(color: colors.borderPrimary, width: AppStroke.s),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.l),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colors.borderPrimary,
                  width: AppStroke.s,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colors.backgroundBrandPrimary1,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'DS',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: AppFont.sizeS,
                      fontWeight: AppTypography.fontWeightSemibold,
                      color: colors.textBrandOnPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    'Design System V2',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: AppFont.sizeM,
                      fontWeight: AppTypography.fontWeightSemibold,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.s),
              children: [
                for (final group in ShowcaseCatalog.groups) ...[
                  _SidebarGroupHeader(
                    title: group.title,
                    expanded: expandedGroups.contains(group.title),
                    onTap: () => onToggleGroup(group.title),
                  ),
                  if (expandedGroups.contains(group.title))
                    for (final item in group.items)
                      _SidebarItem(
                        title: item.title,
                        selected: item.id == selectedId,
                        onTap: () => onSelect(item.id),
                      ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarGroupHeader extends StatelessWidget {
  const _SidebarGroupHeader({
    required this.title,
    required this.expanded,
    required this.onTap,
  });

  final String title;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppPadding.l,
          AppPadding.m,
          AppPadding.l,
          AppSpacing.xs,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: AppFont.sizeS,
                  fontWeight: AppTypography.fontWeightSemibold,
                  letterSpacing: 0.5,
                  color: colors.textTertiary,
                ),
              ),
            ),
            Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              size: 16,
              color: colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return Material(
      color: selected ? colors.backgroundBrandPrimary5 : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.l,
            AppPadding.s,
            AppPadding.l,
            AppPadding.s,
          ),
          decoration: BoxDecoration(
            border: selected
                ? Border(
                    left: BorderSide(
                      color: colors.backgroundBrandPrimary1,
                      width: 3,
                    ),
                  )
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: selected ? AppPadding.m - 3 : AppPadding.m),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: AppFont.sizeM,
                fontWeight: selected
                    ? AppTypography.fontWeightSemibold
                    : AppTypography.fontWeightRegular,
                color: selected
                    ? colors.backgroundBrandPrimary1
                    : colors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
