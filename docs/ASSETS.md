# Asset Management Guide

Tài liệu hướng dẫn quản lý assets (icons, illustrations, fonts) trong Design System.

---

## Tổng quan

Mọi asset đều được quản lý qua **một lệnh duy nhất**:

```bash
python3 tool/generate_assets.py
```

Script tự động:
1. Scan toàn bộ file trong `assets/`
2. Sinh lại code Dart (`DsIconAssets`, `DsIllustrationAssets`)
3. Cập nhật `pubspec.yaml` (asset paths + fonts section)

---

## Cấu trúc thư mục

```
assets/
├── icons/
│   ├── actions/        ← add, edit, delete, close, check, search, filter, sort…
│   ├── navigation/     ← home, back, forward, menu, arrow_*, chevron_*…
│   ├── status/         ← success, warning, error, info
│   └── social/         ← facebook, google, apple
│
├── illustrations/
│   ├── *.png           ← illustrations gốc (success, error, empty…)
│   ├── flags/          ← cờ quốc gia (au_australia.png, vnd.png…)
│   └── labels/         ← label badges (remind.png…)
│
└── fonts/
    └── <Family>-<Weight>.ttf   ← Inter-Regular.ttf, Inter-Bold.ttf…

lib/design_system/
├── icons/
│   ├── ds_icon_assets.dart       ← AUTO-GENERATED ⚡
│   └── ds_icon.dart              ← widget DsIcon (không sửa tay)
└── illustrations/
    ├── ds_illustration_assets.dart   ← AUTO-GENERATED ⚡
    └── ds_illustration.dart
```

> **⚠️ Không sửa tay** `ds_icon_assets.dart` và `ds_illustration_assets.dart`.  
> Chỉ thêm file asset rồi chạy lệnh gen — code sẽ tự được cập nhật.

---

## Hướng dẫn theo từng loại

### Icons (SVG)

#### Quy tắc đặt tên file

| File | Dart name | Ghi chú |
|------|-----------|---------|
| `actions/add.svg` | `DsIconName.add` | |
| `navigation/arrow_up.svg` | `DsIconName.arrowUp` | snake_case → camelCase |
| `actions/close_circle.svg` | `DsIconName.closeCircle` | |

Tên file phải là **snake_case**, phần mở rộng `.svg`.

#### Thêm icon mới

```
1. Đặt file .svg vào đúng subfolder:
   assets/icons/actions/       ← thao tác người dùng
   assets/icons/navigation/    ← điều hướng, mũi tên
   assets/icons/status/        ← trạng thái hệ thống
   assets/icons/social/        ← mạng xã hội / brand

2. Nếu cần nhóm mới, tạo thêm subfolder:
   assets/icons/finance/       ← ví dụ: nhóm tài chính

3. Chạy:
   python3 tool/generate_assets.py

4. Dùng trong code:
   DsIcon(name: DsIconName.add)
```

#### Dùng trong Widget

```dart
// Dùng qua enum (type-safe, recommended)
DsIcon(name: DsIconName.search)
DsIcon(name: DsIconName.arrowDown, size: 20)
DsIcon(name: DsIconName.close, size: 16, color: Colors.red)

// Màu tự động theo IconTheme (khi color không truyền vào)
IconTheme(
  data: IconThemeData(color: theme.colorScheme.primary),
  child: DsIcon(name: DsIconName.add),
)

// Dùng thẳng path (khi có icon ngoài Design System)
DsIcon.asset('assets/icons/actions/custom.svg', size: 24)
```

#### Yêu cầu file SVG

- Định dạng: SVG (không dùng PNG/JPG cho icon)
- ViewBox: `0 0 24 24` (24×24 px là chuẩn)
- Màu: dùng `currentColor` hoặc màu đơn — `DsIcon` áp `ColorFilter` lên toàn bộ icon
- Không embed ảnh raster trong SVG

---

### Illustrations (PNG / SVG)

#### Quy tắc đặt tên file

| File | Dart name |
|------|-----------|
| `illustrations/success.png` | `DsIllustrationName.success` |
| `illustrations/not_found_404.png` | `DsIllustrationName.notFound404` |
| `illustrations/flags/au_australia.png` | `DsIllustrationName.flagAuAustralia` |
| `illustrations/labels/remind.png` | `DsIllustrationName.labelRemind` |

