#!/usr/bin/env python3
"""Generate Flutter design token Dart files from Figma Master Token JSON."""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
JSON_PATH = ROOT / "design_tokens" / "master_token.json"
OUT_DIR = ROOT / "lib" / "design_system" / "tokens"
THEME_DIR = ROOT / "lib" / "design_system" / "theme"


def to_dart_name(token_name: str) -> str:
    parts = token_name.replace("%", "pct").split("/")
    words: list[str] = []
    for part in parts:
        for sub in part.replace("_", "-").split("-"):
            cleaned = re.sub(r"[^a-zA-Z0-9]", "", sub)
            if cleaned:
                words.append(cleaned)
    if not words:
        return "token"
    name = words[0].lower()
    for word in words[1:]:
        if word[0].isdigit():
            name += word
        elif len(word) == 1:
            name += word.upper()
        else:
            name += word[0].upper() + word[1:].lower()
    if name[0].isdigit():
        name = f"n{name}"
    return name


def hex_to_dart(hex_color: str) -> str:
    h = hex_color.lstrip("#").upper()
    if len(h) == 8:
        return f"0x{h[6:8]}{h[0:2]}{h[2:4]}{h[4:6]}"
    return f"0xFF{h}"


def write_color_utils() -> None:
    content = """import 'dart:ui';

/// Converts Figma hex strings (#RRGGBB or #RRGGBBAA) to Flutter [Color].
Color colorFromHex(String hex) {
  final h = hex.replaceFirst('#', '').toUpperCase();
  if (h.length == 8) {
    return Color(int.parse('0x${h.substring(6)}${h.substring(0, 6)}'));
  }
  return Color(int.parse('0xFF$h'));
}
"""
    (OUT_DIR / "color_utils.dart").write_text(content)


def format_double(val: int | float) -> str:
    if isinstance(val, int):
        return f"{val}.0"
    return str(val)


def write_primitive_tokens(global_tokens: list[dict]) -> None:
    colors = [t for t in global_tokens if isinstance(t["value"], str) and t["value"].startswith("#")]
    floats = [t for t in global_tokens if isinstance(t["value"], (int, float))]
    strings = [t for t in global_tokens if isinstance(t["value"], str) and not t["value"].startswith("#")]

    lines = [
        "import 'dart:ui';",
        "",
        "/// Primitive (Global) tokens from Figma Master Token.",
        "abstract final class PrimitiveColors {",
    ]
    for token in colors:
        name = to_dart_name(token["name"])
        lines.append(
            f"  static const {name} = Color({hex_to_dart(token['value'])});"
        )
    lines.append("}")
    lines.append("")
    lines.append("abstract final class PrimitiveSpacing {")
    for token in floats:
        if token["name"].startswith("spacing/"):
            name = to_dart_name(token["name"].replace("spacing/", ""))
            lines.append(f"  static const {name} = {format_double(token['value'])};")
    lines.append("}")
    lines.append("")
    lines.append("abstract final class PrimitiveTypography {")
    for token in strings:
        name = to_dart_name(token["name"].replace("typography/", ""))
        lines.append(f"  static const {name} = '{token['value']}';")
    lines.append("}")
    lines.append("")
    (OUT_DIR / "primitive_tokens.dart").write_text("\n".join(lines))


def write_semantic_colors(light: list[dict], dark: list[dict]) -> None:
    light_map = {t["name"]: t["value"] for t in light}
    dark_map = {t["name"]: t["value"] for t in dark}
    names = sorted(set(light_map) | set(dark_map))

    field_lines = []
    light_lines = []
    dark_lines = []
    for name in names:
        dart_name = to_dart_name(name)
        field_lines.append(f"  final Color {dart_name};")
        light_lines.append(
            f"      {dart_name}: Color({hex_to_dart(light_map.get(name, dark_map[name]))}),"
        )
        dark_lines.append(
            f"      {dart_name}: Color({hex_to_dart(dark_map.get(name, light_map[name]))}),"
        )

    ctor_params = ",\n".join(f"    required this.{to_dart_name(n)}" for n in names)

    content = f"""import 'dart:ui';

/// Semantic (Alias) color tokens — Light & Dark modes.
class SemanticColors {{
{chr(10).join(field_lines)}

  const SemanticColors({{
{ctor_params}
  }});

  static const light = SemanticColors(
{chr(10).join(light_lines)}
  );

  static const dark = SemanticColors(
{chr(10).join(dark_lines)}
  );
}}
"""
    (OUT_DIR / "semantic_colors.dart").write_text(content)


def write_dimension_tokens(floats: list[dict]) -> None:
    groups: dict[str, list[dict]] = {}
    for token in floats:
        prefix = token["name"].split("/")[0]
        groups.setdefault(prefix, []).append(token)

    lines = [
        "/// Semantic dimension tokens from Figma Alias collection.",
    ]
    class_names = {
        "spacing": "AppSpacing",
        "radius": "AppRadius",
        "padding": "AppPadding",
        "font": "AppFont",
        "width": "AppWidth",
        "stroke": "AppStroke",
        "iconsize": "AppIconSize",
        "effect": "AppEffect",
    }
    for prefix, tokens in sorted(groups.items()):
        class_name = class_names.get(prefix, f"App{prefix.capitalize()}")
        lines.append(f"abstract final class {class_name} {{")
        for token in tokens:
            sub = "/".join(token["name"].split("/")[1:])
            name = to_dart_name(sub)
            val = token["value"]
            lines.append(f"  static const {name} = {format_double(val)};")
        lines.append("}")
        lines.append("")

    (OUT_DIR / "dimension_tokens.dart").write_text("\n".join(lines))


