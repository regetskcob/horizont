import 'package:flutter/material.dart';

import 'colors.dart';
import 'tokens.g.dart';

/// How dense the controls are: touch keeps 44 pt targets, pointer (macOS,
/// Windows, Linux, the web on a computer) uses 28 pt controls and rows.
enum HorizontDensity {
  /// Phones, tablets, TV, watch.
  touch,

  /// Mouse or trackpad.
  pointer;

  /// The density a platform expects: pointer on macOS, Windows and Linux
  /// (also the web on those systems), touch everywhere else.
  static HorizontDensity forPlatform(TargetPlatform platform) => switch (platform) {
        TargetPlatform.macOS || TargetPlatform.windows || TargetPlatform.linux => HorizontDensity.pointer,
        TargetPlatform.android || TargetPlatform.iOS || TargetPlatform.fuchsia => HorizontDensity.touch,
      };
}

/// Everything of Horizont that Material's `ThemeData` has no slot for:
/// product, density, the colour slots and the text styles of the three
/// voices. Read it with [HorizontTheme.of].
@immutable
class HorizontTheme extends ThemeExtension<HorizontTheme> {
  /// Creates the extension. Prefer `buildHorizontTheme`, which attaches it.
  const HorizontTheme({
    required this.product,
    required this.brightness,
    required this.density,
    required this.colors,
    required this.data,
    required this.kennung,
    required this.reading,
    required this.display,
    required this.field,
    this.style = HorizontStyle.standard,
  });

  /// The theme of [context]. Asserts when the app's ThemeData was not built
  /// by `buildHorizontTheme`; there is deliberately no fallback.
  static HorizontTheme of(BuildContext context) {
    final ext = Theme.of(context).extension<HorizontTheme>();
    assert(ext != null, 'HorizontTheme missing: build ThemeData with buildHorizontTheme().');
    return ext!;
  }

  /// The product whose accent this theme carries.
  final HorizontProduct product;

  /// Light or dark.
  final Brightness brightness;

  /// Touch or pointer.
  final HorizontDensity density;

  /// The colour slots.
  final HorizontColors colors;

  /// Measured values: Monaspace 14/20 with tabular figures.
  final TextStyle data;

  /// Kennung: Monaspace 11/16, 600, tracked. Uppercase the text itself
  /// (the `Kennung` widget does).
  final TextStyle kennung;

  /// Long reading text: Literata 18/28, light.
  final TextStyle reading;

  /// Landing and onboarding headlines: Literata 44/48, light.
  final TextStyle display;

  /// Input in body text: Mona Sans 16 on the line of [data] (20), so a field
  /// is exactly [controlHeight] high like one in Mono. Material's TextField
  /// has no theme slot for its text, so pass it to fields in body text:
  /// `TextField(style: HorizontTheme.of(context).field)`. Fields in [data]
  /// and `DropdownMenu` (themed) need nothing.
  final TextStyle field;

  /// The form of the surfaces; components that Material does not theme
  /// (sidebar, selection) draw themselves after it.
  final HorizontStyle style;

  /// Whether [style] is [HorizontStyle.soft].
  bool get soft => style == HorizontStyle.soft;

  /// A count next to a label (sidebar row, section head): in the soft
  /// style Mona Sans with tabular figures, so a number in a menu does not
  /// read as a measurement; otherwise [data]. Both in `text-muted`.
  TextStyle get count => soft
      ? horizontTextStyle(HzType.callout, colors.textMuted)
          .copyWith(fontFeatures: const [FontFeature.tabularFigures()])
      : data.copyWith(color: colors.textMuted);

  /// Minimum height of a control for [density]: 44 on touch, 28 with a pointer.
  double get controlHeight => density == HorizontDensity.touch ? HzSize.touch : HzSize.controlDesktop;

  /// Corner radius of a control (field, button, segment) for [style]: 8 in
  /// the soft style, 6 in the standard one, on touch and with a pointer
  /// alike. Use it for anything that stands in a row with fields and
  /// buttons instead of reading `HzSoft.control` or `HzRadius.r6` directly.
  BorderRadius get controlRadius =>
      BorderRadius.all(Radius.circular(soft ? HzSoft.control : HzRadius.r6));

  /// Height of a list row for [density].
  double get rowHeight => density == HorizontDensity.touch ? HzSize.row : HzSize.rowDense;

  /// The style of a `FilledButton` for an action that acts outward and
  /// cannot be undone: [HorizontColors.critical] with
  /// [HorizontColors.onCritical]. Never the primary action in the accent;
  /// confirm it with `showAdaptiveDialog` first.
  ///
  /// ```dart
  /// FilledButton(style: HorizontTheme.of(context).criticalButton, …)
  /// ```
  ButtonStyle get criticalButton => FilledButton.styleFrom(
        backgroundColor: colors.critical,
        foregroundColor: colors.onCritical,
      );

  /// The style of an `IconButton` inside a field (search, clear, reveal): as
  /// high and wide as the field, without padding, the icon 18. Otherwise the
  /// button (40/48) makes the field taller. `HorizontFieldIconButton` uses it.
  ButtonStyle get fieldIconButton => IconButton.styleFrom(
        fixedSize: Size.square(controlHeight),
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        iconSize: HzIconSize.row,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

  @override
  HorizontTheme copyWith({
    HorizontProduct? product,
    Brightness? brightness,
    HorizontDensity? density,
    HorizontColors? colors,
    TextStyle? data,
    TextStyle? kennung,
    TextStyle? reading,
    TextStyle? display,
    TextStyle? field,
    HorizontStyle? style,
  }) =>
      HorizontTheme(
        product: product ?? this.product,
        brightness: brightness ?? this.brightness,
        density: density ?? this.density,
        colors: colors ?? this.colors,
        data: data ?? this.data,
        kennung: kennung ?? this.kennung,
        reading: reading ?? this.reading,
        display: display ?? this.display,
        field: field ?? this.field,
        style: style ?? this.style,
      );

  /// Colours and text styles interpolate; product, brightness, density and
  /// style are not interpolable and snap at the midpoint.
  @override
  HorizontTheme lerp(covariant HorizontTheme? other, double t) {
    if (other == null) return this;
    final snap = t < 0.5 ? this : other;
    return HorizontTheme(
      product: snap.product,
      brightness: snap.brightness,
      density: snap.density,
      colors: HorizontColors.lerp(colors, other.colors, t),
      data: TextStyle.lerp(data, other.data, t)!,
      kennung: TextStyle.lerp(kennung, other.kennung, t)!,
      reading: TextStyle.lerp(reading, other.reading, t)!,
      display: TextStyle.lerp(display, other.display, t)!,
      field: TextStyle.lerp(field, other.field, t)!,
      style: snap.style,
    );
  }
}

/// A [TextStyle] for one step of the type scale, in [color].
TextStyle horizontTextStyle(HzTypeSpec spec, Color color) => TextStyle(
      fontFamily: spec.family,
      package: HzFont.package,
      fontSize: spec.size,
      height: spec.line / spec.size,
      fontWeight: spec.weight,
      letterSpacing: spec.tracking * spec.size,
      color: color,
      fontFeatures: spec.family == HzFont.mono ? const [FontFeature.tabularFigures()] : null,
      leadingDistribution: TextLeadingDistribution.even,
    );

/// [full], or zero when the platform asks for reduced motion. Not shorter,
/// not softer: zero.
Duration resolveMotion(BuildContext context, Duration full) =>
    MediaQuery.disableAnimationsOf(context) ? Duration.zero : full;
