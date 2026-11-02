import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  final cases = [
    for (final product in HorizontProduct.values) (product, null, HorizontStyle.standard),
    for (final host in HorizontHost.values) (HorizontProduct.knx, host, HorizontStyle.standard),
    for (final product in HorizontProduct.values)
      if (product.softLight != null) (product, null, HorizontStyle.soft),
  ];
  for (final (product, host, style) in cases) {
    for (final brightness in Brightness.values) {
      final c = HorizontColors.resolve(product, brightness, host: host, style: style);
      group('${product.name}${host == null ? '' : ' in ${host.name}'} ${style.name} ${brightness.name}', () {
        // Reading text and anything that carries meaning: WCAG AA, 4.5:1.
        final pairs = <String, (Color, Color)>{
          'text on bg': (c.text, c.bg),
          'text on surface': (c.text, c.surface),
          'text on sunken': (c.text, c.sunken),
          'text-muted on bg': (c.textMuted, c.bg),
          'text-muted on surface': (c.textMuted, c.surface),
          'text-muted on sunken': (c.textMuted, c.sunken),
          'accent-text on bg': (c.accentText, c.bg),
          'accent-text on surface': (c.accentText, c.surface),
          'text on accent-tint': (c.text, c.accentTint),
          'on-accent on accent': (c.onAccent, c.accent),
          'positive on its tint': (c.positive, c.positiveTint),
          'warning on its tint': (c.warning, c.warningTint),
          'critical on its tint': (c.critical, c.criticalTint),
          'info on its tint': (c.info, c.infoTint),
          'accent-text on accent-tint': (c.accentText, c.accentTint),
          'on-critical on critical': (c.onCritical, c.critical),
          // Status lines set sign and words in the status colour on paper.
          'positive on bg': (c.positive, c.bg),
          'positive on surface': (c.positive, c.surface),
          'warning on bg': (c.warning, c.bg),
          'warning on surface': (c.warning, c.surface),
          'critical on bg': (c.critical, c.bg),
          'critical on surface': (c.critical, c.surface),
          'info on bg': (c.info, c.bg),
          'info on surface': (c.info, c.surface),
        };
        pairs.forEach((name, pair) {
          test('$name >= 4.5:1', () {
            expect(_contrast(pair.$1, pair.$2), greaterThanOrEqualTo(4.5));
          });
        });
        // Lines that identify a control or mark its state: 3:1 (WCAG
        // 1.4.11). line-strong is the one outline of fields, buttons,
        // checkboxes, segments and the switch's off track, on every paper.
        test('accent against bg >= 3:1 (selection line)', () {
          expect(_contrast(c.accent, c.bg), greaterThanOrEqualTo(3));
        });
        for (final (name, paper) in [('bg', c.bg), ('surface', c.surface), ('sunken', c.sunken)]) {
          test('line-strong against $name >= 3:1 (outline of controls)', () {
            expect(_contrast(c.lineStrong, paper), greaterThanOrEqualTo(3));
          });
        }
        // The data ramp: five steps, darker (light) or lighter (dark) with
        // every step, the last one 3:1 on every paper.
        test('data ramp is monotonic and its last step >= 3:1', () {
          expect(c.dataRamp, hasLength(5));
          final l = [for (final x in c.dataRamp) x.computeLuminance()];
          for (var i = 1; i < l.length; i++) {
            if (brightness == Brightness.light) {
              expect(l[i], lessThan(l[i - 1]));
            } else {
              expect(l[i], greaterThan(l[i - 1]));
            }
          }
          for (final paper in [c.bg, c.surface, c.sunken]) {
            expect(_contrast(c.dataRamp.last, paper), greaterThanOrEqualTo(3));
          }
        });
      });
    }
  }
}
