import 'package:flutter/material.dart';

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
    super.key,
  });

  /// The Kennung, in normal case.
  final String kennung;

  /// An optional count after the Kennung (`EINRICHTUNGEN · 14`).
  final int? count;

  /// The title.
  final String title;

  /// A quiet control or line under the title (a place, a filter).
  final Widget? below;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleLarge;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Kennung(kennung, count: count, oneLine: true),
        Semantics(
          header: true,
          child: Text(title, style: style),
        ),
        ?below,
      ],
    );
  }
}
