import 'package:flutter/material.dart';

import '../horizont_theme.dart';
import '../tokens.g.dart';
import 'kennung.dart';

/// A fact: the term as a [Kennung] in a column of fixed width
/// ([HzSize.factTerm], growing with the text size), the value beside it,
/// both on one baseline, so that facts under each other start in one place
/// in every sheet, inspector and page. The web has the same as `.hz-facts`.
///
/// What is measured (dates, counts, addresses, coordinates) is [measured]
/// and goes in Monaspace with tabular figures; what is named goes in the
/// callout of Mona Sans, the same size. When the room is narrower than the
/// term column plus 128, the value moves under the term.
///
/// With [onTap] the value leads somewhere: accent text and an arrow, or the
/// "opens outside" symbol when [external]. Colour alone would not say it.
///
/// ```dart
/// HorizontFact(term: l10n.address, value: '1.1.12', measured: true)
/// ```
class HorizontFact extends StatelessWidget {
  /// Creates a fact of [term] and [value], or of [term] and [child].
  const HorizontFact({
    required this.term,
    this.value,
    this.child,
    this.measured = false,
    this.selectable = false,
    this.onTap,
    this.external = false,
    this.padding = const EdgeInsets.symmetric(vertical: HzSpace.s4),
    super.key,
  }) : assert((value == null) != (child == null), 'Pass either value or child.');

  /// The term, in normal case; the Kennung sets it in capitals.
  final String term;

  /// The value as text.
  final String? value;

  /// The value as a widget, e.g. a badge or a status line.
  final Widget? child;

  /// Whether the value is measured rather than named (Monaspace).
  final bool measured;

  /// Whether the value can be selected and copied (ids, addresses).
  final bool selectable;

  /// Where the value leads.
  final VoidCallback? onTap;

  /// Whether [onTap] leaves the app (a link): the arrow becomes `open_in_new`.
  final bool external;

  /// Space around the row.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final c = theme.colors;
    final fg = onTap == null ? c.text : c.accentText;
    final style = (measured ? theme.data : horizontTextStyle(HzType.callout, c.text)).copyWith(color: fg);
    Widget valueWidget = child != null
        // A badge or line keeps its own width instead of filling the column.
        ? Align(alignment: AlignmentDirectional.centerStart, child: child)
        : (selectable && onTap == null ? SelectableText(value!, style: style) : Text(value!, style: style));
    if (onTap != null) {
      // The arrow at the end of the row, so arrows under each other line up
      // whether the value is short or wraps.
      valueWidget = Row(
        children: [
          Expanded(child: valueWidget),
          const SizedBox(width: HzSpace.s4),
          ExcludeSemantics(
            child: Icon(
              external ? HorizontSymbols.openInNew : HorizontSymbols.chevronRight,
              size: HzIconSize.inline,
              color: c.accentText,
            ),
          ),
        ],
      );
    }
    final termWidth = MediaQuery.textScalerOf(context).scale(HzSize.factTerm);
    final row = Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) => constraints.maxWidth < termWidth + HzSpace.s96 + HzSpace.s32
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Kennung(term),
                  const SizedBox(height: HzSpace.s2),
                  valueWidget,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(width: termWidth, child: Kennung(term)),
                  Expanded(child: valueWidget),
                ],
              ),
      ),
    );
    if (onTap == null) return row;
    return Semantics(
      link: external,
      button: !external,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(HzRadius.r6)),
        child: row,
      ),
    );
  }
}
