import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';

Widget _app(
  Widget child, {
  HorizontDensity? density,
  TargetPlatform? platform,
  HorizontProduct product = HorizontProduct.kalkarKompakt,
}) => MaterialApp(
  theme: buildHorizontTheme(product, Brightness.light, density: density, platform: platform),
  home: Scaffold(body: child),
);

double _baseline(WidgetTester tester, String text) {
  final paragraph = tester.renderObject<RenderParagraph>(
    find.descendant(of: find.text(text), matching: find.byType(RichText)),
  );
  final painter = TextPainter(text: paragraph.text, textDirection: TextDirection.ltr)..layout();
  final y = paragraph.localToGlobal(Offset.zero).dy + painter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
  painter.dispose();
  return y;
}

void main() {
  group('fact', () {
    testWidgets('term and value stand on one baseline, the term column is fixed', (tester) async {
      await tester.pumpWidget(
        _app(
          const Column(
            children: [
              HorizontFact(term: 'Adresse', value: '1.1.12', measured: true),
              HorizontFact(term: 'Ortsteil mit langem Namen', value: 'Grieth'),
            ],
          ),
        ),
      );
      final a = tester.getTopLeft(find.text('1.1.12'));
      final b = tester.getTopLeft(find.text('Grieth'));
      expect(a.dx, b.dx, reason: 'values under each other start in one place');
      expect(a.dx, HzSize.factTerm);
      expect(_baseline(tester, 'ADRESSE'), closeTo(_baseline(tester, '1.1.12'), 0.5));
    });

    testWidgets('a measured value is mono, a named one is not', (tester) async {
      await tester.pumpWidget(
        _app(
          const Column(
            children: [
              HorizontFact(term: 'Zeit', value: '12:04', measured: true),
              HorizontFact(term: 'Name', value: 'Rathaus'),
            ],
          ),
        ),
      );
      expect(tester.widget<Text>(find.text('12:04')).style!.fontFamily, contains(HzFont.mono));
      expect(tester.widget<Text>(find.text('Rathaus')).style!.fontFamily, contains(HzFont.sans));
    });

    testWidgets('in a narrow column the value goes under the term', (tester) async {
      await tester.pumpWidget(
        _app(const SizedBox(width: 200, child: HorizontFact(term: 'Adresse', value: 'Markt 20'))),
      );
      expect(
        tester.getTopLeft(find.text('Markt 20')).dy,
        greaterThan(tester.getBottomLeft(find.text('ADRESSE')).dy - 0.5),
      );
    });

    testWidgets('a link carries an arrow and is read as a link', (tester) async {
      final handle = tester.ensureSemantics();
      var tapped = false;
      await tester.pumpWidget(
        _app(HorizontFact(term: 'Web', value: 'kalkar.de', external: true, onTap: () => tapped = true)),
      );
      expect(find.byIcon(HorizontSymbols.openInNew), findsOneWidget);
      expect(tester.getSemantics(find.byType(InkWell)), isSemantics(isLink: true));
      await tester.tap(find.text('kalkar.de'));
      expect(tapped, isTrue);
      handle.dispose();
    });
  });

  testWidgets('a title is a Kennung over a header', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app(const HorizontTitle(kennung: 'Rathaus', title: 'Öffnungszeiten')));
    expect(find.text('RATHAUS'), findsOneWidget);
    expect(tester.getSemantics(find.text('Öffnungszeiten')), isSemantics(isHeader: true));
    handle.dispose();
  });

  group('selection', () {
    testWidgets('a chosen row has the tint and the line at the start', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_app(const HorizontSelectable(selected: true, child: Text('Linie 1'))));
      final box = tester.widget<Container>(
        find.ancestor(of: find.text('Linie 1'), matching: find.byType(Container)).first,
      );
      final decoration = box.decoration! as BoxDecoration;
      final colors = HorizontTheme.of(tester.element(find.text('Linie 1'))).colors;
      expect(decoration.color, colors.accentTint);
      final border = decoration.border! as BorderDirectional;
      expect(border.start.width, HzLine.selection);
      expect(border.start.color, colors.accent);
      expect(tester.getSemantics(find.byType(HorizontSelectable)), isSemantics(isSelected: true));
      handle.dispose();
    });

    testWidgets('an unchosen row keeps the room of the line', (tester) async {
      await tester.pumpWidget(
        _app(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HorizontSelectable(selected: true, child: Text('a')),
              HorizontSelectable(selected: false, child: Text('b')),
            ],
          ),
        ),
      );
      expect(tester.getTopLeft(find.text('a')).dx, tester.getTopLeft(find.text('b')).dx);
    });
  });

  group('primary action', () {
    const action = HorizontPrimaryAction(icon: HorizontSymbols.add, label: 'Melden', onPressed: null);

    Widget scaffold({HorizontDensity? density, double width = 390}) => MediaQuery(
      data: MediaQueryData(size: Size(width, 800)),
      child: MaterialApp(
        theme: buildHorizontTheme(HorizontProduct.kalkarKompakt, Brightness.light, density: density),
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(actions: action.toolbar(context)),
            floatingActionButton: action.fab(context),
          ),
        ),
      ),
    );

    testWidgets('on a phone a square FAB with the symbol only', (tester) async {
      await tester.pumpWidget(scaffold(density: HorizontDensity.touch));
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Melden'), findsNothing);
      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets('from 600 the FAB carries the word', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(scaffold(density: HorizontDensity.touch, width: 800));
      expect(find.text('Melden'), findsOneWidget);
    });

    testWidgets('with a pointer in the toolbar, no FAB', (tester) async {
      await tester.pumpWidget(scaffold(density: HorizontDensity.pointer));
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.text('Melden'), findsOneWidget);
    });
  });

  testWidgets('sheet actions take the platform words and the accent saves', (tester) async {
    var saved = false;
    await tester.pumpWidget(_app(HorizontSheetActions(onSave: () => saved = true)));
    expect(find.text('Cancel'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    expect(saved, isTrue);
    await tester.pumpWidget(_app(HorizontSheetActions(onSave: () {}, saving: true)));
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
  });

  testWidgets('a folding section head says whether it is open', (tester) async {
    final handle = tester.ensureSemantics();
    var toggled = false;
    await tester.pumpWidget(
      _app(HorizontSectionHeader('Abfall', count: 3, collapsed: true, onToggle: () => toggled = true)),
    );
    expect(find.byIcon(HorizontSymbols.expandMore), findsOneWidget);
    expect(tester.getSemantics(find.byType(InkWell)), isSemantics(hasExpandedState: true, isExpanded: false));
    await tester.tap(find.byType(HorizontSectionHeader));
    expect(toggled, isTrue);
    handle.dispose();
  });

  testWidgets('a failure hint shows the state glyph in its colour', (tester) async {
    await tester.pumpWidget(_app(const HorizontEmptyHint(text: 'Keine Verbindung', status: HorizontStatus.critical)));
    final icon = tester.widget<Icon>(find.byIcon(HorizontStatus.critical.icon));
    final colors = HorizontTheme.of(tester.element(find.byType(Icon))).colors;
    expect(icon.color, colors.critical);
  });

  testWidgets('a message with a state carries its glyph', (tester) async {
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showHorizontMessage(context, 'Gesichert', status: HorizontStatus.positive),
            child: const Text('los'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('los'));
    await tester.pump();
    expect(find.text('Gesichert'), findsOneWidget);
    expect(find.byIcon(HorizontStatus.positive.icon), findsOneWidget);
  });

  for (final (platform, symbol) in [
    (TargetPlatform.iOS, HorizontSymbols.chevronLeft),
    (TargetPlatform.android, HorizontSymbols.arrowBack),
  ]) {
    testWidgets('the back button on ${platform.name} uses Horizont symbols', (tester) async {
      await tester.pumpWidget(_app(const BackButton(), platform: platform));
      expect(find.byIcon(symbol), findsOneWidget);
    });
  }

  test('Kalkar Kompakt is a product with the accent Backstein', () {
    expect(HorizontProduct.kalkarKompakt.accentName, 'Backstein');
  });
}
