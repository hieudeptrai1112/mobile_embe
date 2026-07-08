#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generate Dart asset registration code from physical asset files.

Supported:
  assets/icons/<group>/<name>.svg      → lib/design_system/icons/ds_icon_assets.dart
  assets/illustrations/**/*.png|svg   → lib/design_system/illustrations/ds_illustration_assets.dart
  assets/fonts/<Family>-<Weight>.ttf  → pubspec.yaml (fonts section)
  All asset dirs                       → pubspec.yaml (assets section)

Usage:
  python tool/generate_assets.py             # generate all
  python tool/generate_assets.py --dry-run   # preview without writing
  python tool/generate_assets.py --icons     # icons only
  python tool/generate_assets.py --illus     # illustrations only
  python tool/generate_assets.py --pubspec   # pubspec only
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

# ── Paths ──────────────────────────────────────────────────────────────────────
ROOT           = Path(__file__).resolve().parent.parent
ASSETS_DIR     = ROOT / "assets"
ICONS_DIR      = ASSETS_DIR / "icons"
ILLUS_DIR      = ASSETS_DIR / "illustrations"
FONTS_DIR      = ASSETS_DIR / "fonts"
ICONS_OUT      = ROOT / "lib" / "design_system" / "icons" / "ds_icon_assets.dart"
ILLUS_OUT      = ROOT / "lib" / "design_system" / "illustrations" / "ds_illustration_assets.dart"
PUBSPEC        = ROOT / "pubspec.yaml"

# ── Constants ──────────────────────────────────────────────────────────────────
IMAGE_EXTS = {".png", ".jpg", ".jpeg", ".svg", ".webp"}
ICON_EXTS  = {".svg", ".png", ".webp", ".jpg", ".jpeg"}
FONT_EXTS  = {".ttf", ".otf"}

# Singular prefix map for illustration subfolders: folder_name → dart prefix
SUBFOLDER_PREFIX: dict[str, str] = {
    "flags":  "flag",
    "labels": "label",
}

WEIGHT_MAP: list[tuple[int, list[str]]] = [
    (100, ["thin"]),
    (200, ["extralight", "ultralight"]),
    (300, ["light"]),
    (400, ["regular", "normal"]),
    (500, ["medium"]),
    (600, ["semibold", "demibold"]),
    (700, ["bold"]),
    (800, ["extrabold", "ultrabold", "heavy"]),
    (900, ["black"]),
]


# ── String helpers ─────────────────────────────────────────────────────────────
def to_camel(s: str) -> str:
    """snake_case / kebab-case → camelCase.  e.g. arrow_up → arrowUp"""
    parts = re.split(r"[_\-\s]+", s)
    result = parts[0].lower() + "".join(p.capitalize() for p in parts[1:])
    # Dart identifiers cannot start with a digit
    if result and result[0].isdigit():
        result = "n" + result
    return result


def to_title(s: str) -> str:
    """snake_case → Title Case.  e.g. arrow_up → Arrow Up"""
    return " ".join(w.capitalize() for w in re.split(r"[_\-\s]+", s))


def dart_name(stem: str, prefix: str = "") -> str:
    camel = to_camel(stem)
    if prefix:
        camel = prefix + camel[0].upper() + camel[1:]
    return camel


# ── Font helpers ───────────────────────────────────────────────────────────────
def _font_family(stem: str) -> str:
    """'Inter-SemiBold' → 'Inter',  'Roboto-BoldItalic' → 'Roboto'"""
    all_kw = [kw for _, kws in WEIGHT_MAP for kw in kws] + ["italic"]
    pattern = r"[-_](" + "|".join(all_kw) + r")(?:[-_]|$)"
    cleaned = re.sub(pattern, "", stem, flags=re.IGNORECASE)
    return cleaned.strip("-_ ")


def _font_weight(stem: str) -> int | None:
    """Return font weight integer, or None if 400 (default)."""
    lower = stem.lower()
    for weight, keywords in WEIGHT_MAP:
        for kw in keywords:
            if re.search(r"(^|[-_])" + kw + r"($|[-_])", lower):
                return None if weight == 400 else weight
    return None


def _font_italic(stem: str) -> bool:
    return bool(re.search(r"(^|[-_])italic($|[-_])", stem.lower()))