Quy tắc prefix subfolder:
- `flags/` → prefix `flag`
- `labels/` → prefix `label`
- Subfolder khác `foo_bars/` → prefix `fooBar` (singular hóa tự động)

#### Thêm illustration mới

```
1. Đặt file vào đúng chỗ:
   assets/illustrations/         ← illustration độc lập
   assets/illustrations/flags/   ← cờ quốc gia
   assets/illustrations/labels/  ← badge labels

2. Chạy:
   python3 tool/generate_assets.py

3. Dùng:
   DsIllustration(name: DsIllustrationName.success)
```

#### Dùng trong Widget

```dart
// Qua enum
DsIllustration(name: DsIllustrationName.empty, width: 200, height: 200)
DsIllustration(name: DsIllustrationName.flagVnd, width: 32, height: 24)

// Qua path trực tiếp
DsIllustration.asset('assets/illustrations/custom.png', width: 120)
```

---

### Fonts

#### Quy tắc đặt tên file

```
<FamilyName>-<Weight>.ttf
<FamilyName>-<Weight>Italic.ttf
```

| File | Family | Weight | Style |
|------|--------|--------|-------|
| `Inter-Regular.ttf` | Inter | 400 (default) | |
| `Inter-Medium.ttf` | Inter | 500 | |
| `Inter-SemiBold.ttf` | Inter | 600 | |
| `Inter-Bold.ttf` | Inter | 700 | |
| `Inter-BoldItalic.ttf` | Inter | 700 | italic |
| `Roboto-Light.ttf` | Roboto | 300 | |

Weight keyword detection:

| Keyword trong tên file | Weight |
|------------------------|--------|
| Thin | 100 |
| ExtraLight / UltraLight | 200 |
| Light | 300 |
| Regular / Normal | 400 |
| Medium | 500 |
| SemiBold / DemiBold | 600 |
| Bold | 700 |
| ExtraBold / UltraBold / Heavy | 800 |
| Black | 900 |

#### Thêm font mới

```
1. Đặt file .ttf / .otf vào:
   assets/fonts/Inter-Regular.ttf
   assets/fonts/Inter-Bold.ttf
   ...

2. Chạy:
   python3 tool/generate_assets.py

   Script tự cập nhật pubspec.yaml:
   fonts:
     - family: Inter
       fonts:
         - asset: assets/fonts/Inter-Regular.ttf
         - asset: assets/fonts/Inter-Bold.ttf
           weight: 700

3. Chạy flutter pub get

4. Dùng:
   TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700)
```

---

## Lệnh generate_assets.py

### Options

```bash
# Generate tất cả (icons + illustrations + pubspec)
python3 tool/generate_assets.py

# Chỉ preview — không ghi file
python3 tool/generate_assets.py --dry-run
python3 tool/generate_assets.py -n

# Chỉ icons
python3 tool/generate_assets.py --icons

# Chỉ illustrations
python3 tool/generate_assets.py --illus

# Chỉ cập nhật pubspec.yaml
python3 tool/generate_assets.py --pubspec
```

### Output ví dụ

```
generate_assets.py
Scanning assets…
  Icons        : 32 files  |  groups: ['actions', 'navigation', 'social', 'status']
  Illustrations: 35 files
  Fonts        : 4 files   |  families: ['Inter']

  ✓  lib/design_system/icons/ds_icon_assets.dart
  ✓  lib/design_system/illustrations/ds_illustration_assets.dart
  ✓  pubspec.yaml

Done! 3 file(s) updated.
  → Run `flutter pub get` to apply pubspec changes.
```

---

## Workflow đầy đủ

```
Nhận file asset từ Designer
       ↓
Đặt file vào đúng folder (xem quy tắc trên)
       ↓
python3 tool/generate_assets.py
       ↓
flutter pub get          ← chỉ cần khi pubspec.yaml thay đổi
       ↓
Dùng DsIcon / DsIllustration trong code
```

---

## Lưu ý

- **Không xóa placeholder SVG** trong `assets/icons/*/` — hãy **thay thế** bằng file thật.  
  Nếu icon không dùng đến, xóa cả file `.svg` rồi chạy gen lại.
- File `ds_icon_assets.dart` và `ds_illustration_assets.dart` là **fully generated** — mọi thay đổi tay sẽ bị ghi đè khi chạy gen.
- Idempotent: chạy gen nhiều lần với cùng assets → output giống nhau.
- Script yêu cầu **Python 3.9+** (đã có sẵn trên macOS).
