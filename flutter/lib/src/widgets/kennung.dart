import 'package:flutter/material.dart';

import '../horizont_theme.dart';
import '../tokens.g.dart';

/// The separator between a Kennung and its count or between meta values:
/// `EINRICHTUNGEN · 14`.
const String horizontMetaSeparator = ' · ';

/// A Kennung: small mono capitals that name a section, an id or a place,
/// e.g. `REVIER BUCHENHAIN · 412,5 HA`. Pass the text as written; the widget
/// sets it in capitals, so translations stay in normal case.
///
/// With [count] it reads `EINRICHTUNGEN · 14`. With [oneLine] it stays on
/// one line: the term ends in „…“ when the room runs out, the count stays
/// visible. Use that in narrow section heads, not for running text.
class Kennung extends StatelessWidget {
  /// Creates a Kennung for [text].
  const Kennung(
    this.text, {
    this.count,
    this.oneLine = false,
    this.color,
    super.key,
  });

  /// The text, in normal case.
  final String text;

  /// An optional count after the term.
  final int? count;

  /// Whether the term is cut to one line with „…“ (the count never is).
  final bool oneLine;

  /// Overrides the muted text colour, e.g. with `accentText`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = HorizontTheme.of(context).kennung;
    final style = color == null ? base : base.copyWith(color: color);
    final suffix = count == null ? '' : '$horizontMetaSeparator$count';
    if (!oneLine) {
      return Text(
        '${text.toUpperCase()}$suffix',
        style: style,
        semanticsLabel: '$text$suffix',
      );
    }
    return Semantics(
      label: '$text$suffix',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                text.toUpperCase(),
                style: style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (count != null) Text(suffix, style: style),
          ],
        ),
      ),
    );
  }
}

/// The head of a section in a list or board: a one-line [Kennung] with
/// [count] at the start, quiet actions ([trailing], e.g. `TextButton`
/// „Alle“ or icon buttons) at the end. No background, no line: white space
/// separates.
///
/// With [onToggle] the section folds: the whole head is the button (at least
/// 44 high on touch), `expand_more` when folded and `expand_less` when open
/// at the end, [collapsed] goes to screen readers as expanded or not. Trees
/// disclose differently: `chevron_right` folded, `expand_more` open, at the
/// start of the row.
class HorizontSectionHeader extends StatelessWidget {
  /// Creates a section head for [title].
  const HorizontSectionHeader(
    this.title, {
    this.count,
    this.trailing,
    this.collapsed = false,
    this.onToggle,
    this.padding = const EdgeInsetsDirectional.fromSTEB(
      HzSpace.s16,
      HzSpace.s16,
      HzSpace.s16,
      HzSpace.s8,
    ),
    super.key,
  });

  /// The section's name, in normal case.
  final String title;

  /// Number of entries in the section.
  final int? count;

  /// Quiet actions at the end.
  final Widget? trailing;

  /// Whether the section is folded; only with [onToggle].
  final bool collapsed;

  /// Folds or unfolds the section; null for a head that does not fold.
  final VoidCallback? onToggle;

  /// Space around the head; by default the gutter of a phone (16) and
  /// 16 above, 8 below.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final head = Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(child: Kennung(title, count: count, oneLine: true)),
          ?trailing,
          if (onToggle != null)
            ExcludeSemantics(
              child: Icon(
                collapsed ? HorizontSymbols.expandMore : HorizontSymbols.expandLess,
                size: HzIconSize.row,
                color: HorizontTheme.of(context).colors.textMuted,
              ),
            ),
        ],
      ),
    );
    if (onToggle == null) return head;
    final pointer = HorizontTheme.of(context).density == HorizontDensity.pointer;
    return Semantics(
      button: true,
      expanded: !collapsed,
      child: InkWell(
        onTap: onToggle,
        // A head that folds is a button: at least the touch target high.
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: pointer ? HzSize.rowDense : HzSize.touch),
          child: Align(alignment: AlignmentDirectional.bottomStart, child: head),
        ),
      ),
    );
  }
}
