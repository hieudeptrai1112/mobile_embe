import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'status_showcase_page.dart';
import 'icon_showcase_page.dart';
import 'illustration_showcase_page.dart';
import 'checkbox_showcase_page.dart';
import 'radio_showcase_page.dart';
import 'toggle_showcase_page.dart';
import 'bottom_sheet_showcase_page.dart';
import 'button_ghost_showcase_page.dart';
import 'button_link_showcase_page.dart';
import 'button_pill_showcase_page.dart';
import 'button_group_showcase_page.dart';
import 'dropdown_showcase_page.dart';
import 'floating_button_showcase_page.dart';
import 'date_field_showcase_page.dart';
import 'date_picker_showcase_page.dart';
import 'search_showcase_page.dart';
import 'text_area_showcase_page.dart';
import 'text_field_showcase_page.dart';
import 'tokens/token_showcase_home_page.dart';
import 'showcase_theme.dart';

class ShowcaseHomePage extends StatelessWidget {
  const ShowcaseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System'),
        actions: const [ShowcaseThemeToggle()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppPadding.l),
        children: [
          _ShowcaseTile(
            title: 'Status',
            subtitle: 'ATagStatus & ATagState — dot & pill',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const StatusShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Icons',
            subtitle: 'A Icons — actions, navigation, status, social',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const IconShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Illustration',
            subtitle: 'A Illustration — empty, search, flags…',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const IllustrationShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Tokens',
            subtitle: 'Colors, typography, dimensions',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const TokenShowcaseHomePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Button Pill',
            subtitle: 'MButtonPill — primary & outline',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const ButtonPillShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Button Group',
            subtitle: 'TBottomButtonGroup — horizontal & vertical',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const ButtonGroupShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Button Link',
            subtitle: 'MButtonLink — underlined text link',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const ButtonLinkShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Button Ghost',
            subtitle: 'MButtonGhost — transparent',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const ButtonGhostShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Floating Button',
            subtitle: 'MButtonIcon & MButtonFloatAction',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const FloatingButtonShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Checkbox',
            subtitle: 'ACheckBoxNormal — checked, indeterminate',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const CheckboxShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Radio',
            subtitle: 'MRadioNormal — selected & disabled',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const RadioShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Toggle',
            subtitle: 'MToggleNormal — size M & L',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const ToggleShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Bottom Sheet',
            subtitle: 'TBottomsheetDropdown — list, radio, checkbox',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const BottomSheetShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Dropdown',
            subtitle: 'MDropdownNormal — single & multiple',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const DropdownShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'TextField',
            subtitle: 'MTextFieldPostLogin',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const TextFieldShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Search',
            subtitle: 'MSearchNormal',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const SearchShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Date Field',
            subtitle: 'Single & Range',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const DateFieldShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'Date Picker',
            subtitle: 'TDatePickerNormal — single, range, year, time',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const DatePickerShowcasePage(),
              ),
            ),
          ),
          _ShowcaseTile(
            title: 'TextArea',
            subtitle: 'MTextAreaNormal',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const TextAreaShowcasePage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShowcaseTile extends StatelessWidget {
  const _ShowcaseTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeM,
            fontWeight: AppTypography.fontWeightSemibold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeS,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
