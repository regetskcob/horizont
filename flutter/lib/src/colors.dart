import 'package:flutter/widgets.dart';

import 'tokens.g.dart';

/// The form of a product's surfaces in an app. Since 0.13.0 apps use [soft]
/// unless they pass [standard]; web pages stay standard. The rules are in
/// CLAUDE.md, „Weiche Stufe“.
enum HorizontStyle {
  /// Radii 6 and 10, one outline in `line-strong`, Kennung in Mono, the
  /// selection as a 2 px line.
  standard,

  /// The default in apps: rounder corners, quiet outlines and, where the
  /// product has them, its own tinted paper; the selection is the tint
  /// alone. Hierarchy comes from the paper, not from lines.
  soft,
}

/// The semantic colour slots of one product in one brightness: tier 2.
///
/// Widgets read these through `HorizontTheme.of(context).colors`, never the
/// raw values in `tokens.g.dart`. Panzergefecht's own neutrals in the dark
/// (Gelände) are already applied.
@immutable
class HorizontColors {
  /// Creates a set of slots. Prefer [HorizontColors.resolve].
  const HorizontColors({
    required this.bg,
    required this.surface,
    required this.sunken,
    required this.line,
    required this.lineStrong,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.accent,
    required this.onAccent,
    required this.accentTint,
    required this.accentText,
    required this.positive,
    required this.positiveTint,
    required this.warning,
    required this.warningTint,
    required this.critical,
    required this.criticalTint,
    required this.onCritical,
    required this.info,
    required this.infoTint,
    required this.dataRamp,
  });

  /// The slots of [product] in [brightness], from the tokens. Embedded in a
  /// [host] (Home Assistant's Ingress), the neutrals are the host's; accent
  /// and status stay the product's. In the soft [style] the product's own
  /// soft colours apply, except in a host: there its neutrals keep the say.
  factory HorizontColors.resolve(
    HorizontProduct product,
    Brightness brightness, {
    HorizontHost? host,
    HorizontStyle style = HorizontStyle.standard,
  }) {
    final dark = brightness == Brightness.dark;
    final n = host != null
        ? (dark ? host.dark : host.light)
        : dark
            ? (product.neutralDark ?? HzColors.neutralDark)
            : HzColors.neutralLight;
    final s = dark ? HzColors.statusDark : HzColors.statusLight;
    final a = dark ? product.dark : product.light;
    final t = style == HorizontStyle.soft && host == null ? (dark ? product.softDark : product.softLight) : null;
    return HorizontColors(
      bg: t?.bg ?? n.bg,
      surface: t?.surface ?? n.surface,
      sunken: n.sunken,
      line: t?.line ?? n.line,
      lineStrong: t?.lineStrong ?? n.lineStrong,
      text: n.text,
      textMuted: n.textMuted,
      textFaint: n.textFaint,
      accent: a.accent,
      onAccent: a.onAccent,
      accentTint: t?.accentTint ?? a.accentTint,
      accentText: t?.accentText ?? a.accentText,
      positive: s.positive,
      positiveTint: s.positiveTint,
      warning: s.warning,
      warningTint: s.warningTint,
      critical: s.critical,
      criticalTint: s.criticalTint,
      onCritical: s.onCritical,
      info: s.info,
      infoTint: s.infoTint,
      dataRamp: dark ? HzColors.dataRampDark : HzColors.dataRampLight,
    );
  }

  /// Page background, paper.
  final Color bg;

  /// Raised surfaces: cards, sheets, inputs.
  final Color surface;

  /// Sunken surfaces: sidebars, sections, code.
  final Color sunken;

  /// Hairlines between rows and sections.
  final Color line;

  /// The one outline of everything framed: fields, buttons, cards, dialogs,
  /// sheets, menus, the switch's off track. At least 3:1 on [bg],
  /// [surface] and [sunken] (WCAG 1.4.11).
  final Color lineStrong;

  /// Text, ink.
  final Color text;

  /// Secondary text, Kennungen, meta lines. At least 4.5:1.
  final Color textMuted;

  /// Decorative text only, never for reading.
  final Color textFaint;

  /// Fill of the one primary action.
  final Color accent;

  /// Text and icons on [accent].
  final Color onAccent;

  /// Background of the selection.
  final Color accentTint;

  /// Accent as text, link or line. At least 4.5:1 on [bg].
  final Color accentText;

  /// Status: good, done, connected.
  final Color positive;

  /// Background of [positive].
  final Color positiveTint;

  /// Status: check, attention.
  final Color warning;

  /// Background of [warning].
  final Color warningTint;

  /// Status: broken, error, destructive.
  final Color critical;

  /// Background of [critical].
  final Color criticalTint;

  /// Text and icons on [critical], e.g. a `FilledButton` for an
  /// irreversible action.
  final Color onCritical;

  /// Status: note, information.
  final Color info;

  /// Background of [info].
  final Color infoTint;

  /// Sequential data ramp for heatmaps and densities, five steps from little
  /// to much. One hue, neither accent nor status; read the value from a
  /// legend or label too, never from the colour alone.
  final List<Color> dataRamp;

  /// Interpolates every slot; used by the theme's `lerp`.
  static HorizontColors lerp(HorizontColors a, HorizontColors b, double t) {
    Color l(Color x, Color y) => Color.lerp(x, y, t)!;
    return HorizontColors(
      bg: l(a.bg, b.bg),
      surface: l(a.surface, b.surface),
      sunken: l(a.sunken, b.sunken),
      line: l(a.line, b.line),
      lineStrong: l(a.lineStrong, b.lineStrong),
      text: l(a.text, b.text),
      textMuted: l(a.textMuted, b.textMuted),
      textFaint: l(a.textFaint, b.textFaint),
      accent: l(a.accent, b.accent),
      onAccent: l(a.onAccent, b.onAccent),
      accentTint: l(a.accentTint, b.accentTint),
      accentText: l(a.accentText, b.accentText),
      positive: l(a.positive, b.positive),
      positiveTint: l(a.positiveTint, b.positiveTint),
      warning: l(a.warning, b.warning),
      warningTint: l(a.warningTint, b.warningTint),
      critical: l(a.critical, b.critical),
      criticalTint: l(a.criticalTint, b.criticalTint),
      onCritical: l(a.onCritical, b.onCritical),
      info: l(a.info, b.info),
      infoTint: l(a.infoTint, b.infoTint),
      dataRamp: [for (var i = 0; i < a.dataRamp.length; i++) l(a.dataRamp[i], b.dataRamp[i])],
    );
  }
}
