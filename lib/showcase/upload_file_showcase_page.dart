import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'doc/showcase_doc_page.dart';
import 'showcase_section.dart';

class UploadFileShowcasePage extends StatefulWidget {
  const UploadFileShowcasePage({super.key});

  @override
  State<UploadFileShowcasePage> createState() => _UploadFileShowcasePageState();
}

class _UploadFileShowcasePageState extends State<UploadFileShowcasePage> {
  static const _demoFileUrl =
      'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

  final List<DsUploadFileItem> _defaultFiles = [];
  final List<DsUploadFileItem> _files = [
    const DsUploadFileItem(
      id: '1',
      name: 'Tên tệp tin.jpg',
      sizeBytes: 2_097_152,
    ),
    const DsUploadFileItem(
      id: '2',
      name: 'Báo cáo tài chính.pdf',
      sizeBytes: 2_480_000,
    ),
    const DsUploadFileItem(
      id: '3',
      name: 'bang_luong.xlsx',
      sizeBytes: 512_000,
    ),
  ];

  int _idCounter = 10;

  void _appendFiles(List<DsUploadFileItem> picked, List<DsUploadFileItem> target) {
    setState(() => target.addAll(picked));
  }

  void _addFile(String name, int size, {DsUploadFileStatus status = DsUploadFileStatus.success, String? errorMessage}) {
    setState(() {
      _files.add(DsUploadFileItem(
        id: '${_idCounter++}',
        name: name,
        sizeBytes: size,
        status: status,
        errorMessage: errorMessage,
      ));
    });
  }

  void _addFiles(List<({String name, int sizeBytes})> entries) {
    setState(() {
      for (final entry in entries) {
        _files.add(DsUploadFileItem(
          id: '${_idCounter++}',
          name: entry.name,
          sizeBytes: entry.sizeBytes,
        ));
      }
    });
  }

  void _removeFile(String id) {
    setState(() => _files.removeWhere((f) => f.id == id));
  }

