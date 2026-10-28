/// Horizont, the design system of regetskcob, Jagdaufseher, KNX Monitor and
/// Panzergefecht: minimalist like the fields of the Lower Rhine.
///
/// Build the theme with [buildHorizontTheme] for light and dark, read it
/// with [HorizontTheme.of], call [registerHorizontLicenses] in `main()`.
/// Tests load the fonts with `loadHorizontFonts` from
/// `package:horizont/testing.dart`.
/// Rules and the reasoning behind them: CLAUDE.md and docs/flutter.md in
/// https://github.com/regetskcob/horizont.
library;

export 'src/colors.dart';
export 'src/horizont_theme.dart';
export 'src/licenses.dart';
export 'src/theme.dart';
export 'src/tokens.g.dart'
    show
        HorizontHost,
        HorizontProduct,
        HorizontSymbols,
        HzBreakpoint,
        HzColors,
        HzFont,
        HzIconSize,
        HzLine,
        HzMotion,
        HzRadius,
        HzScrim,
        HzSize,
        HzSpace,
        HzTv,
        HzType,
        HzTypeSpec,
        horizontTokensVersion;
export 'src/widgets/actions.dart';
export 'src/widgets/facts.dart';
export 'src/widgets/field.dart';
export 'src/widgets/hints.dart';
export 'src/widgets/kennung.dart';
export 'src/widgets/mark.dart';
export 'src/widgets/metric.dart';
export 'src/widgets/navigation.dart';
export 'src/widgets/selection.dart';
export 'src/widgets/status.dart';
export 'src/widgets/title.dart';
