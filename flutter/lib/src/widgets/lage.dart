import 'package:flutter/material.dart';

import '../horizont_theme.dart';
import '../tokens.g.dart';
import 'status.dart';

/// The horizon under the head of a view: a 2 px line whose left part stands
/// in the accent for [value] (0 to 1). It carries one state of the view: the
/// share read, the progress through a text, how much fits a budget. It takes
/// the place of the hairline under an `AppBar`:
///
/// ```dart
/// AppBar(title: …, bottom: HorizontHorizon(value: read / total))
/// ```
///
/// The line is decoration for the eye; say the same in words nearby (the
/// Kennung, a [HorizontLage]) or pass a [semanticsLabel].
class HorizontHorizon extends StatelessWidget implements PreferredSizeWidget {
  /// Creates the line.
  const HorizontHorizon({required this.value, this.semanticsLabel, super.key});

  /// The share in the accent, 0 to 1.
  final double value;

  /// What the share means, for screen readers; without it the line is
  /// hidden from them.
  final String? semanticsLabel;

  @override
  Size get preferredSize => const Size.fromHeight(HzLine.selection);

  @override
  Widget build(BuildContext context) {
    final c = HorizontTheme.of(context).colors;
    final still = MediaQuery.disableAnimationsOf(context);
    final line = SizedBox(
      width: double.infinity,
      height: HzLine.selection,
      child: ColoredBox(
        color: c.line,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: value.clamp(0.0, 1.0)),
          duration: still ? Duration.zero : HzMotion.calm,
          curve: HzMotion.settle,
          builder: (context, v, _) => Align(
            alignment: AlignmentDirectional.centerStart,
            child: FractionallySizedBox(widthFactor: v, heightFactor: 1, child: ColoredBox(color: c.accent)),
          ),
        ),
      ),
    );
    return semanticsLabel == null
        ? ExcludeSemantics(child: line)
        : Semantics(label: semanticsLabel, value: '${(value.clamp(0.0, 1.0) * 100).round()} %', child: ExcludeSemantics(child: line));
  }
}

/// The line directly under the head that says how current a view is:
/// "Aktuell · abgeglichen 08:12", "Wird abgeglichen …", "Kein Empfang.
/// Stand 08:12". It replaces the spinner in the bar and the message that is
/// gone after four seconds. Quiet in muted text while all is well, on the
/// tint of its [status] when something is off (warning, critical). The
/// words come from the app and name the state; the sign is [icon] or the
/// one of the status.
///
/// A view never blocks on the network: it keeps showing what it has, and
/// this line says from when that is.
class HorizontLage extends StatelessWidget {
  /// Creates the line with [text].
  const HorizontLage(this.text, {this.status = HorizontStatus.neutral, this.icon, this.trailing, super.key});

  /// The words; they name the state and, when stale, its time.
  final String text;

  /// How the state reads: neutral while working, positive when current,
  /// warning or critical when something is off.
  final HorizontStatus status;

  /// The sign; defaults to the one of [status].
  final IconData? icon;

  /// A control at the end with its word, e.g. a filter as a `TextButton`.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final h = HorizontTheme.of(context);
    final c = h.colors;
    final pointer = h.density == HorizontDensity.pointer;
    final off = status == HorizontStatus.warning || status == HorizontStatus.critical;
    return ColoredBox(
      color: off ? status.tint(c) : c.bg,
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: HzSpace.s16, end: trailing == null ? HzSpace.s16 : HzSpace.s4),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: pointer ? HzSize.rowDense : HzSize.touch),
          child: Row(children: [
            Icon(icon ?? status.icon, size: HzIconSize.row, color: status.color(c)),
            const SizedBox(width: HzSpace.s8),
            Expanded(
              child: Semantics(
                liveRegion: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: HzSpace.s8),
                  child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: off ? c.text : c.textMuted)),
                ),
              ),
            ),
            ?trailing,
          ]),
        ),
      ),
    );
  }
}

/// The dot of something new or unread, in the accent. Never alone: the row
/// also changes weight or carries a word, and says "unread" to a screen
/// reader itself.
class HorizontDot extends StatelessWidget {
  /// Creates the dot.
  const HorizontDot({this.size = 8, super.key});

  /// Its diameter.
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(color: HorizontTheme.of(context).colors.accent, shape: BoxShape.circle),
          child: SizedBox.square(dimension: size),
        ),
      );
}