# ── Scanners ───────────────────────────────────────────────────────────────────
def scan_icons() -> dict[str, list[Path]]:
    """Returns {group: [sorted svg paths]} — skips empty groups."""
    groups: dict[str, list[Path]] = {}
    if not ICONS_DIR.exists():
        return groups
    for group_dir in sorted(ICONS_DIR.iterdir()):
        if not group_dir.is_dir():
            continue
        files = sorted(f for f in group_dir.iterdir() if f.suffix.lower() in ICON_EXTS)
        if files:
            groups[group_dir.name] = files
    return groups


def scan_illustrations() -> list[tuple[str, str, Path]]:
    """Returns list of (dart_name, label, path) for every illustration file."""
    results: list[tuple[str, str, Path]] = []
    if not ILLUS_DIR.exists():
        return results

    def add(stem: str, prefix: str, path: Path) -> None:
        name  = dart_name(stem, prefix)
        label = ((to_title(prefix) + " ") if prefix else "") + to_title(stem)
        results.append((name, label.strip(), path))

    for f in sorted(ILLUS_DIR.iterdir()):
        if f.is_file() and f.suffix.lower() in IMAGE_EXTS:
            add(f.stem, "", f)

    for sub in sorted(ILLUS_DIR.iterdir()):
        if not sub.is_dir():
            continue
        prefix = SUBFOLDER_PREFIX.get(sub.name, sub.name.rstrip("s"))
        for f in sorted(sub.iterdir()):
            if f.is_file() and f.suffix.lower() in IMAGE_EXTS:
                add(f.stem, prefix, f)

    return results


def scan_fonts() -> dict[str, list[dict]]:
    """Returns {family: [{asset, weight?, style?}]}."""
    families: dict[str, list[dict]] = {}
    if not FONTS_DIR.exists():
        return families
    for f in sorted(FONTS_DIR.iterdir()):
        if f.suffix.lower() not in FONT_EXTS:
            continue
        family = _font_family(f.stem)
        entry: dict = {"asset": f"assets/fonts/{f.name}"}
        weight = _font_weight(f.stem)
        if weight:
            entry["weight"] = weight
        if _font_italic(f.stem):
            entry["style"] = "italic"
        families.setdefault(family, []).append(entry)
    return families


# ── Dart code generators ───────────────────────────────────────────────────────
def gen_icon_dart(groups: dict[str, list[Path]]) -> str:
    lines: list[str] = []
    lines += [
        "/// Icon assets from Figma `A Icons` (Design System V2 Mobile).",
        "///",
        "/// Thêm icon mới:",
        "///   1. Đặt file .svg vào  assets/icons/<group>/<name>.svg",
        "///   2. Chạy: python tool/generate_assets.py",
        "abstract final class DsIconAssets {",
        "  static const _base = 'assets/icons';",
        "",
    ]

    all_entries: list[tuple[str, str]] = []  # (dart_name, label)

    for group, files in groups.items():
        ruler = "─" * max(1, 56 - len(group))
        lines.append(f"  // ── {to_title(group)} {ruler}")
        for f in files:
            name = to_camel(f.stem)
            lines.append(f"  static const {name} = '$_base/{group}/{f.name}';")
            all_entries.append((name, to_title(f.stem)))
        lines.append("")

    lines.append("}")
    lines.append("")

    # enum
    lines.append("enum DsIconName {")
    first = True
    for group, files in groups.items():
        if not first:
            lines.append("")
        lines.append(f"  // {to_title(group)}")
        for f in files:
            lines.append(f"  {to_camel(f.stem)},")
        first = False
    lines.append("}")
    lines.append("")

    # group order constant (for showcase ordering)
    lines.append("/// Ordered group names for showcase and tooling.")
    lines.append("const kDsIconGroupOrder = [")
    for group in groups:
        lines.append(f"  '{group}',")
    lines.append("];")
    lines.append("")

    # extension
    lines.append("extension DsIconNameX on DsIconName {")
    lines.append("  String get assetPath => switch (this) {")
    for name, _ in all_entries:
        lines.append(f"        DsIconName.{name} => DsIconAssets.{name},")
    lines.append("      };")
    lines.append("")
    lines.append("  String get label => switch (this) {")
    for name, label in all_entries:
        lines.append(f"        DsIconName.{name} => '{label}',")
    lines.append("      };")
    lines.append("")
    # group getter — extract folder from assetPath: 'assets/icons/<group>/<file>'
    lines.append("  /// Folder group this icon belongs to (e.g. 'actions', 'navigation').")
    lines.append("  String get group => assetPath.split('/')[2];")
    lines.append("}")
    lines.append("")

    return "\n".join(lines)


