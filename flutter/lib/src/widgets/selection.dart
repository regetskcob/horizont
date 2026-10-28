import 'package:flutter/material.dart';

import '../colors.dart';
import '../horizont_theme.dart';
import '../tokens.g.dart';

/// Where the selection line of a [HorizontSelectable] sits: at the start of
/// a row (lists, trees, sidebars) or under an item (tabs, segments, tiles in
/// a row).
enum HorizontSelectionEdge {
  /// 2 px at the start: the chosen row.
  start,

  /// 2 px at the bottom: the chosen tab or segment.
  bottom,
}

/// The selection as Horizont draws it: `accent-tint` behind, 2 px of the
/// accent at the start (or bottom), never a pill. Unselected the line is
/// there too, transparent, so rows do not shift when chosen.
///
/// [selected] goes to screen readers too; the tint is not the only signal.
BoxDecoration horizontSelectionDecoration(
  HorizontColors colors, {
  required bool selected,
  HorizontSelectionEdge edge = HorizontSelectionEdge.start,
}) {
  final line = BorderSide(
    color: selected ? colors.accent : Colors.transparent,
    width: HzLine.selection,
  );
  return BoxDecoration(
    color: selected ? colors.accentTint : null,
    border: switch (edge) {
      HorizontSelectionEdge.start => BorderDirectional(start: line),
      HorizontSelectionEdge.bottom => BorderDirectional(bottom: line),
    },
  );
}

/// A row, tile or tab that can be chosen: [horizontSelectionDecoration]
/// with an ink response, at least [minHeight] high (the touch target by
/// default, the dense row with a pointer).
///
/// ```dart
/// HorizontSelectable(
///   selected: line == current,
///   onTap: () => select(line),
///   child: Text(line.name),
/// )
/// ```
class HorizontSelectable extends StatelessWidget {
  /// Creates a choosable [child].
  const HorizontSelectable({
    required this.selected,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.edge = HorizontSelectionEdge.start,
    this.padding = const EdgeInsetsDirectional.symmetric(horizontal: HzSpace.s12, vertical: HzSpace.s4),
    this.minHeight,
    this.semanticsLabel,
    super.key,
  });

  /// Whether this one is chosen.
  final bool selected;

  /// What is shown.
  final Widget child;

  /// Chooses it.
  final VoidCallback? onTap;

  /// A secondary function, as a long press (or right click) elsewhere.
  final VoidCallback? onLongPress;

  /// Where the line sits.
  final HorizontSelectionEdge edge;

  /// Space inside, after the line.
  final EdgeInsetsGeometry padding;

  /// Overrides the minimum height (default: 44 on touch, 28 with a pointer).
  final double? minHeight;

  /// Replaces the child's own semantics with one label.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final height = minHeight ?? (theme.density == HorizontDensity.pointer ? HzSize.rowDense : HzSize.touch);
    return Semantics(
      button: onTap != null,
      selected: selected,
      label: semanticsLabel,
      excludeSemantics: semanticsLabel != null,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          // Ink, not a plain decoration: the tint lies on the Material, so the
          // ripple (also that of a ListTile inside) shows above it.
          child: Ink(
            decoration: horizontSelectionDecoration(theme.colors, selected: selected, edge: edge),
            child: Container(
              constraints: BoxConstraints(minHeight: height),
              alignment: AlignmentDirectional.centerStart,
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
