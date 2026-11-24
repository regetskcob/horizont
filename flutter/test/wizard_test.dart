import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';

/// A wizard of three steps; the second refuses until [allow] is set, the
/// third creates something and [created] counts it.
class _Host extends StatefulWidget {
  const _Host();

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  bool allow = false;
  int created = 0;
  bool? result;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: FilledButton(
        onPressed: () async {
          final done = await showHorizontWizard(
            context,
            StatefulBuilder(
              builder: (context, setInner) => HorizontWizard(
                title: 'Kanal anlegen',
                finishLabel: 'Anlegen',
                stepOf: (i, n) => 'Schritt $i von $n',
                steps: [
                  const HorizontWizardStep(
                    title: 'Plattform',
                    subtitle: 'Wohin gepostet wird.',
                    content: Text('Inhalt 1'),
                  ),
                  HorizontWizardStep(
                    title: 'Zugang',
                    content: const Text('Inhalt 2'),
                    onContinue: () async => allow ? null : 'Der Zugang fehlt.',
                  ),
                  HorizontWizardStep(
                    title: 'Prüfen',
                    content: const Text('Inhalt 3'),
                    onContinue: () async {
                      created++;
                      return null;
                    },
                  ),
                ],
              ),
            ),
          );
          setState(() => result = done);
        },
        child: const Text('öffnen'),
      ),
    ),
  );
}

Future<_HostState> _open(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light),
      home: const _Host(),
    ),
  );
  await tester.tap(find.text('öffnen'));
  await tester.pumpAndSettle();
  return tester.state<_HostState>(find.byType(_Host));
}

void main() {
  testWidgets(
    'wide: steps on the left, a refusal as a critical line, finish closes with true',
    (tester) async {
      final host = await _open(tester, const Size(1200, 800));
      expect(find.text('Kanal anlegen'), findsOneWidget);
      expect(find.text('Schritt 1 von 3'), findsOneWidget);
      expect(find.text('Zugang'), findsOneWidget, reason: 'the list of steps');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Der Zugang fehlt.'), findsOneWidget);
      expect(
        find.byIcon(HorizontSymbols.report),
        findsOneWidget,
        reason: 'never only in colour',
      );
      expect(find.text('Inhalt 2'), findsOneWidget);

      host.allow = true;
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Inhalt 3'), findsOneWidget);
      // Back to the first step through the list, and forward again.
      await tester.tap(find.text('Plattform'));
      await tester.pumpAndSettle();
      expect(find.text('Inhalt 1'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Anlegen'));
      await tester.pumpAndSettle();
      expect((host.created, host.result), (1, true));
      expect(find.text('Inhalt 3'), findsNothing);
    },
  );

  testWidgets(
    'narrow: the wizard takes the screen, the step as a Kennung above its title',
    (tester) async {
      final host = await _open(tester, const Size(390, 844));
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Kanal anlegen · Schritt 1 von 3'), findsOneWidget);
      expect(
        find.text('Zugang'),
        findsNothing,
        reason: 'no list of steps on a phone',
      );
      expect(tester.getSize(find.byType(HorizontWizard)).width, 390);
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(host.result, isFalse);
    },
  );

  testWidgets('back is offered from the second step on', (tester) async {
    await _open(tester, const Size(1200, 800));
    expect(find.text('Back'), findsNothing);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Back'), findsOneWidget);
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Inhalt 1'), findsOneWidget);
  });

  testWidgets(
    'phone with doubled type: head scrolls, foot wraps, nothing overflows',
    (tester) async {
      const size = Size(375, 667);
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: size,
            textScaler: TextScaler.linear(2),
          ),
          child: MaterialApp(
            theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light),
            home: Material(
              child: HorizontWizard(
                title: 'Übergabepaket',
                finishLabel: 'Paket erstellen und teilen',
                stepOf: (i, n) => 'Schritt $i von $n',
                steps: [
                  const HorizontWizardStep(
                    title: 'Inhalt',
                    content: Text('Inhalt 1'),
                  ),
                  HorizontWizardStep(
                    title: 'Passwort',
                    subtitle:
                        'Gib das Passwort getrennt von der Datei weiter, am '
                        'besten scannt der Kunde den QR-Code vor Ort. Es wird '
                        'nirgends gespeichert.',
                    content: const SizedBox(height: 400, child: Placeholder()),
                    onContinue: () async =>
                        'Das Paket ließ sich nicht erstellen.',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      // Back and the long word of the finish no longer fit side by side.
      expect(tester.takeException(), isNull);
      final back = tester.getTopLeft(find.text('Back'));
      final finish = tester.getTopLeft(find.text('Paket erstellen und teilen'));
      expect(finish.dy, greaterThan(back.dy));
      // The refusal stands above the buttons, in words.
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(find.text('Das Paket ließ sich nicht erstellen.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
