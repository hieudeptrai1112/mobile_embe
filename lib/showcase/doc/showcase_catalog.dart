import 'package:flutter/material.dart';

import '../badge_showcase_page.dart';
import '../announcement_bar_showcase_page.dart';
import '../modal_showcase_page.dart';
import '../bottom_sheet_showcase_page.dart';
import '../button_ghost_showcase_page.dart';
import '../button_group_showcase_page.dart';
import '../button_link_showcase_page.dart';
import '../button_pill_showcase_page.dart';
import '../checkbox_showcase_page.dart';
import '../date_field_showcase_page.dart';
import '../date_picker_showcase_page.dart';
import '../dropdown_showcase_page.dart';
import '../floating_button_showcase_page.dart';
import '../icon_showcase_page.dart';
import '../illustration_showcase_page.dart';
import '../radio_showcase_page.dart';
import '../search_showcase_page.dart';
import '../status_showcase_page.dart';
import '../text_area_showcase_page.dart';
import '../text_field_showcase_page.dart';
import '../upload_file_showcase_page.dart';
import '../toggle_showcase_page.dart';
import '../tokens/dimension_showcase_page.dart';
import '../tokens/primitive_colors_showcase_page.dart';
import '../tokens/semantic_colors_showcase_page.dart';
import '../tokens/typography_showcase_page.dart';

class ShowcaseCatalogItem {
  const ShowcaseCatalogItem({
    required this.id,
    required this.title,
    required this.figmaName,
    required this.builder,
  });

  final String id;
  final String title;
  final String figmaName;
  final WidgetBuilder builder;
}

class ShowcaseCatalogGroup {
  const ShowcaseCatalogGroup({
    required this.title,
    required this.items,
  });

  final String title;
  final List<ShowcaseCatalogItem> items;
}

abstract final class ShowcaseCatalog {
  static const groups = <ShowcaseCatalogGroup>[
    ShowcaseCatalogGroup(
      title: 'General',
      items: [
        ShowcaseCatalogItem(
          id: 'status',
          title: 'Status',
          figmaName: 'ATagStatus / ATagState',
          builder: _buildStatus,
        ),
        ShowcaseCatalogItem(
          id: 'icons',
          title: 'Icons',
          figmaName: 'A Icons',
          builder: _buildIcons,
        ),
        ShowcaseCatalogItem(
          id: 'illustration',
          title: 'Illustration',
          figmaName: 'A Illustration',
          builder: _buildIllustration,
        ),
        ShowcaseCatalogItem(
          id: 'badge',
          title: 'Badge',
          figmaName: 'ABadgeNotification',
          builder: _buildBadge,
        ),
        ShowcaseCatalogItem(
          id: 'announcement-bar',
          title: 'Announcement Bar',
          figmaName: 'M Announcement Bar/ Top',
          builder: _buildAnnouncementBar,
        ),
      ],
    ),
    ShowcaseCatalogGroup(
      title: 'Tokens',
      items: [
        ShowcaseCatalogItem(
          id: 'tokens-primitive',
          title: 'Primitive Colors',
          figmaName: 'Master Token',
          builder: _buildPrimitiveColors,
        ),
        ShowcaseCatalogItem(
          id: 'tokens-semantic',
          title: 'Semantic Colors',
          figmaName: 'Alias Token',
          builder: _buildSemanticColors,
        ),
        ShowcaseCatalogItem(
          id: 'tokens-typography',
          title: 'Typography',
          figmaName: 'Typography Token',
          builder: _buildTypography,
        ),
        ShowcaseCatalogItem(
          id: 'tokens-dimension',
          title: 'Dimensions',
          figmaName: 'Dimension Token',
          builder: _buildDimension,
        ),
      ],
    ),
    ShowcaseCatalogGroup(
      title: 'Button',
      items: [
        ShowcaseCatalogItem(
          id: 'button-pill',
          title: 'Button Pill',
          figmaName: 'MButtonPill',
          builder: _buildButtonPill,
        ),
        ShowcaseCatalogItem(
          id: 'button-group',
          title: 'Button Group',
          figmaName: 'TBottomButtonGroup',
          builder: _buildButtonGroup,
        ),
        ShowcaseCatalogItem(
          id: 'button-link',
          title: 'Button Link',
          figmaName: 'MButtonLink',
          builder: _buildButtonLink,
        ),
        ShowcaseCatalogItem(
          id: 'button-ghost',
          title: 'Button Ghost',
          figmaName: 'MButtonGhost',
          builder: _buildButtonGhost,
        ),
        ShowcaseCatalogItem(
          id: 'floating-button',
          title: 'Floating Button',
          figmaName: 'MButtonIcon / MButtonFloatAction',
          builder: _buildFloatingButton,
        ),
      ],
    ),
    ShowcaseCatalogGroup(
      title: 'Input',
      items: [
        ShowcaseCatalogItem(
          id: 'checkbox',
          title: 'Checkbox',
          figmaName: 'ACheckBoxNormal',
          builder: _buildCheckbox,
        ),
        ShowcaseCatalogItem(
          id: 'radio',
          title: 'Radio',
          figmaName: 'MRadioNormal',
          builder: _buildRadio,
        ),
        ShowcaseCatalogItem(
          id: 'toggle',
          title: 'Toggle',
          figmaName: 'MToggleNormal',
          builder: _buildToggle,
        ),
        ShowcaseCatalogItem(
          id: 'dropdown',
          title: 'Dropdown',
          figmaName: 'MDropdownNormal',
          builder: _buildDropdown,
        ),
        ShowcaseCatalogItem(
          id: 'text-field',
          title: 'TextField',
          figmaName: 'MTextFieldPostLogin',
          builder: _buildTextField,
        ),
        ShowcaseCatalogItem(
          id: 'search',
          title: 'Search',
          figmaName: 'MSearchNormal',
          builder: _buildSearch,
        ),
        ShowcaseCatalogItem(
          id: 'date-field',
          title: 'Date Field',
          figmaName: 'ODateFieldNormal',
          builder: _buildDateField,
        ),
        ShowcaseCatalogItem(
          id: 'text-area',
          title: 'TextArea',
          figmaName: 'MTextAreaNormal',
          builder: _buildTextArea,
        ),
        ShowcaseCatalogItem(
          id: 'upload-file',
          title: 'Upload File',
          figmaName: 'O Upload File/ Creat New File',
          builder: _buildUploadFile,
        ),
      ],
    ),
    ShowcaseCatalogGroup(
      title: 'Overlay',
      items: [
        ShowcaseCatalogItem(
          id: 'bottom-sheet',
          title: 'Bottom Sheet',
          figmaName: 'TBottomsheetDropdown',
          builder: _buildBottomSheet,
        ),
        ShowcaseCatalogItem(
          id: 'date-picker',
          title: 'Date Picker',
          figmaName: 'TDatePickerNormal',
          builder: _buildDatePicker,
        ),
        ShowcaseCatalogItem(
          id: 'modal',
          title: 'Modal',
          figmaName: 'TModalNormal',
          builder: _buildModal,
        ),
      ],
    ),
  ];

