import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';

Widget _app(Widget child) => MaterialApp(
  theme: buildHorizontTheme(HorizontProduct.jagdaufseher, Brightness.light),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('a badge reads its word, not its glyph', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(const HorizontBadge(HorizontStatus.critical, label: 'Defekt')),
    );
    expect(find.bySemanticsLabel('Defekt'), findsOneWidget);
    expect(find.byIcon(HorizontSymbols.report), findsOneWidget);
    handle.dispose();
  });

  testWidgets('a Kennung is written as given and read as written', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app(const Kennung('Revier Buchenhain')));
    expect(find.text('Revier Buchenhain'), findsOneWidget);
    expect(find.bySemanticsLabel('Revier Buchenhain'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('the tab bar reports the selection and taps', (tester) async {
    var tapped = -1;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light),
        home: Scaffold(
          bottomNavigationBar: HorizontTabBar(
            destinations: const [
              HorizontDestination(
                icon: HorizontSymbols.dashboard,
                label: 'Übersicht',
              ),
              HorizontDestination(
                icon: HorizontSymbols.category,
                label: 'Objekte',
              ),
              HorizontDestination(icon: HorizontSymbols.bolt, label: 'Live'),
            ],
            selectedIndex: 0,
            onSelected: (i) => tapped = i,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Live'));
    expect(tapped, 2);
    final size = tester.getSize(
      find.ancestor(of: find.text('Live'), matching: find.byType(InkWell)),
    );
    expect(size.height, greaterThanOrEqualTo(44));
  });

  testWidgets("the lockup puts the mark's horizon on the text baseline", (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const HorizontLockup(
          HorizontProduct.jagdaufseher,
          label: 'Jagdaufseher',
        ),
      ),
    );
    final mark = tester.renderObject<RenderBox>(find.byType(CustomPaint).last);
    final horizon = mark.localToGlobal(Offset(0, mark.size.height * 2 / 3)).dy;
    final text = tester.renderObject<RenderParagraph>(
      find.text('Jagdaufseher'),
    );
    final painter = TextPainter(
      text: text.text,
      textDirection: TextDirection.ltr,
    )..layout();
    final baseline =
        text.localToGlobal(Offset.zero).dy +
        painter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
    painter.dispose();
    expect(horizon, moreOrLessEquals(baseline, epsilon: 0.5));
  });

  testWidgets(
    'a field shows its label above the input and reads both together',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light),
          home: const Scaffold(
            body: HorizontField(
              label: 'Gateway',
              help: 'IP-Adresse',
              child: TextField(),
            ),
          ),
        ),
      );
      expect(
        tester.getBottomLeft(find.text('Gateway')).dy,
        lessThanOrEqualTo(tester.getTopLeft(find.byType(TextField)).dy),
      );
      expect(
        tester.getTopLeft(find.text('IP-Adresse')).dy,
        greaterThanOrEqualTo(tester.getBottomLeft(find.byType(TextField)).dy),
      );
    },
  );

  testWidgets('the tab bar is only as tall as its tabs', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light),
        home: Scaffold(
          bottomNavigationBar: HorizontTabBar(
            destinations: const [
              HorizontDestination(icon: HorizontSymbols.home, label: 'A'),
              HorizontDestination(icon: HorizontSymbols.map, label: 'B'),
            ],
            selectedIndex: 0,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(HorizontTabBar)).height, lessThan(120));
  });

  testWidgets('a one-line Kennung cuts the term, never the count', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        const SizedBox(
          width: 120,
          child: Kennung(
            'Helligkeit und Farbtemperatur',
            count: 14,
            oneLine: true,
          ),
        ),
      ),
    );
    expect(find.text(' · 14'), findsOneWidget);
    expect(tester.takeException(), isNull);
    final term = tester.widget<Text>(
      find.text('Helligkeit und Farbtemperatur'),
    );
    expect(term.maxLines, 1);
    expect(term.overflow, TextOverflow.ellipsis);
    expect(
      find.bySemanticsLabel('Helligkeit und Farbtemperatur · 14'),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('a section head carries the Kennung and quiet actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        HorizontSectionHeader(
          'Einrichtungen',
          count: 3,
          trailing: TextButton(onPressed: () {}, child: const Text('Alle')),
        ),
      ),
    );
    expect(find.text('Einrichtungen'), findsOneWidget);
    expect(find.text('Alle'), findsOneWidget);
  });

  testWidgets('a metric shows term, value and the state glyph', (tester) async {
    await tester.pumpWidget(
      _app(
        const HorizontMetricRow(
          children: [
            HorizontMetric(label: 'Telegramme', value: '1.204'),
            HorizontMetric(
              label: 'Fehler',
              value: '3',
              status: HorizontStatus.critical,
            ),
          ],
        ),
      ),
    );
    expect(find.text('Telegramme'), findsOneWidget);
    expect(find.text('1.204'), findsOneWidget);
    expect(find.byIcon(HorizontSymbols.report), findsOneWidget);
    final value = tester.widget<Text>(find.text('3'));
    final c = HorizontColors.resolve(
      HorizontProduct.jagdaufseher,
      Brightness.light,
    );
    expect(value.style?.color, c.critical);
  });

  testWidgets('a status line has glyph and words in the status colour', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const HorizontStatusLine(HorizontStatus.positive, 'Verbunden')),
    );
    final c = HorizontColors.resolve(
      HorizontProduct.jagdaufseher,
      Brightness.light,
    );
    expect(tester.widget<Icon>(find.byType(Icon)).color, c.positive);
    expect(
      tester.widget<Text>(find.text('Verbunden')).style?.color,
      c.positive,
    );
  });

  testWidgets('a letter badge is square, grows with the text, reads words', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: _app(
          const HorizontLetterBadge(
            'R',
            semanticLabel: 'Lesen',
            status: HorizontStatus.warning,
          ),
        ),
      ),
    );
    final size = tester.getSize(find.byType(HorizontLetterBadge));
    expect(size.width, size.height);
    expect(size.width, 48);
    expect(find.bySemanticsLabel('Lesen'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('an empty hint offers the one next action', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      _app(
        HorizontEmptyHint(
          icon: HorizontSymbols.search,
          text: 'Keine Aufnahmen',
          detail: 'Starte eine Aufnahme im Live-Monitor.',
          action: (label: 'Aufnehmen', onPressed: () => pressed = true),
        ),
      ),
    );
    await tester.tap(find.text('Aufnehmen'));
    expect(pressed, isTrue);
  });

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    testWidgets('a destructive dialog action on ${platform.name}', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildHorizontTheme(
            HorizontProduct.knx,
            Brightness.dark,
            platform: platform,
          ),
          home: Builder(
            builder: (context) => horizontDialogAction(
              context,
              label: 'Senden',
              primary: true,
              destructive: true,
              onPressed: () {},
            ),
          ),
        ),
      );
      if (platform == TargetPlatform.iOS) {
        final action = tester.widget<CupertinoDialogAction>(
          find.byType(CupertinoDialogAction),
        );
        expect(action.isDestructiveAction, isTrue);
        expect(action.isDefaultAction, isTrue);
      } else {
        final c = HorizontColors.resolve(HorizontProduct.knx, Brightness.dark);
        final button = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(button.style?.backgroundColor?.resolve({}), c.critical);
        expect(button.style?.foregroundColor?.resolve({}), c.onCritical);
      }
    });
  }
}
