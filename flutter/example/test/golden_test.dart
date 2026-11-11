@Tags(['golden'])
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';
import 'package:horizont/testing.dart';
import 'package:horizont_example/showcase.dart';

void main() {
  setUpAll(loadHorizontFonts);

  for (final product in HorizontProduct.values) {
    for (final brightness in Brightness.values) {
      for (final scale in [1.0, 2.0]) {
        final name = '${product.name}_${brightness.name}_${scale.toStringAsFixed(0)}x';
        testWidgets(name, (tester) async {
          tester.view.physicalSize = const Size(393, 852) * 2;
          tester.view.devicePixelRatio = 2;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            MediaQuery(
              data: MediaQueryData(size: const Size(393, 852), textScaler: TextScaler.linear(scale)),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: buildHorizontTheme(product, brightness),
                home: const Showcase(),
              ),
            ),
          );
          await expectLater(find.byType(Showcase), matchesGoldenFile('goldens/$name.png'));
        });
      }
    }
  }

  // The same screen as an iOS app: Cupertino switch in the accent, no
  // ripple, the system's page transitions. Horizont only sets the colours.
  for (final (product, brightness) in [
    (HorizontProduct.jagdaufseher, Brightness.light),
    (HorizontProduct.panzergefecht, Brightness.dark),
  ]) {
    final name = '${product.name}_${brightness.name}_ios';
    testWidgets(name, (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      tester.view.physicalSize = const Size(393, 852) * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildHorizontTheme(product, brightness),
          home: const Showcase(),
        ),
      );
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      await expectLater(find.byType(Showcase), matchesGoldenFile('goldens/$name.png'));
      debugDefaultTargetPlatformOverride = null;
    });
  }

  // KNX Monitor as the Home Assistant add-on in Ingress: the host's
  // neutrals, Horizont's accent, status, type and lines.
  for (final brightness in Brightness.values) {
    final name = 'knx_${brightness.name}_home_assistant';
    testWidgets(name, (tester) async {
      tester.view.physicalSize = const Size(393, 852) * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildHorizontTheme(HorizontProduct.knx, brightness, host: HorizontHost.homeAssistant),
          home: const Showcase(),
        ),
      );
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      await expectLater(find.byType(Showcase), matchesGoldenFile('goldens/$name.png'));
    });
  }

  // From 600 the rail replaces the tab bar and the FAB carries its word; in
  // the soft style (the default) and once in the standard one.
  for (final (style, name) in [
    (HorizontStyle.soft, 'knx_light_tablet'),
    (HorizontStyle.standard, 'knx_light_tablet_standard'),
  ]) {
    testWidgets(name, (tester) async {
      tester.view.physicalSize = const Size(820, 1180);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light, style: style),
          home: const Showcase(),
        ),
      );
      await expectLater(find.byType(Showcase), matchesGoldenFile('goldens/$name.png'));
    });
  }
}
