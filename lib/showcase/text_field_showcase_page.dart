import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class TextFieldShowcasePage extends StatefulWidget {
  const TextFieldShowcasePage({super.key});

  @override
  State<TextFieldShowcasePage> createState() => _TextFieldShowcasePageState();
}

class _TextFieldShowcasePageState extends State<TextFieldShowcasePage> {
  late final TextEditingController _typingController;
  late final TextEditingController _filledController;
  late final TextEditingController _errorTypingController;
  late final TextEditingController _errorFilledController;
  late final TextEditingController _extrasController;
  late final TextEditingController _moneyController;
  late final TextEditingController _moneyTypingController;
  late final TextEditingController _moneyFilledController;
  late final TextEditingController _passwordTypingController;
  late final TextEditingController _passwordFilledController;
  late final TextEditingController _emailTypingController;

  static const _demoChips = [
    DsEmailChipEntry(value: 'name@address'),
    DsEmailChipEntry(value: 'name@address'),
    DsEmailChipEntry(value: 'name@address'),
  ];

  static const _demoChipsWithInvalid = [
    DsEmailChipEntry(value: 'name@address'),
    DsEmailChipEntry(value: 'name@', isValid: false),
  ];

  @override
  void initState() {
    super.initState();
    _typingController = TextEditingController(text: 'Input text');
    _filledController = TextEditingController(text: 'Input text');
    _errorTypingController = TextEditingController(text: 'Input text');
    _errorFilledController = TextEditingController(text: 'Input text');
    _extrasController = TextEditingController(text: 'Input text');
    _moneyController = TextEditingController(text: '20,000,000');
    _moneyTypingController = TextEditingController(text: '20');
    _moneyFilledController = TextEditingController(text: '20,000,000');
    _passwordTypingController = TextEditingController(text: 'Demo');
    _passwordFilledController = TextEditingController(text: 'Demo123456@');
    _emailTypingController = TextEditingController(text: 'Input text');
  }

