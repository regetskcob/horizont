import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';

void main() {
  test(
    'every product and brightness carries the extension and a hand-set scheme',
    () {
      for (final product in HorizontProduct.values) {
        for (final brightness in Brightness.values) {
          final theme = buildHorizontTheme(product, brightness);
          final ext = theme.extension<HorizontTheme>();
          expect(ext, isNotNull);
          expect(ext!.product, product);
          expect(theme.colorScheme.brightness, brightness);
          expect(theme.colorScheme.primary, ext.colors.accent);
          expect(theme.colorScheme.surface, ext.colors.bg);
          expect(theme.colorScheme.surfaceTint, Colors.transparent);
        }
      }
    },
  );

  group('soft style', () {
    test('is the default in apps, the extension knows it', () {
      final soft = buildHorizontTheme(
        HorizontProduct.landbote,
        Brightness.light,
      );
      expect(soft.extension<HorizontTheme>()!.style, HorizontStyle.soft);
      expect(soft.extension<HorizontTheme>()!.soft, isTrue);
      final standard = buildHorizontTheme(
        HorizontProduct.landbote,
        Brightness.light,
        style: HorizontStyle.standard,
      );
      expect(
        standard.extension<HorizontTheme>()!.style,
        HorizontStyle.standard,
      );
    });

    test('counts are Mona Sans with tabular figures, standard keeps Mono', () {
      HorizontTheme ext(HorizontStyle style) => buildHorizontTheme(
        HorizontProduct.gemarkung,
        Brightness.light,
        style: style,
      ).extension<HorizontTheme>()!;
      expect(ext(HorizontStyle.soft).count.fontFamily, contains(HzFont.sans));
      expect(
        ext(HorizontStyle.soft).count.fontFeatures,
        contains(const FontFeature.tabularFigures()),
      );
      expect(
        ext(HorizontStyle.standard).count.fontFamily,
        contains(HzFont.mono),
      );
    });

    test('rounds the corners, keeps the standard untouched', () {
      RoundedRectangleBorder card(HorizontStyle style) =>
          buildHorizontTheme(
                HorizontProduct.knx,
                Brightness.light,
                style: style,
              ).cardTheme.shape!
              as RoundedRectangleBorder;
      expect(
        card(HorizontStyle.standard).borderRadius,
        BorderRadius.circular(HzRadius.r10),
      );
      expect(
        card(HorizontStyle.soft).borderRadius,
        BorderRadius.circular(HzSoft.card),
      );
    });

    test('the product brings its paper, the extension carries it', () {
      final theme = buildHorizontTheme(
        HorizontProduct.knx,
        Brightness.dark,
        style: HorizontStyle.soft,
      );
      final colors = theme.extension<HorizontTheme>()!.colors;
      expect(colors.bg, HorizontProduct.knx.softDark!.bg);
      expect(colors.surface, HorizontProduct.knx.softDark!.surface);
      expect(theme.scaffoldBackgroundColor, colors.bg);
    });

    test('a host keeps its neutrals', () {
      final colors = buildHorizontTheme(
        HorizontProduct.knx,
        Brightness.light,
        host: HorizontHost.homeAssistant,
        style: HorizontStyle.soft,
      ).extension<HorizontTheme>()!.colors;
      expect(colors.bg, HorizontHost.homeAssistant.light.bg);
    });

    test('a product without soft colours keeps its own', () {
      expect(
        HorizontColors.resolve(
          HorizontProduct.jagdaufseher,
          Brightness.light,
          style: HorizontStyle.soft,
        ).bg,
        HorizontColors.resolve(
          HorizontProduct.jagdaufseher,
          Brightness.light,
        ).bg,
      );
    });
  });

  test('Panzergefecht uses Gelände in the dark only', () {
    final dark = HorizontColors.resolve(
      HorizontProduct.panzergefecht,
      Brightness.dark,
    );
    final light = HorizontColors.resolve(
      HorizontProduct.panzergefecht,
      Brightness.light,
    );
    final knxDark = HorizontColors.resolve(
      HorizontProduct.knx,
      Brightness.dark,
    );
    expect(dark.bg, isNot(knxDark.bg));
    expect(
      light.bg,
      HorizontColors.resolve(HorizontProduct.knx, Brightness.light).bg,
    );
  });

  test('pointer density uses 28 pt controls', () {
    final touch = buildHorizontTheme(
      HorizontProduct.knx,
      Brightness.light,
    ).extension<HorizontTheme>()!;
    final pointer = buildHorizontTheme(
      HorizontProduct.knx,
      Brightness.light,
      density: HorizontDensity.pointer,
    ).extension<HorizontTheme>()!;
    expect(touch.controlHeight, 44);
    expect(pointer.controlHeight, 28);
  });

  test('lerp interpolates colours and snaps the product', () {
    final a = buildHorizontTheme(
      HorizontProduct.knx,
      Brightness.light,
    ).extension<HorizontTheme>()!;
    final b = buildHorizontTheme(
      HorizontProduct.jagdaufseher,
      Brightness.dark,
    ).extension<HorizontTheme>()!;
    expect(a.lerp(b, 0.25).product, HorizontProduct.knx);
    expect(a.lerp(b, 0.75).product, HorizontProduct.jagdaufseher);
    expect(a.lerp(b, 0.5).colors.bg, Color.lerp(a.colors.bg, b.colors.bg, 0.5));
  });

  testWidgets('of() asserts when the theme was not built by Horizont', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            HorizontTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('resolveMotion collapses to zero under reduced motion', (
    tester,
  ) async {
    late Duration full;
    late Duration reduced;
    await tester.pumpWidget(
      Column(
        children: [
          Builder(
            builder: (context) {
              full = resolveMotion(context, HzMotion.base);
              return const SizedBox();
            },
          ),
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Builder(
              builder: (context) {
                reduced = resolveMotion(context, HzMotion.base);
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
    expect(full, const Duration(milliseconds: 200));
    expect(reduced, Duration.zero);
  });

  group('native feel per platform', () {
    ThemeData build(TargetPlatform p) =>
        buildHorizontTheme(HorizontProduct.knx, Brightness.light, platform: p);

    test('Android keeps its ripple, the others only the press highlight', () {
      expect(
        build(TargetPlatform.android).splashFactory,
        InkSparkle.splashFactory,
      );
      for (final p in [
        TargetPlatform.iOS,
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
      ]) {
        expect(build(p).splashFactory, NoSplash.splashFactory, reason: p.name);
      }
    });

    test('native page transitions with their back gestures', () {
      final android = build(
        TargetPlatform.android,
      ).pageTransitionsTheme.builders;
      final ios = build(TargetPlatform.iOS).pageTransitionsTheme.builders;
      expect(
        android[TargetPlatform.android],
        isA<PredictiveBackPageTransitionsBuilder>(),
      );
      expect(ios[TargetPlatform.iOS], isA<CupertinoPageTransitionsBuilder>());
      expect(ios[TargetPlatform.macOS], isA<CupertinoPageTransitionsBuilder>());
    });

    test('desktops get pointer density by default, phones touch', () {
      expect(
        build(TargetPlatform.macOS).extension<HorizontTheme>()!.density,
        HorizontDensity.pointer,
      );
      expect(
        build(TargetPlatform.windows).extension<HorizontTheme>()!.density,
        HorizontDensity.pointer,
      );
      expect(
        build(TargetPlatform.iOS).extension<HorizontTheme>()!.density,
        HorizontDensity.touch,
      );
      expect(
        build(TargetPlatform.android).extension<HorizontTheme>()!.density,
        HorizontDensity.touch,
      );
    });

    test('Cupertino widgets take the accent but keep the system font', () {
      final theme = build(TargetPlatform.iOS);
      final cupertino = MaterialBasedCupertinoThemeData(materialTheme: theme);
      expect(
        cupertino.primaryColor,
        theme.extension<HorizontTheme>()!.colors.accent,
      );
      expect(cupertino.textTheme.textStyle.fontFamily, isNot(HzFont.sans));
    });
  });

  testWidgets('with a pointer, buttons keep the 28 pt control height', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildHorizontTheme(
          HorizontProduct.knx,
          Brightness.light,
          density: HorizontDensity.pointer,
        ),
        home: Scaffold(
          body: Center(
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Kopieren'),
            ),
          ),
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(OutlinedButton)).height,
      greaterThanOrEqualTo(HzSize.controlDesktop),
    );
  });

  test('error and critical buttons use on-critical', () {
    for (final b in Brightness.values) {
      final c = HorizontColors.resolve(HorizontProduct.knx, b);
      final theme = buildHorizontTheme(HorizontProduct.knx, b);
      expect(theme.colorScheme.onError, c.onCritical);
      final style = theme.extension<HorizontTheme>()!.criticalButton;
      expect(style.backgroundColor?.resolve({}), c.critical);
      expect(style.foregroundColor?.resolve({}), c.onCritical);
    }
  });
}
