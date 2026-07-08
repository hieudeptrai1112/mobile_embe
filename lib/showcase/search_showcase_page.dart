import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class SearchShowcasePage extends StatefulWidget {
  const SearchShowcasePage({super.key});

  @override
  State<SearchShowcasePage> createState() => _SearchShowcasePageState();
}

class _SearchShowcasePageState extends State<SearchShowcasePage> {
  late final TextEditingController _typingController;
  late final TextEditingController _filledController;
  late final TextEditingController _errorTypingController;
  late final TextEditingController _errorFilledController;

  @override
  void initState() {
    super.initState();
    _typingController = TextEditingController(text: 'Input Text');
    _filledController = TextEditingController(text: 'Input Text');
    _errorTypingController = TextEditingController(text: 'Input Text');
    _errorFilledController = TextEditingController(text: 'Input Text');
  }

  @override
  void dispose() {
    _typingController.dispose();
    _filledController.dispose();
    _errorTypingController.dispose();
    _errorFilledController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Search',
      figmaName: 'MSearchNormal',
      description:
          'Ô tìm kiếm với các trạng thái default, typing, filled và error.',
      sections: [
        const ShowcaseSection(
          title: 'Default',
          wrap: false,
          children: [DsSearch()],
        ),
        ShowcaseSection(
          title: 'Typing',
          wrap: false,
          children: [DsSearch(controller: _typingController)],
        ),
        ShowcaseSection(
          title: 'Filled',
          wrap: false,
          children: [DsSearch(controller: _filledController)],
        ),
        ShowcaseSection(
          title: 'Error - Typing',
          wrap: false,
          children: [DsSearch(controller: _errorTypingController, error: true)],
        ),
        ShowcaseSection(
          title: 'Error - Filled',
          wrap: false,
          children: [DsSearch(controller: _errorFilledController, error: true)],
        ),
      ],
    );
  }
}
