import 'package:flutter/widgets.dart';

import '../colors.dart';
import '../horizont_theme.dart';
import '../tokens.g.dart';

/// The states Horizont knows. Each carries a glyph and a colour; the word
/// comes from the app (l10n). Colour is derived last and never the only
/// signal.
enum HorizontStatus {
  /// Good, done, connected: a check.
  positive,

  /// Check, attention: a triangle.
  warning,

  /// Broken, error: an octagon.
  critical,

  /// Note, information: a circle with i.
  info,

  /// Unknown or neutral: a dot.
  neutral;

  /// The glyph of this state.
  IconData get icon => switch (this) {
        HorizontStatus.positive => HorizontSymbols.checkCircle,
        HorizontStatus.warning => HorizontSymbols.warning,
        HorizontStatus.critical => HorizontSymbols.report,
        HorizontStatus.info => HorizontSymbols.info,
        HorizontStatus.neutral => HorizontSymbols.circle,
      };

  /// The foreground colour of this state.
  Color color(HorizontColors c) => switch (this) {
        HorizontStatus.positive => c.positive,
        HorizontStatus.warning => c.warning,
        HorizontStatus.critical => c.critical,
        HorizontStatus.info => c.info,
        HorizontStatus.neutral => c.textMuted,
      };

  /// The background colour of this state.
  Color tint(HorizontColors c) => switch (this) {
        HorizontStatus.positive => c.positiveTint,
        HorizontStatus.warning => c.warningTint,
        HorizontStatus.critical => c.criticalTint,
        HorizontStatus.info => c.infoTint,
        HorizontStatus.neutral => c.sunken,
      };
}

/// A status: glyph, word and colour on its tint, radius 2.
///
/// ```dart
/// HorizontBadge(HorizontStatus.warning, label: l10n.facilityCheck)
/// ```
class HorizontBadge extends StatelessWidget {
  /// Creates a badge for [status] with the word [label].
  const HorizontBadge(this.status, {required this.label, super.key});

  /// The state.
  final HorizontStatus status;

  /// The word for the state, from the app's localisations.
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final fg = status.color(theme.colors);
    return Semantics(
      container: true,
      label: label,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: status.tint(theme.colors),
            borderRadius: const BorderRadius.all(Radius.circular(HzRadius.r2)),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(HzSpace.s4, HzSpace.s2, HzSpace.s8, HzSpace.s2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(status.icon, size: HzIconSize.badge, color: fg),
                const SizedBox(width: HzSpace.s4),
                // Caption size in the label's weight, as `.hz-badge` on the web.
                Flexible(
                  child: Text(label, style: horizontTextStyle(HzType.caption, fg).copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
