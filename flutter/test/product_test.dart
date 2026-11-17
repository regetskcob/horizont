import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';
import 'package:horizont/testing.dart';

Path _post() => Path()
  ..moveTo(4, 66.7)
  ..lineTo(96, 66.7)
  ..moveTo(50, 66.7)
  ..lineTo(50, 30);

/// A product as its own repository defines it since 0.16.0.
const _own = HorizontProduct(
  id: 'feldpost',
  displayName: 'Feldpost',
  accentName: 'Altrhein',
  light: HzAccent(
    accent: Color(0xFF1E6B66),
    onAccent: Color(0xFFFFFFFF),
    accentTint: Color(0xFFDDEBE9),
    accentText: Color(0xFF1E6B66),
  ),
  dark: HzAccent(
    accent: Color(0xFF6FC7BC),
    onAccent: Color(0xFF0C1A19),
    accentTint: Color(0xFF17292A),
    accentText: Color(0xFF82D1C6),
  ),
  mark: HorizontGlyph(_post),
);

const _pale = HorizontProduct(
  id: 'blass',
  displayName: 'Blass',
  accentName: 'Nebel',
  light: HzAccent(
    accent: Color(0xFFD8D8D8),
    onAccent: Color(0xFFFFFFFF),
    accentTint: Color(0xFFEEEEEE),
    accentText: Color(0xFFBBBBBB),
  ),
  dark: HzAccent(
    accent: Color(0xFF6FC7BC),
    onAccent: Color(0xFF0C1A19),
    accentTint: Color(0xFF17292A),
    accentText: Color(0xFF82D1C6),
  ),
);

void main() {
  test('a product defined outside the package builds a theme', () {
    final theme = buildHorizontTheme(_own, Brightness.light);
    final h = theme.extension<HorizontTheme>()!;
    expect(h.product, _own);
    expect(h.colors.accent, const Color(0xFF1E6B66));
    expect(_own.name, 'feldpost');
  });

  test('the products Horizont still lists hold the guard rails', () {
    for (final product in HorizontProduct.values) {
      expect(
        productContrastProblems(product),
        isEmpty,
        reason: product.displayName,
      );
    }
    // Busclear runs embedded in Home Assistant, the pale accent would not.
    expect(
      productContrastProblems(HorizontProduct.knx, hosts: HorizontHost.values),
      isEmpty,
    );
    expect(
      productContrastProblems(
        _pale,
        hosts: HorizontHost.values,
      ).where((p) => p.startsWith('in Home Assistant light')),
      isNotEmpty,
    );
  });

  test('a pale accent is named pair by pair', () {
    final problems = productContrastProblems(_pale);
    expect(problems, isNotEmpty);
    expect(problems.every((p) => p.startsWith('standard light')), isTrue);
    expect(() => expectProductHoldsContrast(_pale), throwsStateError);
    expect(() => expectProductHoldsContrast(_own), returnsNormally);
  });

  testWidgets('the mark draws the glyph of the product, or the bare line', (
    tester,
  ) async {
    for (final product in [_own, _pale, ...HorizontProduct.values]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildHorizontTheme(product, Brightness.light),
          home: Center(child: HorizontMark(product, size: 48)),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.bySemanticsLabel(product.displayName), findsOneWidget);
    }
  });
}