  static ShowcaseCatalogItem? findById(String id) {
    for (final group in groups) {
      for (final item in group.items) {
        if (item.id == id) return item;
      }
    }
    return null;
  }

  static ShowcaseCatalogItem get defaultItem => groups.first.items.first;

  static Widget _buildStatus(BuildContext _) => const StatusShowcasePage();
  static Widget _buildIcons(BuildContext _) => const IconShowcasePage();
  static Widget _buildIllustration(BuildContext _) =>
      const IllustrationShowcasePage();
  static Widget _buildBadge(BuildContext _) => const BadgeShowcasePage();
  static Widget _buildAnnouncementBar(BuildContext _) =>
      const AnnouncementBarShowcasePage();
  static Widget _buildPrimitiveColors(BuildContext _) =>
      const PrimitiveColorsShowcasePage();
  static Widget _buildSemanticColors(BuildContext _) =>
      const SemanticColorsShowcasePage();
  static Widget _buildTypography(BuildContext _) =>
      const TypographyShowcasePage();
  static Widget _buildDimension(BuildContext _) =>
      const DimensionShowcasePage();
  static Widget _buildButtonPill(BuildContext _) =>
      const ButtonPillShowcasePage();
  static Widget _buildButtonGroup(BuildContext _) =>
      const ButtonGroupShowcasePage();
  static Widget _buildButtonLink(BuildContext _) =>
      const ButtonLinkShowcasePage();
  static Widget _buildButtonGhost(BuildContext _) =>
      const ButtonGhostShowcasePage();
  static Widget _buildFloatingButton(BuildContext _) =>
      const FloatingButtonShowcasePage();
  static Widget _buildCheckbox(BuildContext _) => const CheckboxShowcasePage();
  static Widget _buildRadio(BuildContext _) => const RadioShowcasePage();
  static Widget _buildToggle(BuildContext _) => const ToggleShowcasePage();
  static Widget _buildDropdown(BuildContext _) => const DropdownShowcasePage();
  static Widget _buildTextField(BuildContext _) => const TextFieldShowcasePage();
  static Widget _buildSearch(BuildContext _) => const SearchShowcasePage();
  static Widget _buildDateField(BuildContext _) => const DateFieldShowcasePage();
  static Widget _buildTextArea(BuildContext _) => const TextAreaShowcasePage();
  static Widget _buildUploadFile(BuildContext _) =>
      const UploadFileShowcasePage();
  static Widget _buildBottomSheet(BuildContext _) =>
      const BottomSheetShowcasePage();
  static Widget _buildDatePicker(BuildContext _) =>
      const DatePickerShowcasePage();
  static Widget _buildModal(BuildContext _) => const ModalShowcasePage();
}