  void _removeDefaultFile(String id) {
    setState(() => _defaultFiles.removeWhere((f) => f.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseDocPage(
      title: 'Upload File',
      figmaName: 'O Upload File',
      description:
          'Component upload / xem file theo Figma. Mode upload: bấm icon upload để '
          'chọn file, danh sách trong khung input, "Xem thêm" / "Thu gọn". '
          'Mode view: read-only với title trong khung, download từng file.',
      sections: [
        ShowcaseSection(
          title: 'Default — chưa có file',
          description: 'Bấm icon upload để mở file picker.',
          wrap: false,
          children: [
            DsUploadFile(
              label: 'Title',
              required: true,
              placeholder: 'Input text',
              files: _defaultFiles,
              onFilesPicked: (picked) => _appendFiles(picked, _defaultFiles),
              onRemove: _removeDefaultFile,
            ),
          ],
        ),
        const ShowcaseSection(
          title: '1 file',
          wrap: false,
          children: [
            DsUploadFile(
              placeholder: 'Input text',
              files: [
                DsUploadFileItem(
                  id: 'f1',
                  name: 'Tên tệp tin.jpg',
                  sizeBytes: 2_097_152,
                ),
              ],
            ),
          ],
        ),
        const ShowcaseSection(
          title: '2 files',
          wrap: false,
          children: [
            DsUploadFile(
              placeholder: 'Input text',
              files: [
                DsUploadFileItem(
                  id: 'f2a',
                  name: 'Tên tệp tin.jpg',
                  sizeBytes: 2_097_152,
                ),
                DsUploadFileItem(
                  id: 'f2b',
                  name: 'hop_dong.pdf',
                  sizeBytes: 1_500_000,
                ),
              ],
            ),
          ],
        ),
        const ShowcaseSection(
          title: '> 2 files — Xem thêm / Thu gọn',
          wrap: false,
          children: [
            DsUploadFile(
              placeholder: 'Input text',
              files: [
                DsUploadFileItem(
                  id: 'f3a',
                  name: 'Tên tệp tin.jpg',
                  sizeBytes: 2_097_152,
                ),
                DsUploadFileItem(
                  id: 'f3b',
                  name: 'bao_cao.pdf',
                  sizeBytes: 2_480_000,
                ),
                DsUploadFileItem(
                  id: 'f3c',
                  name: 'bang_luong.xlsx',
                  sizeBytes: 512_000,
                ),
              ],
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Error / Input Upload',
          wrap: false,
          children: [
            DsUploadFile(
              label: 'Title',
              required: true,
              placeholder: 'Input text',
              errorText: 'Error message',
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Error / File',
          wrap: false,
          children: [
            DsUploadFile(
              placeholder: 'Input text',
              files: [
                DsUploadFileItem(
                  id: 'err',
                  name: 'Tên tệp tin.jpg',
                  sizeBytes: 2_097_152,
                  status: DsUploadFileStatus.error,
                  errorMessage: 'Error message',
                ),
              ],
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Disable',
          wrap: false,
          children: [
            DsUploadFile(
              placeholder: 'Input text',
              enabled: false,
              files: [
                DsUploadFileItem(
                  id: 'dis',
                  name: 'Tên tệp tin.jpg',
                  sizeBytes: 2_097_152,
                ),
              ],
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'Illustration theo loại file',
          description:
              'pdf · docx · xlsx · png_jpg_jpeg · xml · error_file (không xác định)',
          wrap: false,
          children: [
            DsUploadFile(
              placeholder: 'Input text',
              files: [
                DsUploadFileItem(
                  id: 'ill-pdf',
                  name: 'bao_cao.pdf',
                  sizeBytes: 2_480_000,
                ),
                DsUploadFileItem(
                  id: 'ill-docx',
                  name: 'hop_dong.docx',
                  sizeBytes: 1_200_000,
                ),
                DsUploadFileItem(
                  id: 'ill-xlsx',
                  name: 'bang_tinh.xlsx',
                  sizeBytes: 512_000,
                ),
                DsUploadFileItem(
                  id: 'ill-png',
                  name: 'anh_chup.png',
                  sizeBytes: 1_800_000,
                ),
                DsUploadFileItem(
                  id: 'ill-jpg',
                  name: 'logo.jpg',
                  sizeBytes: 900_000,
                ),
                DsUploadFileItem(
                  id: 'ill-jpeg',
                  name: 'photo.jpeg',
                  sizeBytes: 1_100_000,
                ),
                DsUploadFileItem(
                  id: 'ill-xml',
                  name: 'data.xml',
                  sizeBytes: 48_000,
                ),
                DsUploadFileItem(
                  id: 'ill-unknown',
                  name: 'tep_khong_xac_dinh.xyz',
                  sizeBytes: 32_000,
                ),
              ],
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'View File — Title only',
          wrap: false,
          children: [
            DsUploadFile(
              mode: DsUploadFileMode.view,
              label: 'Title',
              showEmptyMessage: false,
            ),
          ],
        ),
        const ShowcaseSection(
          title: 'View File — Empty',
          wrap: false,
          children: [
            DsUploadFile(
              mode: DsUploadFileMode.view,
              label: 'Title',
            ),
          ],
        ),
        ShowcaseSection(
          title: 'View File — 1 file',
          wrap: false,
          children: [
            DsUploadFile(
              mode: DsUploadFileMode.view,
              label: 'Title',
              files: [
                DsUploadFileItem(
                  id: 'vf1',
                  name: 'Tên tệp tin.jpg',
                  sizeBytes: 2_097_152,
                  url: _demoFileUrl,
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'View File — 2 files',
          wrap: false,
          children: [
            DsUploadFile(
              mode: DsUploadFileMode.view,
              label: 'Title',
              files: [
                DsUploadFileItem(
                  id: 'vf2a',
                  name: 'Tên tệp tin.jpg',
                  sizeBytes: 2_097_152,
                  url: _demoFileUrl,
                ),
                DsUploadFileItem(
                  id: 'vf2b',
                  name: 'Tên tệp tin.jpg',
                  sizeBytes: 2_097_152,
                  url: _demoFileUrl,
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'View File — > 2 files',
          wrap: false,
          children: [
            DsUploadFile(
              mode: DsUploadFileMode.view,
              label: 'Title',
              files: [
                DsUploadFileItem(
                  id: 'vf3a',
                  name: 'Tên tệp tin.jpg',
                  sizeBytes: 2_097_152,
                  url: _demoFileUrl,
                ),
                DsUploadFileItem(
                  id: 'vf3b',
                  name: 'Tên tệp tin.jpg',
                  sizeBytes: 2_097_152,
                  url: _demoFileUrl,
                ),
                DsUploadFileItem(
                  id: 'vf3c',
                  name: 'Tên tệp tin.jpg',
                  sizeBytes: 2_097_152,
                  url: _demoFileUrl,
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'View File — Status + Description',
          wrap: false,
          children: [
            DsUploadFile(
              mode: DsUploadFileMode.view,
              label: 'Title',
              required: true,
              statusLabel: 'Chờ ký',
              statusVariant: DsStatusVariant.warning,
              description: 'Description',
              files: [
                DsUploadFileItem(
                  id: 'vf4',
                  name: 'Tên tệp tin.jpg',
                  sizeBytes: 2_097_152,
                  url: _demoFileUrl,
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Interactive',
          description:
              'Bấm icon upload để chọn file thật, hoặc dùng nút demo bên dưới '
              'để xem illustration theo từng loại file.',
          wrap: false,
          children: [
            DsUploadFile(
              label: 'Tài liệu đính kèm',
              required: true,
              placeholder: 'Input text',
              files: _files,
              onFilesPicked: (picked) => _appendFiles(picked, _files),
              onRemove: _removeFile,
            ),
            const SizedBox(height: AppSpacing.s),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                _AddButton(
                  label: '+ PDF',
                  onTap: () => _addFile('bao_cao_$_idCounter.pdf', 2_480_000),
                ),
                _AddButton(
                  label: '+ DOCX',
                  onTap: () => _addFile('hop_dong_$_idCounter.docx', 1_200_000),
                ),
                _AddButton(
                  label: '+ XLSX',
                  onTap: () => _addFile('bang_tinh_$_idCounter.xlsx', 512_000),
                ),
                _AddButton(
                  label: '+ PNG',
                  onTap: () => _addFile('anh_chup_$_idCounter.png', 1_800_000),
                ),
                _AddButton(
                  label: '+ JPG/PNG/JPEG',
                  onTap: () {
                    final id = _idCounter;
                    _addFiles([
                      (name: 'logo_$id.jpg', sizeBytes: 900_000),
                      (name: 'anh_$id.png', sizeBytes: 1_800_000),
                      (name: 'photo_$id.jpeg', sizeBytes: 1_100_000),
                    ]);
                  },
                ),
                _AddButton(
                  label: '+ XML',
                  onTap: () => _addFile('data_$_idCounter.xml', 48_000),
                ),
                _AddButton(
                  label: '+ Unknown',
                  onTap: () =>
                      _addFile('tep_khong_xac_dinh_$_idCounter.xyz', 32_000),
                ),
                _AddButton(
                  label: '+ Error',
                  onTap: () => _addFile(
                    'file_loi_$_idCounter.pdf',
                    5_242_880,
                    status: DsUploadFileStatus.error,
                    errorMessage: 'Vượt quá giới hạn 5 MB.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? SemanticColors.dark
        : SemanticColors.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.m,
          vertical: AppPadding.s,
        ),
        decoration: BoxDecoration(
          color: colors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(color: colors.borderPrimary, width: AppStroke.s),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: AppFont.sizeS,
            fontWeight: AppTypography.fontWeightSemibold,
            color: colors.textBrandPrimary1,
          ),
        ),
      ),
    );
  }
}
