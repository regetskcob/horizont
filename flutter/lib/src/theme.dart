import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'horizont_theme.dart';
import 'tokens.g.dart';

/// The `ThemeData` of [product] in [brightness]: a hand-authored
/// `ColorScheme` (never `fromSeed`), the text theme of the three voices, the
/// component themes of Horizont and the [HorizontTheme] extension.
///
/// Horizont sets colour, type, lines and spacing; the platform keeps its
/// behaviour. Per [platform] (default: the one the app runs on) the theme
/// keeps the native touch feedback (Android's ripple, the plain press
/// highlight on Apple platforms, Windows, Linux and the web), the native page
/// transitions with their back gestures (swipe back on iOS and macOS,
/// predictive back on Android), the density (pointer on desktops unless
/// [density] says otherwise) and a Cupertino theme, so adaptive widgets
/// (`Switch.adaptive`, `showAdaptiveDialog`, Cupertino pickers) look native
/// in the product's colours, with the system font.
///
/// Embedded in a [host] (the Home Assistant add-on inside Ingress), the
/// neutrals are the host's so the product sits calmly in its frame; accent,
/// status, type and lines stay Horizont.
///
/// Build it once per brightness at the composition root:
///
/// ```dart
/// MaterialApp(
///   theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light),
///   darkTheme: buildHorizontTheme(HorizontProduct.knx, Brightness.dark),
///   themeAnimationStyle: AnimationStyle.noAnimation,
/// )
/// ```
ThemeData buildHorizontTheme(
  HorizontProduct product,
  Brightness brightness, {
  HorizontDensity? density,
  TargetPlatform? platform,
  HorizontHost? host,
}) {
  final target = platform ?? defaultTargetPlatform;
  final resolvedDensity = density ?? HorizontDensity.forPlatform(target);
  final c = HorizontColors.resolve(product, brightness, host: host);
  final dark = brightness == Brightness.dark;
  final pointer = resolvedDensity == HorizontDensity.pointer;
  // Android shows its ripple; Apple platforms, Windows, Linux and the web
  // show no splash, only the press highlight below.
  final android =
      target == TargetPlatform.android || target == TargetPlatform.fuchsia;
  TextStyle t(HzTypeSpec spec, [Color? color]) =>
      horizontTextStyle(spec, color ?? c.text);

  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.accent,
    onPrimary: c.onAccent,
    primaryContainer: c.accentTint,
    onPrimaryContainer: c.accentText,
    secondary: c.accentText,
    onSecondary: c.onAccent,
    secondaryContainer: c.sunken,
    onSecondaryContainer: c.text,
    tertiary: c.info,
    onTertiary: c.surface,
    tertiaryContainer: c.infoTint,
    onTertiaryContainer: c.info,
    error: c.critical,
    onError: c.onCritical,
    errorContainer: c.criticalTint,
    onErrorContainer: c.critical,
    surface: c.bg,
    onSurface: c.text,
    onSurfaceVariant: c.textMuted,
    surfaceContainerLowest: c.surface,
    surfaceContainerLow: c.surface,
    surfaceContainer: c.sunken,
    surfaceContainerHigh: c.sunken,
    surfaceContainerHighest: c.line,
    outline: c.lineStrong,
    outlineVariant: c.line,
    shadow: Colors.transparent,
    scrim: c.text.withValues(alpha: 0.4),
    inverseSurface: c.text,
    onInverseSurface: c.bg,
    inversePrimary: product.dark.accent,
    surfaceTint: Colors.transparent,
  );

  final textTheme = TextTheme(
    displaySmall: t(HzType.display),
    headlineMedium: t(HzType.headline),
    titleLarge: t(HzType.title1),
    titleMedium: t(HzType.title2),
    titleSmall: t(HzType.title3),
    bodyLarge: t(HzType.body),
    bodyMedium: t(HzType.callout),
    bodySmall: t(HzType.caption, c.textMuted),
    labelLarge: t(HzType.label),
    labelMedium: t(HzType.label),
    labelSmall: t(HzType.caption),
  );

  final control = pointer ? HzSize.controlDesktop : HzSize.touch;
  const r6 = BorderRadius.all(Radius.circular(HzRadius.r6));
  const r10 = BorderRadius.all(Radius.circular(HzRadius.r10));
  // One outline for everything that has one (card, field, button, segment,
  // chip, dialog, sheet, menu): line-strong. `line` only separates rows and
  // sections.
  final hairline = BorderSide(color: c.line, width: HzLine.hairline);
  final outline = BorderSide(color: c.lineStrong, width: HzLine.hairline);
  final buttonText = t(HzType.label).copyWith(fontSize: pointer ? 13 : 15);
  final buttonPadding = EdgeInsets.symmetric(
    horizontal: pointer ? HzSpace.s12 : HzSpace.s16,
  );
  final buttonSize = WidgetStatePropertyAll(Size(0, control));
  // Fields are exactly the control height (28 with a pointer, 44 on touch),
  // whatever the font: the outline follows the text line plus the vertical
  // padding, not a minimum height (`constraints.minHeight` only grows the box
  // around the field). The line is the one of `data` (20), so Mono values and
  // body text ([fieldText]) give the same height; Flutter still subtracts the
  // visual density (compact: −8) from the content. Dense, or Material forces
  // 48 on touch.
  final visualDensity = pointer
      ? VisualDensity.compact
      : VisualDensity.standard;
  final fieldText = t(
    HzType.body,
  ).copyWith(height: HzType.data.line / HzType.body.size);
  final fieldIcons = BoxConstraints(minWidth: control, minHeight: control);
  final fieldDecoration = InputDecorationTheme(
    filled: true,
    fillColor: c.surface,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
      horizontal: HzSpace.s12,
      vertical:
          (control - HzType.data.line - visualDensity.baseSizeAdjustment.dy) /
          2,
    ),
    // Icons before and after the text no taller than the field (Material:
    // 40/48).
    prefixIconConstraints: fieldIcons,
    suffixIconConstraints: fieldIcons,
    labelStyle: t(HzType.label),
    floatingLabelStyle: t(HzType.label, c.accentText),
    helperStyle: t(HzType.caption, c.textMuted),
    errorStyle: t(HzType.caption, c.critical),
    // The line of the input, or the empty field is taller than a filled one.
    hintStyle: fieldText.copyWith(color: c.textFaint),
    border: OutlineInputBorder(
      borderRadius: r6,
      borderSide: BorderSide(color: c.lineStrong),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: r6,
      borderSide: BorderSide(color: c.lineStrong),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: r6,
      borderSide: BorderSide(color: c.accent, width: HzLine.focus),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: r6,
      borderSide: BorderSide(color: c.critical),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: r6,
      borderSide: BorderSide(color: c.critical, width: HzLine.focus),
    ),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    textTheme: textTheme,
    fontFamily: HzFont.sans,
    package: HzFont.package,
    scaffoldBackgroundColor: c.bg,
    canvasColor: c.bg,
    dividerColor: c.line,
    platform: platform,
    visualDensity: visualDensity,
    materialTapTargetSize: pointer
        ? MaterialTapTargetSize.shrinkWrap
        : MaterialTapTargetSize.padded,
    splashFactory: android ? InkSparkle.splashFactory : NoSplash.splashFactory,
    highlightColor: android
        ? null
        : c.text.withValues(alpha: dark ? 0.10 : 0.06),
    hoverColor: c.text.withValues(alpha: dark ? 0.06 : 0.04),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    adaptations: [_CupertinoSwitch(c.accent)],
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
      brightness: brightness,
      primaryColor: c.accent,
      primaryContrastingColor: c.onAccent,
      barBackgroundColor: c.surface,
      scaffoldBackgroundColor: c.bg,
    ),
    iconTheme: IconThemeData(color: c.text, size: HzIconSize.bar, weight: 300),
    // Back, close and the drawer in Horizont's symbols, not Material's font:
    // BackButton and CloseButton stay adaptive (a chevron on Apple platforms).
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) => Icon(horizontBackSymbol(Theme.of(context).platform)),
      closeButtonIconBuilder: (context) => const Icon(HorizontSymbols.close),
      drawerButtonIconBuilder: (context) => const Icon(HorizontSymbols.menu),
      endDrawerButtonIconBuilder: (context) => const Icon(HorizontSymbols.menu),
    ),
    extensions: [
      HorizontTheme(
        product: product,
        brightness: brightness,
        density: resolvedDensity,
        colors: c,
        data: t(HzType.data),
        kennung: t(HzType.kennung, c.textMuted),
        reading: t(HzType.reading),
        display: t(HzType.display),
        field: fieldText,
      ),
    ],
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      foregroundColor: c.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      // Left, under a Kennung, on every platform: decided for Horizont
      // (regetskcob/horizont#1), also where iOS would centre it.
      centerTitle: false,
      toolbarHeight: pointer ? HzSize.toolbarDesktop : 56,
      titleTextStyle: t(HzType.title1),
      actionsIconTheme: IconThemeData(
        color: c.accentText,
        size: HzIconSize.bar,
      ),
      shape: Border(bottom: hairline),
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: r10, side: outline),
    ),
    dividerTheme: DividerThemeData(
      color: c.line,
      thickness: HzLine.hairline,
      space: HzLine.hairline,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: HzSpace.s16),
      minVerticalPadding: pointer ? HzSpace.s4 : HzSpace.s8,
      minTileHeight: pointer ? HzSize.rowDense : HzSize.row,
      dense: pointer,
      iconColor: c.textMuted,
      textColor: c.text,
      titleTextStyle: t(HzType.body),
      subtitleTextStyle: t(
        HzType.data,
        c.textMuted,
      ).copyWith(fontSize: HzType.caption.size, height: HzType.caption.line / HzType.caption.size),
      selectedColor: c.text,
      selectedTileColor: c.accentTint,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled) ? c.sunken : c.accent,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled) ? c.textFaint : c.onAccent,
        ),
        textStyle: WidgetStatePropertyAll(buttonText),
        minimumSize: buttonSize,
        // The size is already the density's control height (28 with a
        // pointer); compact visual density must not shrink it further.
        visualDensity: VisualDensity.standard,
        padding: WidgetStatePropertyAll(buttonPadding),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: r6),
        ),
        elevation: const WidgetStatePropertyAll(0),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(c.text),
        textStyle: WidgetStatePropertyAll(buttonText),
        minimumSize: buttonSize,
        // The size is already the density's control height (28 with a
        // pointer); compact visual density must not shrink it further.
        visualDensity: VisualDensity.standard,
        padding: WidgetStatePropertyAll(buttonPadding),
        side: WidgetStatePropertyAll(BorderSide(color: c.lineStrong)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: r6),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(c.accentText),
        textStyle: WidgetStatePropertyAll(buttonText),
        minimumSize: buttonSize,
        // The size is already the density's control height (28 with a
        // pointer); compact visual density must not shrink it further.
        visualDensity: VisualDensity.standard,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: HzSpace.s8),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: r6),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(c.accentText),
        minimumSize: WidgetStatePropertyAll(
          Size.square(pointer ? HzSize.controlDesktop : HzSize.touch),
        ),
        visualDensity: VisualDensity.standard,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: c.accent,
      foregroundColor: c.onAccent,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      extendedTextStyle: buttonText,
      shape: const RoundedRectangleBorder(borderRadius: r10),
    ),
    inputDecorationTheme: fieldDecoration,
    // DropdownMenu brings its own field theme; without these it would be
    // taller than the other fields and set in bodyLarge (16/24).
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: fieldText,
      inputDecorationTheme: fieldDecoration,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: c.sunken,
      selectedColor: c.accentTint,
      labelStyle: t(HzType.label),
      side: outline,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(HzRadius.r2)),
      ),
      showCheckmark: false,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: c.text,
      unselectedLabelColor: c.textMuted,
      labelStyle: t(HzType.label),
      unselectedLabelStyle: t(HzType.label),
      dividerColor: c.line,
      dividerHeight: HzLine.hairline,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: c.accent, width: HzLine.selection),
      ),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? c.accentTint
              : Colors.transparent,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.text : c.textMuted,
        ),
        textStyle: WidgetStatePropertyAll(t(HzType.label)),
        side: WidgetStatePropertyAll(BorderSide(color: c.lineStrong)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: r6),
        ),
        minimumSize: WidgetStatePropertyAll(Size(0, pointer ? 24 : 36)),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? c.onAccent : c.surface,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? c.accent : c.lineStrong,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? c.accent : Colors.transparent,
      ),
      checkColor: WidgetStatePropertyAll(c.onAccent),
      side: BorderSide(color: c.lineStrong, width: HzLine.hairline),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(HzRadius.r2)),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: c.accent,
      linearTrackColor: c.line,
      circularTrackColor: c.line,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: r10, side: outline),
      titleTextStyle: t(HzType.title2),
      contentTextStyle: t(HzType.body),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.surface,
      elevation: 0,
      modalElevation: 0,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: c.lineStrong,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(HzRadius.r16),
        ),
        side: outline,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: c.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      textStyle: t(HzType.body),
      shape: RoundedRectangleBorder(borderRadius: r10, side: outline),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.text,
      contentTextStyle: t(HzType.callout, c.bg),
      actionTextColor: c.bg,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: r6),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: c.text,
        borderRadius: const BorderRadius.all(Radius.circular(HzRadius.r2)),
      ),
      textStyle: t(HzType.caption, c.bg),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(c.lineStrong),
      radius: const Radius.circular(HzRadius.r2),
    ),
  );
}

