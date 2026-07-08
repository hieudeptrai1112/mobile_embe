import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class TextAreaShowcasePage extends StatefulWidget {
  const TextAreaShowcasePage({super.key});

  @override
  State<TextAreaShowcasePage> createState() => _TextAreaShowcasePageState();
}

class _TextAreaShowcasePageState extends State<TextAreaShowcasePage> {
  late final TextEditingController _filledController;
  late final TextEditingController _typingController;

  @override
  void initState() {
    super.initState();
    _filledController = TextEditingController(text: 'Input text');
    _typingController = TextEditingController(text: 'Input Text');
  }

  @override
  void dispose() {
    _filledController.dispose();
    _typingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'TextArea',
      figmaName: 'MTextAreaNormal',
      description:
          'Vùng nhập văn bản nhiều dòng với label, error và disabled.',
      sections: [
        const ShowcaseSection(
          title: 'Default',
          wrap: false,
          children: [
            DsTextArea(
              label: 'Title',
              hintText: 'Input text',
              required: true,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Filled',
          wrap: false,
          children: [
            DsTextArea(
              label: 'Title',
              hintText: 'Input text',
              controller: _filledController,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Typing',
          wrap: false,
          children: [
            DsTextArea(
              label: 'Title',
              hintText: 'Input text',
              controller: _typingController,
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Error (Default)',
          wrap: false,
          children: [
            DsTextArea(
              label: 'Title',
              hintText: 'Input text',
              errorText: 'Error message',
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Error (Filled)',
          wrap: false,
          children: [
            DsTextArea(
              label: 'Title',
              hintText: 'Input text',
              controller: _filledController,
              errorText: 'Error message',
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Disabled',
          wrap: false,
          children: [
            DsTextArea(
              label: 'Title',
              hintText: 'Input text',
              enabled: false,
            ),
          ],
        ),
      ],
    );
  }
}
