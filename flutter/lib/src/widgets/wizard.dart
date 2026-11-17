import 'package:flutter/material.dart';

import '../horizont_theme.dart';
import '../theme.dart';
import '../tokens.g.dart';
import 'hints.dart';
import 'kennung.dart';
import 'status.dart';

/// One step of a [HorizontWizard]. The owner builds the steps from its own
/// state on every build, so a step's [content] and [canContinue] follow
/// what was entered.
@immutable
class HorizontWizardStep {
  /// Creates a step.
  const HorizontWizardStep({
    required this.title,
    required this.content,
    this.subtitle,
    this.canContinue = true,
    this.onContinue,
    this.continueLabel,
    this.canGoBack = true,
  });

  /// The name of the step, in the list of steps and above its content.
  final String title;

  /// One sentence on what the step is for.
  final String? subtitle;

  /// What the step asks.
  final Widget content;

  /// Whether the main button is enabled (everything required is there).
  final bool canContinue;

  /// Runs on the main button before the wizard moves on and returns a
  /// message to show instead of moving on, or null. On the last step it is
  /// the finish, after which the wizard closes with `true`.
  final Future<String?> Function()? onContinue;

  /// The word of the main button; by default „Weiter“, on the last step the
  /// wizard's `finishLabel`.
  final String? continueLabel;

  /// False after a step that cannot be undone (something was created):
  /// neither „Zurück“ nor the list of steps leads before it.
  final bool canGoBack;
}

/// A task in a few steps that creates something (a product, a channel, a
/// plan); editing stays a form. Open it with [showHorizontWizard].
///
/// From [HzBreakpoint.medium] on, the steps stand on the left on `sunken`
/// and the current one on the right; below it the wizard takes the screen,
/// with the step as a Kennung above its title. Back and the main action sit
/// at the foot, the one accent at the end where the thumb is. An error of
/// [HorizontWizardStep.onContinue] shows as a critical status line beside
/// them, never only in colour.
///
/// The words default to the platform's (`MaterialLocalizations`): „Weiter“,
/// „Zurück“, „Schließen“. [stepOf] words the position, e.g. `Schritt 2 von 3`.
class HorizontWizard extends StatefulWidget {
  /// Creates a wizard.
  const HorizontWizard({
    required this.title,
    required this.steps,
    required this.finishLabel,
    this.stepOf,
    this.nextLabel,
    this.backLabel,
    this.closeLabel,
    super.key,
  });

  /// What the wizard does, e.g. „Produkt anlegen“.
  final String title;

  /// The steps in order; at least one.
  final List<HorizontWizardStep> steps;

  /// The main button on the last step, e.g. „Anlegen“.
  final String finishLabel;

  /// Words the position (1-based); by default `2 / 3`.
  final String Function(int step, int count)? stepOf;

  /// Overrides „Weiter“.
  final String? nextLabel;

  /// Overrides „Zurück“.
  final String? backLabel;

  /// Overrides „Schließen“.
  final String? closeLabel;

  @override
  State<HorizontWizard> createState() => HorizontWizardState();
}

/// The state of a [HorizontWizard]; [index] is the step shown.
class HorizontWizardState extends State<HorizontWizard> {
  int _index = 0;
  bool _busy = false;
  String? _error;

  /// The step shown, from 0.
  int get index => _index;

  void _go(int i) => setState(() {
    _index = i.clamp(0, widget.steps.length - 1);
    _error = null;
  });