/// `Switch.adaptive` on Apple platforms: the native switch with its white
/// thumb, the track in the product's accent instead of system green.
class _CupertinoSwitch extends Adaptation<SwitchThemeData> {
  const _CupertinoSwitch(this.accent);

  final Color accent;

  @override
  SwitchThemeData adapt(ThemeData theme, SwitchThemeData defaultValue) =>
      switch (theme.platform) {
        TargetPlatform.iOS || TargetPlatform.macOS => SwitchThemeData(
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? accent : null,
          ),
          thumbColor: const WidgetStatePropertyAll(CupertinoColors.white),
        ),
        _ => defaultValue,
      };
}

/// The back symbol of [platform]: a chevron on iOS and macOS, an arrow
/// elsewhere, both from Horizont's symbols. `BackButton` uses it through the
/// theme; take it for your own back buttons instead of `Icons.adaptive`.
IconData horizontBackSymbol(TargetPlatform platform) => switch (platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => HorizontSymbols.chevronLeft,
      _ => HorizontSymbols.arrowBack,
    };

/// The "more" symbol of [platform]: three dots in a row on iOS and macOS,
/// in a column elsewhere. Instead of `Icons.adaptive.more`.
IconData horizontMoreSymbol(TargetPlatform platform) => switch (platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => HorizontSymbols.moreHoriz,
      _ => HorizontSymbols.moreVert,
    };

/// The share symbol of [platform]: the box with the arrow on iOS and macOS,
/// the three linked dots elsewhere. Instead of `Icons.adaptive.share`.
IconData horizontShareSymbol(TargetPlatform platform) => switch (platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => HorizontSymbols.iosShare,
      _ => HorizontSymbols.share,
    };