def gen_illustration_dart(items: list[tuple[str, str, Path]]) -> str:
    lines: list[str] = []
    lines += [
        "/// Illustration assets from Figma `A Illustration` (Design System V2 Mobile).",
        "///",
        "/// Thêm illustration mới:",
        "///   1. Đặt file vào  assets/illustrations/ (hoặc subfolder)",
        "///   2. Chạy: python tool/generate_assets.py",
        "abstract final class DsIllustrationAssets {",
        "  static const _base = 'assets/illustrations';",
        "",
    ]

    # Root-level items
    root_items = [(n, l, p) for n, l, p in items if p.parent == ILLUS_DIR]
    sub_buckets: dict[str, list[tuple[str, str, Path]]] = {}
    for n, l, p in items:
        if p.parent != ILLUS_DIR:
            sub_buckets.setdefault(p.parent.name, []).append((n, l, p))

    for name, _, path in root_items:
        rel = path.relative_to(ILLUS_DIR).as_posix()
        lines.append(f"  static const {name} = '$_base/{rel}';")

    for sub_name, sub_entries in sub_buckets.items():
        lines.append("")
        for name, _, path in sub_entries:
            rel = path.relative_to(ILLUS_DIR).as_posix()
            lines.append(f"  static const {name} = '$_base/{rel}';")

    all_names = [n for n, _, _ in items]
    lines += [
        "",
        "  static const all = [",
        *[f"    {n}," for n in all_names],
        "  ];",
        "}",
        "",
    ]

    # enum
    lines.append("enum DsIllustrationName {")
    for name, _, _ in items:
        lines.append(f"  {name},")
    lines.append("}")
    lines.append("")

    # extension
    lines.append("extension DsIllustrationNameX on DsIllustrationName {")
    lines.append("  String get assetPath => switch (this) {")
    for name, _, _ in items:
        lines.append(f"        DsIllustrationName.{name} => DsIllustrationAssets.{name},")
    lines.append("      };")
    lines.append("")
    lines.append("  String get label => switch (this) {")
    for name, label, _ in items:
        lines.append(f"        DsIllustrationName.{name} => '{label}',")
    lines.append("      };")
    lines.append("}")
    lines.append("")

    return "\n".join(lines)


# ── pubspec.yaml update ────────────────────────────────────────────────────────
def _collect_asset_dirs() -> list[str]:
    dirs: list[str] = []
    if ILLUS_DIR.exists():
        dirs.append("assets/illustrations/")
        for sub in sorted(ILLUS_DIR.iterdir()):
            if sub.is_dir() and any(f.is_file() for f in sub.iterdir()):
                dirs.append(f"assets/illustrations/{sub.name}/")
    if ICONS_DIR.exists():
        for grp in sorted(ICONS_DIR.iterdir()):
            if grp.is_dir() and any(f.is_file() for f in grp.iterdir()):
                dirs.append(f"assets/icons/{grp.name}/")
    return dirs


def _build_assets_block(dirs: list[str]) -> str:
    illus = [d for d in dirs if "illustrations" in d]
    icons = [d for d in dirs if "icons" in d]
    lines = ["  assets:"]
    if illus:
        lines.append("    # Illustrations")
        lines.extend(f"    - {d}" for d in illus)
    if icons:
        lines.append("    # Icons")
        lines.extend(f"    - {d}" for d in icons)
    return "\n".join(lines)


def _build_fonts_block(families: dict[str, list[dict]]) -> str:
    lines = ["  fonts:"]
    for family in sorted(families):
        entries = families[family]
        lines.append(f"    - family: {family}")
        lines.append(f"      fonts:")
        for e in entries:
            lines.append(f"        - asset: {e['asset']}")
            if "weight" in e:
                lines.append(f"          weight: {e['weight']}")
            if "style" in e:
                lines.append(f"          style: {e['style']}")
    return "\n".join(lines)