def write_typography_tokens(strings: list[dict], floats: list[dict]) -> None:
    font_floats = [t for t in floats if t["name"].startswith("font/")]
    lines = [
        "import 'package:flutter/material.dart';",
        "",
        "/// Typography tokens from Figma Master Token.",
        "abstract final class AppTypography {",
        "  static const fontFamily = 'Averta Std CY';",
    ]
    for token in strings:
        if "weight" in token["name"]:
            w = token["value"]
            dart_w = "FontWeight.w600" if w == "semibold" else "FontWeight.w400"
            key = "Semibold" if w == "semibold" else "Regular"
            lines.append(f"  static const fontWeight{key} = {dart_w};")
    for token in font_floats:
        if "size" in token["name"]:
            sub = token["name"].split("/")[-1]
            lines.append(f"  static const size{to_dart_name(sub).capitalize()} = {token['value']}.0;")
        elif "lineheight" in token["name"]:
            sub = token["name"].split("/")[-1]
            lines.append(f"  static const lineHeight{to_dart_name(sub).capitalize()} = {token['value']}.0;")
    lines.append("}")
    lines.append("")
    (OUT_DIR / "typography_tokens.dart").write_text("\n".join(lines))


def write_app_theme() -> None:
    content = """import 'package:flutter/material.dart';

import '../tokens/semantic_colors.dart';
import '../tokens/typography_tokens.dart';

/// Builds Material [ThemeData] from Master Token semantic colors.
ThemeData buildAppTheme({required SemanticColors colors, Brightness brightness = Brightness.light}) {
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: colors.backgroundBrandPrimary1,
      onPrimary: colors.textBrandOnPrimary,
      secondary: colors.backgroundBrandSecondary1,
      onSecondary: colors.textBrandOnSecondary,
      error: colors.backgroundErrorPrimary,
      onError: colors.textOnError,
      surface: colors.backgroundPrimary,
      onSurface: colors.textPrimary,
    ),
    scaffoldBackgroundColor: colors.backgroundPrimary,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.sizeL,
        height: AppTypography.lineHeightL / AppTypography.sizeL,
        color: colors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.sizeM,
        height: AppTypography.lineHeightM / AppTypography.sizeM,
        color: colors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.sizeXl,
        fontWeight: AppTypography.fontWeightSemibold,
        height: AppTypography.lineHeightXl / AppTypography.sizeXl,
        color: colors.textPrimary,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.backgroundPrimary,
      foregroundColor: colors.textPrimary,
      elevation: 0,
    ),
    dividerColor: colors.dividerPrimary,
  );
}
"""
    (THEME_DIR / "app_theme.dart").write_text(content)


def write_barrel() -> None:
    """Ensure token/theme exports exist without wiping component exports."""
    barrel = ROOT / "lib" / "design_system" / "design_system.dart"
    required = [
        "export 'tokens/color_utils.dart';",
        "export 'tokens/primitive_tokens.dart';",
        "export 'tokens/semantic_colors.dart';",
        "export 'tokens/dimension_tokens.dart';",
        "export 'tokens/typography_tokens.dart';",
        "export 'theme/app_theme.dart';",
    ]
    if barrel.exists():
        existing = barrel.read_text()
        missing = [line for line in required if line not in existing]
        if missing:
            # Insert missing token exports at the top, keep component exports.
            barrel.write_text("\n".join(missing) + "\n" + existing)
        return
    barrel.write_text("\n".join(required) + "\n")


def save_export(data: dict) -> None:
    JSON_PATH.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "source": "https://www.figma.com/design/VtfMVehVniPRQ9BTYzQzdD/Master-Token",
        "collections": ["Global", "Alias"],
        "global": data["global"],
        "floats": data["floats"],
        "strings": data["strings"],
        "lightColors": data["lightColors"],
        "darkColors": data["darkColors"],
    }
    JSON_PATH.write_text(json.dumps(payload, indent=2))


def main() -> None:
    if not JSON_PATH.exists():
        raise SystemExit(
            f"Missing {JSON_PATH}. Run: python3 tool/sync_figma_tokens.py"
        )
    data = json.loads(JSON_PATH.read_text())
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    THEME_DIR.mkdir(parents=True, exist_ok=True)

    write_color_utils()
    write_primitive_tokens(data["global"])
    write_semantic_colors(data["lightColors"], data["darkColors"])
    write_dimension_tokens(data["floats"])
    write_typography_tokens(data["strings"], data["floats"])
    write_app_theme()
    write_barrel()
    print(f"Generated tokens in {OUT_DIR}")


if __name__ == "__main__":
    main()
