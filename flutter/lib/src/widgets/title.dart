import 'package:flutter/material.dart';

import '../horizont_theme.dart';
import '../tokens.g.dart';
import 'kennung.dart';

/// The head of a page or sheet: a [Kennung] that says what kind of thing
/// this is or where it lies, over a small title in `titleLarge`. Horizont
/// uses it instead of the large iOS title, on every platform: as the
/// `AppBar` title, at the top of a scrolling page and at the top of a sheet.
///
/// ```dart
/// AppBar(title: HorizontTitle(kennung: 'Hegering Nord · 412 ha', title: l10n.facilities))
/// ```
class HorizontTitle extends StatelessWidget {
  /// Creates a head with [kennung] over [title].
  const HorizontTitle({
    required this.kennung,
    required this.title,
    this.below,
    this.count,
    this.style,
    super.key,
  });

  /// The title's style; `titleLarge` by default, `titleMedium` in a sheet.
  final TextStyle? style;

  /// The Kennung, in normal case.
  final String kennung;

  /// An optional count after the Kennung (`EINRICHTUNGEN · 14`).
  final int? count;

  /// The title.
  final String title;

  /// A quiet control or line under the title (a place, a filter).
  final Widget? below;

  /// The `AppBar.toolbarHeight` that holds a [HorizontTitle] (without
  /// [below]): Kennung and title at the current text size with 8 above and
  /// below, at least the bar's usual height. Without it, large text is cut.
  static double toolbarHeight(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final pointer = HorizontTheme.of(context).density == HorizontDensity.pointer;
    final content = scaler.scale(HzType.kennung.line) + scaler.scale(HzType.title1.line) + 2 * HzSpace.s8;
    final usual = pointer ? HzSize.toolbarDesktop : 56.0;
    return content > usual ? content : usual;
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = style ?? Theme.of(context).textTheme.titleLarge;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Wraps at large text sizes: a date or place in the Kennung is
        // content, nothing is cut.
        Kennung(kennung, count: count),
        Semantics(
          header: true,
          child: Text(title, style: titleStyle),
        ),
        ?below,
      ],
    );
  }
}