def update_pubspec(families: dict[str, list[dict]]) -> str:
    text = PUBSPEC.read_text(encoding="utf-8")

    # ── Replace assets: block ──────────────────────────────────────────────────
    dirs = _collect_asset_dirs()
    new_assets = _build_assets_block(dirs)
    # Match "  assets:\n" followed by lines starting with 4 spaces (items/comments)
    assets_re = re.compile(r"  assets:\n(?:    [^\n]*\n)*")
    if assets_re.search(text):
        text = assets_re.sub(new_assets + "\n", text, count=1)
    else:
        text = text.replace(
            "  uses-material-design: true\n",
            f"  uses-material-design: true\n\n{new_assets}\n",
        )

    # ── Replace fonts: block ───────────────────────────────────────────────────
    if families:
        new_fonts = _build_fonts_block(families)
        # Remove commented-out fonts block (if present)
        commented_re = re.compile(r"  # Fonts[^\n]*\n(?:  #[^\n]*\n)*")
        text = commented_re.sub("", text)
        # Remove active fonts block (if already there)
        active_re = re.compile(r"  fonts:\n(?:    [^\n]*\n)*")
        text = active_re.sub("", text)
        text = text.rstrip("\n") + "\n\n" + new_fonts + "\n"
    else:
        # No fonts — ensure commented placeholder is present
        has_placeholder = "  # fonts:" in text
        if not has_placeholder:
            # Append commented template if missing entirely
            placeholder = (
                "\n  # Fonts — bỏ comment và thêm file vào assets/fonts/ khi có font thật\n"
                "  # fonts:\n"
                "  #   - family: MyFont\n"
                "  #     fonts:\n"
                "  #       - asset: assets/fonts/MyFont-Regular.ttf\n"
                "  #       - asset: assets/fonts/MyFont-Bold.ttf\n"
                "  #         weight: 700\n"
            )
            text = text.rstrip("\n") + placeholder

    return text


# ── Main ───────────────────────────────────────────────────────────────────────
RESET  = "\033[0m"
GREEN  = "\033[32m"
YELLOW = "\033[33m"
CYAN   = "\033[36m"
BOLD   = "\033[1m"


def _print(msg: str, color: str = "") -> None:
    print(f"{color}{msg}{RESET}" if color else msg)


def main() -> None:
    args = set(sys.argv[1:])
    dry_run   = "--dry-run" in args or "-n" in args
    only_icons  = "--icons"   in args
    only_illus  = "--illus"   in args
    only_pub    = "--pubspec" in args
    run_all = not (only_icons or only_illus or only_pub)

    _print(f"\n{BOLD}generate_assets.py{RESET}", CYAN)
    if dry_run:
        _print("  DRY RUN — no files will be written\n", YELLOW)

    _print("Scanning assets…")
    icon_groups   = scan_icons()
    illus_items   = scan_illustrations()
    font_families = scan_fonts()

    total_icons = sum(len(v) for v in icon_groups.values())
    _print(f"  Icons        : {total_icons} files  |  groups: {list(icon_groups.keys())}")
    _print(f"  Illustrations: {len(illus_items)} files")
    _print(f"  Fonts        : {sum(len(v) for v in font_families.values())} files  |  families: {list(font_families.keys())}")
    print()

    changes: list[tuple[Path, str]] = []

    if (run_all or only_icons) and icon_groups:
        changes.append((ICONS_OUT, gen_icon_dart(icon_groups)))

    if (run_all or only_illus) and illus_items:
        changes.append((ILLUS_OUT, gen_illustration_dart(illus_items)))

    if run_all or only_pub:
        changes.append((PUBSPEC, update_pubspec(font_families)))

    if not changes:
        _print("Nothing to generate — no asset files found.", YELLOW)
        return

    if dry_run:
        _print("Files that would be written:", YELLOW)
        for path, _ in changes:
            _print(f"  • {path.relative_to(ROOT)}")
    else:
        for path, content in changes:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding="utf-8")
            _print(f"  ✓  {path.relative_to(ROOT)}", GREEN)

    print()
    _print(f"Done! {len(changes)} file(s) updated.", BOLD)
    if not dry_run and any(p == PUBSPEC for p, _ in changes):
        _print("  → Run `flutter pub get` to apply pubspec changes.", CYAN)


if __name__ == "__main__":
    main()
