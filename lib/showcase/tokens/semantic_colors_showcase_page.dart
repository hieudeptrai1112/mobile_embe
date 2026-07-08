import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../doc/showcase_doc_page.dart';
import 'semantic_color_catalog.dart';
import 'token_showcase_widgets.dart';

class SemanticColorsShowcasePage extends StatefulWidget {
  const SemanticColorsShowcasePage({super.key});

  @override
  State<SemanticColorsShowcasePage> createState() =>
      _SemanticColorsShowcasePageState();
}

class _SemanticColorsShowcasePageState extends State<SemanticColorsShowcasePage> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    final colors = _isDark ? SemanticColors.dark : SemanticColors.light;
    final groups = semanticColorGroups(colors);

    return ShowcaseTokenDocPage(
      title: 'Semantic Colors',
      figmaName: 'Alias Token',
      description:
          'Màu semantic (alias token) ánh xạ từ primitive, hỗ trợ light/dark mode.',
      header: SegmentedButton<bool>(
        segments: const [
          ButtonSegment(value: false, label: Text('Light')),
          ButtonSegment(value: true, label: Text('Dark')),
        ],
        selected: {_isDark},
        onSelectionChanged: (value) {
          setState(() => _isDark = value.first);
        },
      ),
      body: [
        for (final group in groups)
          ColorGroupSection(title: group.title, entries: group.entries),
      ],
    );
  }
}
