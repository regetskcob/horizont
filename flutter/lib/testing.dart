/// Test helpers of Horizont. Import only from tests:
///
/// ```dart
/// import 'package:horizont/testing.dart';
///
/// void main() {
///   setUpAll(loadHorizontFonts);
///   …
/// }
/// ```
library;

import 'package:flutter/services.dart';

import 'horizont.dart';

/// The bundled fonts by family, as declared in the package's pubspec.
const Map<String, List<String>> _fonts = {
  'Literata': [
    'Literata-Light.ttf',
    'Literata-LightItalic.ttf',
    'Literata-SemiBold.ttf',
  ],
  'MonaSans': [
    'MonaSans-Regular.ttf',
    'MonaSans-Medium.ttf',
    'MonaSans-SemiBold.ttf',
  ],
  'MonaSansDisplayExpanded': [
    'MonaSansDisplayExpanded-Bold.ttf',
    'MonaSansDisplayExpanded-Black.ttf',
  ],
  'MonaspaceArgon': [
    'MonaspaceArgon-Regular.otf',
    'MonaspaceArgon-SemiBold.otf',
  ],
  'MaterialSymbolsSharp': ['MaterialSymbolsSharp-300.ttf'],
};

/// Loads the fonts of Horizont into the test engine, so goldens show Mona
/// Sans, Literata, Monaspace and the symbols instead of the Ahem boxes.
/// Call it once in `setUpAll` of an app's golden tests.
Future<void> loadHorizontFonts() async {
  for (final MapEntry(key: family, value: files) in _fonts.entries) {
    final loader = FontLoader('packages/horizont/$family');
    for (final file in files) {
      loader.addFont(rootBundle.load('packages/horizont/fonts/$file'));
    }
    await loader.load();
  }
}

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

/// Where [product] breaks the guard rails of Horizont, one sentence each;
/// empty when it holds them all. Checked in both brightnesses and, where the
/// product has soft colours, in both styles:
///
/// - `accent-text` at least 4.5:1 on `bg`, `surface` and `sunken`
/// - `on-accent` at least 4.5:1 on `accent`
/// - `text` and `accent-text` at least 4.5:1 on `accent-tint`
/// - `accent` at least 3:1 on `bg` (the selection line)
/// - own neutrals: `text` and `text-muted` at least 4.5:1 and `line-strong`
///   at least 3:1 on every paper
List<String> productContrastProblems(HorizontProduct product) {
  final problems = <String>[];
  final styles = [
    HorizontStyle.standard,
    if (product.softLight != null || product.softDark != null) HorizontStyle.soft,
  ];
  for (final style in styles) {
    for (final brightness in Brightness.values) {
      final c = HorizontColors.resolve(product, brightness, style: style);
      final where = '${style.name} ${brightness.name}';
      void need(String name, Color a, Color b, double min) {
        final r = _contrast(a, b);
        if (r < min) problems.add('$where: $name is ${r.toStringAsFixed(2)}:1, needs $min:1');
      }

      final papers = {'bg': c.bg, 'surface': c.surface, 'sunken': c.sunken};
      papers.forEach((name, paper) {
        need('accent-text on $name', c.accentText, paper, 4.5);
        need('text on $name', c.text, paper, 4.5);
        need('text-muted on $name', c.textMuted, paper, 4.5);
        // The soft style draws its outlines in `line` on purpose.
        if (style == HorizontStyle.standard) need('line-strong on $name', c.lineStrong, paper, 3);
      });
      need('on-accent on accent', c.onAccent, c.accent, 4.5);
      need('text on accent-tint', c.text, c.accentTint, 4.5);
      need('accent-text on accent-tint', c.accentText, c.accentTint, 4.5);
      need('accent on bg', c.accent, c.bg, 3);
    }
  }
  return problems;
}

/// Fails when [product] breaks the guard rails of Horizont, naming every
/// pair that falls short (see [productContrastProblems]). Call it in a test
/// of the product's own repository:
///
/// ```dart
/// test('Landbote holds the contrast', () => expectProductHoldsContrast(landbote));
/// ```
void expectProductHoldsContrast(HorizontProduct product) {
  final problems = productContrastProblems(product);
  if (problems.isNotEmpty) {
    throw StateError('${product.displayName} breaks the guard rails of Horizont:\n  ${problems.join('\n  ')}');
  }
}
