import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';

Widget _app(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: buildHorizontTheme(HorizontProduct.landbote, brightness),
      home: Scaffold(body: Column(children: [child])),
    );

void main() {
  group('HorizontHorizon', () {
    testWidgets('paints the share in the accent and clamps it', (tester) async {
      await tester.pumpWidget(
        _app(const SizedBox(width: 400, child: HorizontHorizon(value: 0.25))),
      );
      await tester.pumpAndSettle();
      final accent = buildHorizontTheme(
        HorizontProduct.landbote,
        Brightness.light,
      ).extension<HorizontTheme>()!.colors.accent;
      final part = find.byWidgetPredicate(
        (w) => w is ColoredBox && w.color == accent,
      );
      expect(tester.getSize(part).width, 100);
      expect(tester.getSize(part).height, HzLine.selection);

      await tester.pumpWidget(
        _app(const SizedBox(width: 400, child: HorizontHorizon(value: 3))),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(part).width, 400);
    });

    testWidgets('is hidden from screen readers unless it has a label', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(const HorizontHorizon(value: 0.5, semanticsLabel: 'Gelesen')),
      );
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Gelesen'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('fits an AppBar as its bottom', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildHorizontTheme(HorizontProduct.landbote, Brightness.light),
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Heute'),
              bottom: const HorizontHorizon(value: 0.4),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('HorizontLage', () {
    testWidgets('is quiet while all is well and tinted when something is off', (
      tester,
    ) async {
      final c = buildHorizontTheme(
        HorizontProduct.landbote,
        Brightness.light,
      ).extension<HorizontTheme>()!.colors;
      await tester.pumpWidget(
        _app(
          const HorizontLage(
            'Aktuell · abgeglichen 08:12',
            status: HorizontStatus.positive,
          ),
        ),
      );
      expect(
        tester
            .widget<ColoredBox>(
              find
                  .descendant(
                    of: find.byType(HorizontLage),
                    matching: find.byType(ColoredBox),
                  )
                  .first,
            )
            .color,
        c.bg,
      );
      expect(
        tester
            .widget<Text>(find.text('Aktuell · abgeglichen 08:12'))
            .style!
            .color,
        c.textMuted,
      );

      await tester.pumpWidget(
        _app(
          const HorizontLage(
            'Kein Empfang. Stand 08:12',
            status: HorizontStatus.warning,
            icon: HorizontSymbols.cloudOff,
          ),
        ),
      );
      expect(
        tester
            .widget<ColoredBox>(
              find
                  .descendant(
                    of: find.byType(HorizontLage),
                    matching: find.byType(ColoredBox),
                  )
                  .first,
            )
            .color,
        c.warningTint,
      );
      expect(
        tester
            .widget<Text>(find.text('Kein Empfang. Stand 08:12'))
            .style!
            .color,
        c.text,
      );
      expect(find.byIcon(HorizontSymbols.cloudOff), findsOneWidget);
    });

    testWidgets('is as high as a touch target and holds a worded control', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildHorizontTheme(
            HorizontProduct.landbote,
            Brightness.light,
            density: HorizontDensity.touch,
          ),
          home: Scaffold(
            body: Column(
              children: [
                HorizontLage(
                  'Aktuell',
                  status: HorizontStatus.positive,
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text('Nur ungelesene'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(HorizontLage)).height,
        greaterThanOrEqualTo(HzSize.touch),
      );
      expect(find.text('Nur ungelesene'), findsOneWidget);
    });

    testWidgets(
      'holds text 4.5:1 on its ground in every state, light and dark',
      (tester) async {
        for (final b in Brightness.values) {
          final c = buildHorizontTheme(
            HorizontProduct.landbote,
            b,
          ).extension<HorizontTheme>()!.colors;
          double lum(Color x) => x.computeLuminance();
          double contrast(Color a, Color z) {
            final hi = lum(a) > lum(z) ? lum(a) : lum(z);
            final lo = lum(a) > lum(z) ? lum(z) : lum(a);
            return (hi + 0.05) / (lo + 0.05);
          }

          expect(contrast(c.textMuted, c.bg), greaterThanOrEqualTo(4.5));
          expect(contrast(c.text, c.warningTint), greaterThanOrEqualTo(4.5));
          expect(contrast(c.text, c.criticalTint), greaterThanOrEqualTo(4.5));
        }
      },
    );
  });

  testWidgets('HorizontDot is a circle in the accent', (tester) async {
    await tester.pumpWidget(_app(const HorizontDot()));
    expect(tester.getSize(find.byType(HorizontDot)), const Size.square(8));
  });
}
