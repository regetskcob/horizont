import 'package:flutter/material.dart';

import '../horizont_theme.dart';
import '../tokens.g.dart';

/// One destination of a [HorizontTabBar] or [HorizontRail].
@immutable
class HorizontDestination {
  /// Creates a destination with [icon] and [label].
  const HorizontDestination({
    required this.icon,
    required this.label,
    this.badge,
  });

  /// The icon, usually one of `HorizontSymbols`.
  final IconData icon;

  /// The label, always shown.
  final String label;

  /// Optional count or short value next to the label in the rail (mono).
  final String? badge;
}

/// The bottom navigation of Horizont on touch devices: labels always
/// visible, the selected destination on `accentTint` (radius 6, no pill, no
/// line) that hugs icon and word; the icon is 24 in `accentText`, the word
/// semibold in `text`. On Android it replaces `NavigationBar`, on iOS it
/// stands for the tab bar. The tint instead of the selection line is a
/// decided exception (KNX Monitor): the line looked like a fault on device.
class HorizontTabBar extends StatelessWidget {
  /// Creates a tab bar.
  const HorizontTabBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  }) : assert(
         destinations.length >= 2 && destinations.length <= 5,
         'A tab bar has 2 to 5 destinations.',
       );

  /// Three to five destinations.
  final List<HorizontDestination> destinations;

  /// The selected destination.
  final int selectedIndex;

  /// Called with the index of the tapped destination.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final c = theme.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(
          top: BorderSide(color: c.line, width: HzLine.hairline),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var i = 0; i < destinations.length; i++)
              Expanded(
                child: _Tab(
                  destination: destinations[i],
                  selected: i == selectedIndex,
                  onTap: () => onSelected(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final HorizontDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = HorizontTheme.of(context).colors;
    final fg = selected ? c.accentText : c.textMuted;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: HzSize.touch + HzSpace.s12,
          ),
          child: Padding(
            // Narrow at the sides: with five tabs on a phone a word like
            // „Übersicht“ needs the whole slot to stay in one piece.
            padding: const EdgeInsets.symmetric(
              horizontal: HzSpace.s2,
              vertical: HzSpace.s4,
            ),
            // The selection is a light tint behind icon and word, radius 6
            // (no pill); the icon is larger and in accent-text, the colour
            // of the accent for foregrounds (4.5:1 on accent-tint).
            child: Center(
              // The tint hugs icon and word instead of filling the slot; it
              // never takes more height than its content.
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: selected ? c.accentTint : null,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(HzRadius.r6),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: HzSpace.s8,
                    vertical: HzSpace.s4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(destination.icon, size: HzIconSize.tab, color: fg),
                      const SizedBox(height: HzSpace.s2),
                      Text(
                        destination.label,
                        style:
                            horizontTextStyle(
                              HzType.caption,
                              selected ? c.text : c.textMuted,
                            ).copyWith(
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The side navigation of Horizont from 600 wide: optional [header] (e.g. a
/// Kennung and the district's name), destinations with the selected one
/// marked by a 2 px line at the start and the accent tint, and an optional
/// [footer] (e.g. the key figures).
class HorizontRail extends StatelessWidget {
  /// Creates a side navigation.
  const HorizontRail({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    this.header,
    this.footer,
    this.width = HzSize.sidebar,
    super.key,
  });

  /// The destinations.
  final List<HorizontDestination> destinations;

  /// The selected destination.
  final int selectedIndex;

  /// Called with the index of the tapped destination.
  final ValueChanged<int> onSelected;

  /// Shown above the destinations.
  final Widget? header;

  /// Shown at the foot of the rail.
  final Widget? footer;

  /// Width of the rail.
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final c = theme.colors;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: c.sunken,
        border: BorderDirectional(
          end: BorderSide(color: c.line, width: HzLine.hairline),
        ),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  HzSpace.s16,
                  HzSpace.s16,
                  HzSpace.s16,
                  HzSpace.s12,
                ),
                child: header,
              ),
            for (var i = 0; i < destinations.length; i++)
              _RailItem(
                destination: destinations[i],
                selected: i == selectedIndex,
                height: theme.density == HorizontDensity.touch
                    ? HzSize.touch
                    : 32,
                onTap: () => onSelected(i),
              ),
            const Spacer(),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.destination,
    required this.selected,
    required this.height,
    required this.onTap,
  });

  final HorizontDestination destination;
  final bool selected;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final c = theme.colors;
    final fg = selected ? c.text : c.textMuted;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? c.accentTint : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            padding: const EdgeInsetsDirectional.only(
              start: HzSpace.s16,
              end: HzSpace.s12,
            ),
            decoration: BoxDecoration(
              border: BorderDirectional(
                start: BorderSide(
                  color: selected ? c.accent : Colors.transparent,
                  width: HzLine.selection,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(destination.icon, size: HzIconSize.row, color: fg),
                const SizedBox(width: HzSpace.s8),
                Expanded(
                  child: Text(
                    destination.label,
                    style: horizontTextStyle(HzType.callout, fg),
                  ),
                ),
                if (destination.badge != null)
                  Text(
                    destination.badge!,
                    style: theme.data.copyWith(
                      fontSize: HzType.kennung.size,
                      color: c.textMuted,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