  Future<void> _continue() async {
    final step = widget.steps[_index];
    if (step.onContinue != null) {
      setState(() {
        _busy = true;
        _error = null;
      });
      final error = await step.onContinue!();
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = error;
      });
      if (error != null) return;
    }
    if (!mounted) return;
    if (_index == widget.steps.length - 1) {
      Navigator.of(context).pop(true);
    } else {
      _go(_index + 1);
    }
  }

  /// Whether step [i] can be reached again from the current one.
  bool _reachable(int i) =>
      i < _index &&
      !_busy &&
      widget.steps.skip(i).take(_index - i + 1).every((s) => s.canGoBack);

  String _stepOf(int step) =>
      widget.stepOf?.call(step, widget.steps.length) ??
      '$step / ${widget.steps.length}';

  @override
  Widget build(BuildContext context) {
    assert(widget.steps.isNotEmpty, 'A wizard needs at least one step.');
    final wide = MediaQuery.sizeOf(context).width >= HzBreakpoint.medium;
    final hz = HorizontTheme.of(context);
    final c = hz.colors;
    final text = Theme.of(context).textTheme;
    final step = widget.steps[_index];
    final current = _currentStep(context, step, wide: wide);
    if (!wide) return current;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: HzSize.sidebar,
          color: c.sunken,
          padding: const EdgeInsets.fromLTRB(
            HzSpace.s16,
            HzSpace.s24,
            HzSpace.s12,
            HzSpace.s24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.title, style: text.titleMedium),
              const SizedBox(height: HzSpace.s4),
              Text(
                _stepOf(_index + 1),
                style: hz.data.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: HzSpace.s24),
              for (final (i, s) in widget.steps.indexed)
                _StepTile(
                  number: i + 1,
                  title: s.title,
                  state: i < _index
                      ? _StepState.done
                      : i == _index
                      ? _StepState.current
                      : _StepState.upcoming,
                  onTap: _reachable(i) ? () => _go(i) : null,
                ),
            ],
          ),
        ),
        VerticalDivider(
          width: HzLine.hairline,
          thickness: HzLine.hairline,
          color: c.line,
        ),
        Expanded(child: current),
      ],
    );
  }

  Widget _currentStep(
    BuildContext context,
    HorizontWizardStep step, {
    required bool wide,
  }) {
    final hz = HorizontTheme.of(context);
    final c = hz.colors;
    final text = Theme.of(context).textTheme;
    final l10n = MaterialLocalizations.of(context);
    final last = _index == widget.steps.length - 1;
    final mayGoBack =
        _index > 0 && widget.steps[_index - 1].canGoBack && step.canGoBack;
    final side = wide ? HzSpace.s32 : HzSpace.s16;
    final close = IconButton(
      tooltip: widget.closeLabel ?? l10n.closeButtonTooltip,
      onPressed: _busy ? null : () => Navigator.of(context).maybePop(),
      icon: const Icon(HorizontSymbols.close),
    );
    final back = mayGoBack
        ? TextButton.icon(
            onPressed: _busy ? null : () => _go(_index - 1),
            icon: Icon(
              horizontBackSymbol(Theme.of(context).platform),
              size: HzIconSize.inline,
            ),
            label: Text(widget.backLabel ?? l10n.backButtonTooltip),
          )
        : null;
    final main = FilledButton(
      onPressed: _busy || !step.canContinue ? null : _continue,
      child: _busy
          ? const SizedBox.square(
              dimension: HzIconSize.inline,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: HzLine.selection,
              ),
            )
          : Text(
              step.continueLabel ??
                  (last
                      ? widget.finishLabel
                      : widget.nextLabel ?? l10n.continueButtonLabel),
            ),
    );
    final error = _error == null
        ? null
        : HorizontStatusLine(HorizontStatus.critical, _error!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          // The head scrolls with the content: with large type or a long
          // subtitle it would otherwise leave the step no room. Only
          // „Schließen“ stays in place.
          child: Stack(
            children: [
              SingleChildScrollView(
                key: ValueKey(_index),
                padding: EdgeInsets.fromLTRB(
                  side,
                  HzSpace.s24,
                  side,
                  HzSpace.s24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      // Room for „Schließen“ at the end of the first lines.
                      padding: const EdgeInsetsDirectional.only(
                        end: HzSize.touch,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!wide) ...[
                            Kennung('${widget.title} · ${_stepOf(_index + 1)}'),
                            const SizedBox(height: HzSpace.s4),
                          ],
                          Semantics(
                            header: true,
                            child: Text(step.title, style: text.titleLarge),
                          ),
                          if (step.subtitle != null) ...[
                            const SizedBox(height: HzSpace.s4),
                            Text(
                              step.subtitle!,
                              style: text.bodyMedium?.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: HzSpace.s24),
                    step.content,
                  ],
                ),
              ),
              PositionedDirectional(
                top: HzSpace.s16,
                end: HzSpace.s8,
                child: close,
              ),
            ],
          ),
        ),
        Divider(
          height: HzLine.hairline,
          thickness: HzLine.hairline,
          color: c.line,
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: wide ? HzSpace.s24 : HzSpace.s16,
              vertical: HzSpace.s16,
            ),
            // Wide: the message beside the buttons. Narrow: above them, and
            // the buttons wrap, so a long word or large type never overflows.
            child: wide
                ? Row(
                    children: [
                      Expanded(child: error ?? const SizedBox.shrink()),
                      const SizedBox(width: HzSpace.s12),
                      ?back,
                      const SizedBox(width: HzSpace.s8),
                      main,
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (error != null) ...[
                        error,
                        const SizedBox(height: HzSpace.s12),
                      ],
                      Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: HzSpace.s8,
                        runSpacing: HzSpace.s8,
                        children: [?back, main],
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

enum _StepState { done, current, upcoming }

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.number,
    required this.title,
    required this.state,
    this.onTap,
  });

  final int number;
  final String title;
  final _StepState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hz = HorizontTheme.of(context);
    final c = hz.colors;
    final text = Theme.of(context).textTheme;
    final current = state == _StepState.current;
    final marker = Container(
      width: HzIconSize.tab,
      height: HzIconSize.tab,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: switch (state) {
          _StepState.done => c.accentTint,
          _StepState.current => c.accent,
          _StepState.upcoming => null,
        },
        border: state == _StepState.upcoming
            ? Border.all(color: c.lineStrong, width: HzLine.data)
            : null,
      ),
      child: state == _StepState.done
          ? Icon(
              HorizontSymbols.check,
              size: HzIconSize.inline,
              color: c.accentText,
            )
          : Text(
              '$number',
              style: hz.data.copyWith(
                color: current ? c.onAccent : c.textMuted,
              ),
            ),
    );
    return Semantics(
      selected: current,
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: hz.controlRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: HzSpace.s8,
            horizontal: HzSpace.s4,
          ),
          child: Row(
            children: [
              marker,
              const SizedBox(width: HzSpace.s12),
              Expanded(
                child: Text(
                  title,
                  style: text.bodyMedium?.copyWith(
                    color: state == _StepState.upcoming ? c.textMuted : c.text,
                    fontWeight: current ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens [wizard] and completes with true when it was finished. From
/// [HzBreakpoint.medium] on it is a dialog of at most [maxWidth] ×
/// [maxHeight] that a tap beside it does not close; below it takes the
/// screen.
Future<bool> showHorizontWizard(
  BuildContext context,
  Widget wizard, {
  double maxWidth = 880,
  double maxHeight = 640,
}) async {
  final wide = MediaQuery.sizeOf(context).width >= HzBreakpoint.medium;
  final done = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    useSafeArea: !wide,
    builder: (context) => wide
        ? Dialog(
            clipBehavior: Clip.antiAlias,
            insetPadding: const EdgeInsets.all(HzSpace.s24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
              ),
              child: SizedBox(
                width: maxWidth,
                height: maxHeight,
                child: wizard,
              ),
            ),
          )
        : Dialog.fullscreen(child: wizard),
  );
  return done ?? false;
}
