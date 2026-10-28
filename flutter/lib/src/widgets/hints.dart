import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../horizont_theme.dart';
import '../tokens.g.dart';
import 'status.dart';

/// A state in running text: glyph and words in the state's colour, no
/// background (`✓ Verbunden mit 192.168.1.10`). For a state that stands on
/// its own, use [HorizontBadge]; for a warning before an action, a hint row
/// on the tint.
class HorizontStatusLine extends StatelessWidget {
  /// Creates a line for [status] with [text].
  const HorizontStatusLine(this.status, this.text, {super.key});

  /// The state; [HorizontStatus.neutral] is muted text.
  final HorizontStatus status;

  /// The words, from the app's localisations; they name the state.
  final String text;

  @override
  Widget build(BuildContext context) {
    final fg = status.color(HorizontTheme.of(context).colors);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // Centres the glyph on the first line (callout 14/20).
          padding: const EdgeInsets.only(top: HzSpace.s2),
          child: ExcludeSemantics(
            child: Icon(status.icon, size: HzIconSize.inline, color: fg),
          ),
        ),
        const SizedBox(width: HzSpace.s4),
        Flexible(
          child: Text(text, style: horizontTextStyle(HzType.callout, fg)),
        ),
      ],
    );
  }
}

/// A short code as a square mark (`W`, `R`, `A`): one or two letters in
/// Monaspace on the tint of [status] (or of the accent when null), radius 2.
/// It grows with the text size. With [outlined] it has a hairline in the
/// colour instead of the tint (e.g. „sent by me“). Never colour alone: the
/// letter is the meaning, [semanticLabel] says it in words.
class HorizontLetterBadge extends StatelessWidget {
  /// Creates a mark for [letter].
  const HorizontLetterBadge(
    this.letter, {
    required this.semanticLabel,
    this.status,
    this.outlined = false,
    this.size = 24,
    super.key,
  });

  /// One or two letters.
  final String letter;

  /// What the letter means, for screen readers and the tooltip.
  final String semanticLabel;

  /// The state whose colours it takes; null for the accent.
  final HorizontStatus? status;

  /// Hairline instead of tint.
  final bool outlined;

  /// Edge length at text scale 1.
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final c = theme.colors;
    final fg = status?.color(c) ?? c.accentText;
    final bg = status?.tint(c) ?? c.accentTint;
    final edge = MediaQuery.textScalerOf(context).scale(size);
    return Tooltip(
      message: semanticLabel,
      child: Semantics(
        label: semanticLabel,
        excludeSemantics: true,
        child: Container(
          width: edge,
          height: edge,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: outlined ? null : bg,
            border: outlined
                ? Border.all(color: fg, width: HzLine.hairline)
                : null,
            borderRadius: const BorderRadius.all(Radius.circular(HzRadius.r2)),
          ),
          child: Text(
            letter,
            style: theme.data.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

/// What an empty view says: a faint glyph, one sentence, an optional
/// explanation in muted text and the obvious next action. Centred, at most
/// as wide as a form ([HzSize.form]).
///
/// With [status] it says what went wrong or is missing (no connection, no
/// data from the source): the glyph in the state's colour, by default the
/// state's own glyph, and the action is the way out, typically „Erneut
/// versuchen“.
class HorizontEmptyHint extends StatelessWidget {
  /// Creates a hint with [text].
  const HorizontEmptyHint({
    required this.text,
    this.icon,
    this.status,
    this.detail,
    this.action,
    super.key,
  }) : assert(icon != null || status != null, 'Pass an icon or a status.');

  /// What is (not) there, one sentence.
  final String text;

  /// The glyph, decorative; defaults to the glyph of [status].
  final IconData? icon;

  /// The state, for failures and gaps; null for a plain empty view.
  final HorizontStatus? status;

  /// What one can do about it.
  final String? detail;

  /// The obvious next action as a `FilledButton`; it is the view's primary
  /// action, so there is no other one.
  final ({String label, VoidCallback onPressed})? action;

  @override
  Widget build(BuildContext context) {
    final c = HorizontTheme.of(context).colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HzSpace.s24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: HzSize.form),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Icon(
                  icon ?? status!.icon,
                  size: HzSpace.s32,
                  color: status?.color(c) ?? c.textFaint,
                ),
              ),
              const SizedBox(height: HzSpace.s8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: horizontTextStyle(HzType.body, c.text),
              ),
              if (detail != null) ...[
                const SizedBox(height: HzSpace.s4),
                Text(
                  detail!,
                  textAlign: TextAlign.center,
                  style: horizontTextStyle(HzType.callout, c.textMuted),
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: HzSpace.s16),
                FilledButton(
                  onPressed: action!.onPressed,
                  child: Text(action!.label),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A button for `showAdaptiveDialog`: on iOS and macOS a
/// `CupertinoDialogAction` (bold when [primary], red when [destructive]),
/// elsewhere a `TextButton`, or a `FilledButton` for the [primary] one, in
/// `critical` with `onCritical` when it is also [destructive].
///
/// ```dart
/// showAdaptiveDialog<bool>(
///   context: context,
///   builder: (context) => AlertDialog.adaptive(
///     title: Text(l10n.replayTitle),
///     content: Text(l10n.replayCannotUndo),
///     actions: [
///       horizontDialogAction(context, label: l10n.cancel,
///           onPressed: () => Navigator.pop(context, false)),
///       horizontDialogAction(context, label: l10n.send, primary: true,
///           destructive: true, onPressed: () => Navigator.pop(context, true)),
///     ],
///   ),
/// );
/// ```
Widget horizontDialogAction(
  BuildContext context, {
  required String label,
  required VoidCallback onPressed,
  bool primary = false,
  bool destructive = false,
}) {
  final theme = HorizontTheme.of(context);
  return switch (Theme.of(context).platform) {
    TargetPlatform.iOS || TargetPlatform.macOS => CupertinoDialogAction(
      onPressed: onPressed,
      isDefaultAction: primary,
      isDestructiveAction: destructive,
      child: Text(label),
    ),
    _ when primary => FilledButton(
      style: destructive ? theme.criticalButton : null,
      onPressed: onPressed,
      child: Text(label),
    ),
    _ when destructive => TextButton(
      style: TextButton.styleFrom(foregroundColor: theme.colors.critical),
      onPressed: onPressed,
      child: Text(label),
    ),
    _ => TextButton(onPressed: onPressed, child: Text(label)),
  };
}

/// A note before an action or about the situation: the state's tint as
/// ground, its glyph in the state's colour, the words in ink, radius 6 like
/// the buttons beside it (e.g. the warning before an irreversible action).
/// Not a badge: it says a sentence, not a state.
class HorizontNotice extends StatelessWidget {
  /// Creates a note in [status] with [child], usually a `Text`.
  const HorizontNotice(
    this.status, {
    required this.child,
    this.icon,
    super.key,
  });

  /// The state whose tint and glyph it takes.
  final HorizontStatus status;

  /// The words.
  final Widget child;

  /// A glyph of the app's own instead of the state's.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = HorizontTheme.of(context).colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: status.tint(c),
        borderRadius: const BorderRadius.all(Radius.circular(HzRadius.r6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(HzSpace.s12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Icon(
                icon ?? status.icon,
                size: HzIconSize.row,
                color: status.color(c),
              ),
            ),
            const SizedBox(width: HzSpace.s12),
            Expanded(
              child: DefaultTextStyle.merge(
                style: horizontTextStyle(HzType.callout, c.text),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