  @override
  void dispose() {
    _typingController.dispose();
    _filledController.dispose();
    _errorTypingController.dispose();
    _errorFilledController.dispose();
    _extrasController.dispose();
    _moneyController.dispose();
    _moneyTypingController.dispose();
    _moneyFilledController.dispose();
    _passwordTypingController.dispose();
    _passwordFilledController.dispose();
    _emailTypingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'TextField',
      figmaName: 'MTextFieldPostLogin',
      description:
          'Rebuild theo node 18352:22251 với đầy đủ state của post-login text field và Text Field-Email.',
      sections: [
        const ShowcaseSection(
          title: 'Default',
          description: 'State: Default',
          wrap: false,
          children: [
            DsTextField(
              label: 'Title',
              hintText: 'Input text',
              required: true,
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Focus',
          wrap: false,
          children: [
            DsTextField(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              autofocus: true,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Typing',
          wrap: false,
          children: [
            DsTextField(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              controller: _typingController,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Filled',
          wrap: false,
          children: [
            DsTextField(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              controller: _filledController,
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Error / Default',
          wrap: false,
          children: [
            DsTextField(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              errorText: 'Error message',
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Error / Typing',
          wrap: false,
          children: [
            DsTextField(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              controller: _errorTypingController,
              errorText: 'Error message',
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Error / Filled',
          wrap: false,
          children: [
            DsTextField(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              controller: _errorFilledController,
              errorText: 'Error message',
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Disable',
          wrap: false,
          children: [
            DsTextField(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              enabled: false,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'With extras',
          description: 'Info + prefix + suffix + trailing icon + helptext',
          wrap: false,
          children: [
            DsTextField(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              showInfo: true,
              prefix: 'VND',
              suffix: 'VND',
              trailingIcon: const Icon(Icons.add),
              helpText: 'This is helptext',
              controller: _extrasController,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Password',
          description: 'Node 3385:29338 (MTextFieldPreLogin) — underline style',
          wrap: false,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Default — hide
                const DsTextFieldPreLogin(
                  label: 'Title',
                  required: true,
                  obscureText: true,
                  showPasswordToggle: true,
                ),
                const SizedBox(height: AppSpacing.m),
                // Default — unhide
                const DsTextFieldPreLogin(
                  label: 'Title',
                  required: true,
                  obscureText: false,
                  showPasswordToggle: true,
                ),
                const SizedBox(height: AppSpacing.m),
                // Typing — hide
                DsTextFieldPreLogin(
                  label: 'Title',
                  required: true,
                  obscureText: true,
                  showPasswordToggle: true,
                  controller: _passwordTypingController,
                ),
                const SizedBox(height: AppSpacing.m),
                // Filled — hide
                DsTextFieldPreLogin(
                  label: 'Title',
                  required: true,
                  obscureText: true,
                  showPasswordToggle: true,
                  controller: _passwordFilledController,
                ),
                const SizedBox(height: AppSpacing.m),
                // Error / Default
                const DsTextFieldPreLogin(
                  label: 'Title',
                  required: true,
                  obscureText: true,
                  showPasswordToggle: true,
                  errorText: 'Error message',
                ),
                const SizedBox(height: AppSpacing.m),
                // Error / Filled
                DsTextFieldPreLogin(
                  label: 'Title',
                  required: true,
                  obscureText: true,
                  showPasswordToggle: true,
                  controller: _passwordFilledController,
                  errorText: 'Error message',
                ),
                const SizedBox(height: AppSpacing.m),
                // Disabled
                const DsTextFieldPreLogin(
                  label: 'Title',
                  required: true,
                  obscureText: true,
                  showPasswordToggle: true,
                  enabled: false,
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Money',
          description: 'TextFieldMoney',
          wrap: false,
          children: [
            DsTextField(
              money: true,
              label: 'Title',
              hintText: 'Nhập số tiền',
              required: true,
              controller: _moneyController,
              suffix: 'VND',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'TextFieldMoney',
          description: 'Node 17650:129891 - default/focus/typing/filled/error/disable',
          wrap: false,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DsTextField(
                  money: true,
                  label: 'Title',
                  hintText: 'Nhập số tiền',
                  required: true,
                  suffix: 'VND',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.m),
                const DsTextField(
                  money: true,
                  label: 'Title',
                  hintText: 'Nhập số tiền',
                  required: true,
                  suffix: 'VND',
                  keyboardType: TextInputType.number,
                  autofocus: true,
                ),
                const SizedBox(height: AppSpacing.m),
                DsTextField(
                  money: true,
                  label: 'Title',
                  hintText: 'Nhập số tiền',
                  required: true,
                  suffix: 'VND',
                  keyboardType: TextInputType.number,
                  controller: _moneyTypingController,
                ),
                const SizedBox(height: AppSpacing.m),
                DsTextField(
                  money: true,
                  label: 'Title',
                  hintText: 'Nhập số tiền',
                  required: true,
                  suffix: 'VND',
                  keyboardType: TextInputType.number,
                  controller: _moneyFilledController,
                ),
                const SizedBox(height: AppSpacing.m),
                const DsTextField(
                  money: true,
                  label: 'Title',
                  hintText: 'Nhập số tiền',
                  required: true,
                  suffix: 'VND',
                  keyboardType: TextInputType.number,
                  errorText: 'Error message',
                ),
                const SizedBox(height: AppSpacing.m),
                DsTextField(
                  money: true,
                  label: 'Title',
                  hintText: 'Nhập số tiền',
                  required: true,
                  suffix: 'VND',
                  keyboardType: TextInputType.number,
                  controller: _moneyTypingController,
                  errorText: 'Error message',
                ),
                const SizedBox(height: AppSpacing.m),
                DsTextField(
                  money: true,
                  label: 'Title',
                  hintText: 'Nhập số tiền',
                  required: true,
                  suffix: 'VND',
                  keyboardType: TextInputType.number,
                  controller: _moneyFilledController,
                  errorText: 'Error message',
                ),
                const SizedBox(height: AppSpacing.m),
                const DsTextField(
                  money: true,
                  label: 'Title',
                  hintText: 'Nhập số tiền',
                  required: true,
                  suffix: 'VND',
                  keyboardType: TextInputType.number,
                  enabled: false,
                ),
              ],
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Email / Default',
          description: 'Text Field-Email — state Default',
          wrap: false,
          children: [
            DsTextFieldEmail(
              label: 'Title',
              hintText: 'Input text',
              required: true,
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Email / Focus',
          wrap: false,
          children: [
            DsTextFieldEmail(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              autofocus: true,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Email / Typing',
          wrap: false,
          children: [
            DsTextFieldEmail(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              controller: _emailTypingController,
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Email / Filled',
          wrap: false,
          children: [
            DsTextFieldEmail(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              initialChips: [
                DsEmailChipEntry(value: 'name@address'),
              ],
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Email / Error / Default',
          wrap: false,
          children: [
            DsTextFieldEmail(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              errorText: 'Vui lòng nhập đầy đủ thông tin',
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Email / Error / Typing',
          wrap: false,
          children: [
            DsTextFieldEmail(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              controller: _emailTypingController,
              errorText: 'Error message',
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Email / Error / Filled',
          wrap: false,
          children: [
            DsTextFieldEmail(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              initialChips: [
                DsEmailChipEntry(value: 'name@address'),
              ],
              errorText: 'Error message',
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Email / Disable',
          wrap: false,
          children: [
            DsTextFieldEmail(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              enabled: false,
              initialChips: [
                DsEmailChipEntry(value: 'name@address'),
              ],
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Email / Chips',
          description: 'Multi-email chips (Figma Email building block)',
          wrap: false,
          children: [
            DsTextFieldEmail(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              initialChips: _demoChips,
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Email / Chip states',
          description: 'Valid vs invalid chip (Figma .master)',
          wrap: false,
          children: [
            DsTextFieldEmail(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              initialChips: _demoChipsWithInvalid,
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Email / With helptext',
          wrap: false,
          children: [
            DsTextFieldEmail(
              label: 'Title',
              hintText: 'Input text',
              required: true,
              showInfo: true,
              helpText: 'This is helptext',
            ),
          ],
        ),
      ],
    );
  }
}
