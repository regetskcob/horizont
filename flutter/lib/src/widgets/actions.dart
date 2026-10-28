import 'package:flutter/material.dart';

import '../colors.dart';
import '../horizont_theme.dart';
import '../tokens.g.dart';
import 'status.dart';

/// The one primary action of a screen, placed the Horizont way: on touch a
/// floating action button (below 600 square with the symbol and a tooltip,
/// from 600 extended with the word), with a pointer a `FilledButton` in the
/// toolbar and no FAB.
///
/// ```dart
/// final add = HorizontPrimaryAction(icon: HorizontSymbols.add, label: l10n.add, onPressed: _add);
/// Scaffold(
///   appBar: AppBar(actions: [...add.toolbar(context)]),
///   floatingActionButton: add.fab(context),
/// )
/// ```
@immutable
class HorizontPrimaryAction {
  /// Creates the action.
  const HorizontPrimaryAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  /// The symbol.
  final IconData icon;

  /// The word; the tooltip of the square FAB.
  final String label;

  /// What it does; null disables it.
  final VoidCallback? onPressed;

  /// Whether the action sits in the toolbar rather than in a FAB.
  static bool inToolbar(BuildContext context) =>
      HorizontTheme.of(context).density == HorizontDensity.pointer;

  /// The FAB for `Scaffold.floatingActionButton`, null with a pointer. Give
  /// each FAB of a page a [heroTag] of its own when there are several routes
  /// with one.
  Widget? fab(BuildContext context, {Object? heroTag}) {
    if (inToolbar(context)) return null;
    final wide = MediaQuery.sizeOf(context).width >= HzBreakpoint.medium;
    if (wide) {
      return FloatingActionButton.extended(
        heroTag: heroTag,
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      );
    }
    return FloatingActionButton(
      heroTag: heroTag,
      tooltip: label,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }

  /// The button for `AppBar.actions` (with its gap to the edge), empty on
  /// touch.
  List<Widget> toolbar(BuildContext context) {
    if (!inToolbar(context)) return const [];
    return [
      FilledButton.icon(onPressed: onPressed, icon: Icon(icon), label: Text(label)),
      const SizedBox(width: HzSpace.s12),
    ];
  }
}

/// The foot of a form sheet: a quiet „Abbrechen“ and the one accent,
/// „Speichern“, at the end where the thumb is. While [saving] both are
/// disabled and the save button shows the platform's spinner. The words
/// default to the platform's (`MaterialLocalizations`).
class HorizontSheetActions extends StatelessWidget {
  /// Creates the foot of a sheet.
  const HorizontSheetActions({
    required this.onSave,
    this.onCancel,
    this.saving = false,
    this.saveLabel,
    this.cancelLabel,
    super.key,
  });

  /// Saves; null disables it (e.g. while the form is invalid).
  final VoidCallback? onSave;

  /// Leaves; by default the sheet is popped.
  final VoidCallback? onCancel;

  /// Whether a save is running.
  final bool saving;

  /// Overrides „Speichern“, e.g. „Melden“.
  final String? saveLabel;

  /// Overrides „Abbrechen“.
  final String? cancelLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = MaterialLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: saving ? null : (onCancel ?? () => Navigator.maybePop(context)),
          child: Text(cancelLabel ?? l10n.cancelButtonLabel),
        ),
        const SizedBox(width: HzSpace.s8),
        FilledButton(
          onPressed: saving ? null : onSave,
          child: saving
              ? const SizedBox.square(
                  dimension: HzIconSize.row,
                  child: CircularProgressIndicator.adaptive(strokeWidth: HzLine.selection),
                )
              : Text(saveLabel ?? l10n.saveButtonLabel),
        ),
      ],
    );
  }
}

/// The padding of a form sheet: the gutter of a phone, and the keyboard
/// below.
EdgeInsets horizontSheetPadding(BuildContext context) => EdgeInsets.only(
      left: HzSpace.s16,
      right: HzSpace.s16,
      top: HzSpace.s16,
      bottom: MediaQuery.viewInsetsOf(context).bottom + HzSpace.s16,
    );

/// The snack bar of [showHorizontMessage], for when the messenger was taken
/// before an `await` or a `Navigator.pop` (the context may be gone by then):
///
/// ```dart
/// final messenger = ScaffoldMessenger.of(context);
/// final colors = HorizontTheme.of(context).colors;
/// await save();
/// messenger.showSnackBar(horizontMessageSnackBar(colors, l10n.saved, status: HorizontStatus.positive));
/// ```
SnackBar horizontMessageSnackBar(HorizontColors colors, String message, {HorizontStatus? status}) => SnackBar(
      content: status == null
          ? Text(message)
          : Row(
              children: [
                ExcludeSemantics(
                  child: Icon(status.icon, size: HzIconSize.inline, color: status.tint(colors)),
                ),
                const SizedBox(width: HzSpace.s8),
                Expanded(child: Text(message)),
              ],
            ),
    );

/// Says what just happened in a line at the foot of the screen. With
/// [status] the line carries that state's glyph, so the message never speaks
/// by colour alone. The snack bar is inverted (text colour as ground), so
/// the glyph takes the state's tint, which is light where the bar is dark
/// and the other way round; the state's own colour would sink into it.
void showHorizontMessage(BuildContext context, String message, {HorizontStatus? status}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(horizontMessageSnackBar(HorizontTheme.of(context).colors, message, status: status));
}
