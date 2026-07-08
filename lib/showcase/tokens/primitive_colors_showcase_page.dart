import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../doc/showcase_doc_page.dart';
import 'token_showcase_widgets.dart';

class PrimitiveColorsShowcasePage extends StatelessWidget {
  const PrimitiveColorsShowcasePage({super.key});

  static List<ColorEntry> _scale(
    String prefix,
    List<Color> colors,
  ) {
    return List.generate(
      colors.length,
      (i) => (name: '$prefix${(i + 1) * 100}', color: colors[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseTokenDocPage(
      title: 'Primitive Colors',
      figmaName: 'Master Token',
      description:
          'Bảng màu primitive (master token) dùng làm nền cho semantic colors.',
      body: [
        ColorGroupSection(
          title: 'Blue',
          entries: _scale('blue', [
            PrimitiveColors.blue100,
            PrimitiveColors.blue200,
            PrimitiveColors.blue300,
            PrimitiveColors.blue400,
            PrimitiveColors.blue500,
            PrimitiveColors.blue600,
            PrimitiveColors.blue700,
            PrimitiveColors.blue800,
            PrimitiveColors.blue900,
            PrimitiveColors.blue1000,
          ]),
        ),
        ColorGroupSection(
          title: 'Dark Blue',
          entries: [
            (name: 'darkblue50', color: PrimitiveColors.darkblue50),
            (name: 'darkblue100', color: PrimitiveColors.darkblue100),
            (name: 'darkblue200', color: PrimitiveColors.darkblue200),
            (name: 'darkblue300', color: PrimitiveColors.darkblue300),
            (name: 'darkblue400', color: PrimitiveColors.darkblue400),
            (name: 'darkblue500', color: PrimitiveColors.darkblue500),
            (name: 'darkblue600', color: PrimitiveColors.darkblue600),
            (name: 'darkblue700', color: PrimitiveColors.darkblue700),
            (name: 'darkblue800', color: PrimitiveColors.darkblue800),
            (name: 'darkblue900', color: PrimitiveColors.darkblue900),
            (name: 'darkblue1000', color: PrimitiveColors.darkblue1000),
          ],
        ),
        ColorGroupSection(
          title: 'Light Blue',
          entries: _scale('lightblue', [
            PrimitiveColors.lightblue100,
            PrimitiveColors.lightblue200,
            PrimitiveColors.lightblue300,
            PrimitiveColors.lightblue400,
            PrimitiveColors.lightblue500,
            PrimitiveColors.lightblue600,
            PrimitiveColors.lightblue700,
            PrimitiveColors.lightblue800,
            PrimitiveColors.lightblue900,
            PrimitiveColors.lightblue1000,
          ]),
        ),
        ColorGroupSection(
          title: 'Purple',
          entries: _scale('purple', [
            PrimitiveColors.purple100,
            PrimitiveColors.purple200,
            PrimitiveColors.purple300,
            PrimitiveColors.purple400,
            PrimitiveColors.purple500,
            PrimitiveColors.purple600,
            PrimitiveColors.purple700,
            PrimitiveColors.purple800,
            PrimitiveColors.purple900,
            PrimitiveColors.purple1000,
          ]),
        ),
        ColorGroupSection(
          title: 'Turquoise',
          entries: _scale('turquoise', [
            PrimitiveColors.turquoise100,
            PrimitiveColors.turquoise200,
            PrimitiveColors.turquoise300,
            PrimitiveColors.turquoise400,
            PrimitiveColors.turquoise500,
            PrimitiveColors.turquoise600,
            PrimitiveColors.turquoise700,
            PrimitiveColors.turquoise800,
            PrimitiveColors.turquoise900,
            PrimitiveColors.turquoise1000,
          ]),
        ),
        ColorGroupSection(
          title: 'Green',
          entries: _scale('green', [
            PrimitiveColors.green100,
            PrimitiveColors.green200,
            PrimitiveColors.green300,
            PrimitiveColors.green400,
            PrimitiveColors.green500,
            PrimitiveColors.green600,
            PrimitiveColors.green700,
            PrimitiveColors.green800,
            PrimitiveColors.green900,
            PrimitiveColors.green1000,
          ]),
        ),
        ColorGroupSection(
          title: 'Red',
          entries: _scale('red', [
            PrimitiveColors.red100,
            PrimitiveColors.red200,
            PrimitiveColors.red300,
            PrimitiveColors.red400,
            PrimitiveColors.red500,
            PrimitiveColors.red600,
            PrimitiveColors.red700,
            PrimitiveColors.red800,
            PrimitiveColors.red900,
            PrimitiveColors.red1000,
          ]),
        ),
        ColorGroupSection(
          title: 'Orange',
          entries: _scale('orange', [
            PrimitiveColors.orange100,
            PrimitiveColors.orange200,
            PrimitiveColors.orange300,
            PrimitiveColors.orange400,
            PrimitiveColors.orange500,
            PrimitiveColors.orange600,
            PrimitiveColors.orange700,
            PrimitiveColors.orange800,
            PrimitiveColors.orange900,
            PrimitiveColors.orange1000,
          ]),
        ),
        ColorGroupSection(
          title: 'Grayscale',
          entries: [
            (name: 'grayscale200', color: PrimitiveColors.grayscale200),
            (name: 'grayscale300', color: PrimitiveColors.grayscale300),
            (name: 'grayscale400', color: PrimitiveColors.grayscale400),
            (name: 'grayscale500', color: PrimitiveColors.grayscale500),
            (name: 'grayscale600', color: PrimitiveColors.grayscale600),
            (name: 'grayscale700', color: PrimitiveColors.grayscale700),
            (name: 'grayscale800', color: PrimitiveColors.grayscale800),
            (name: 'grayscale900', color: PrimitiveColors.grayscale900),
          ],
        ),
        ColorGroupSection(
          title: 'Black & White',
          entries: [
            (name: 'black100pct', color: PrimitiveColors.black100pct),
            (name: 'black50pct', color: PrimitiveColors.black50pct),
            (name: 'white100pct', color: PrimitiveColors.white100pct),
            (name: 'white5pct', color: PrimitiveColors.white5pct),
            (name: 'white10pct', color: PrimitiveColors.white10pct),
            (name: 'white20pct', color: PrimitiveColors.white20pct),
            (name: 'white30pct', color: PrimitiveColors.white30pct),
            (name: 'white40pct', color: PrimitiveColors.white40pct),
            (name: 'white50pct', color: PrimitiveColors.white50pct),
            (name: 'white60pct', color: PrimitiveColors.white60pct),
          ],
        ),
      ],
    );
  }
}
