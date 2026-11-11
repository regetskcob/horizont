import 'package:flutter/material.dart';

import '../horizont_theme.dart';
import '../tokens.g.dart';
import 'kennung.dart';

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

/// The side navigation of Horizont from 600 wide for a fixed list of
/// [destinations]: optional [header] (e.g. a Kennung and the district's
/// name), the destinations as [HorizontSidebarItem]s and an optional [footer]
/// (e.g. the key figures). For groups, counts or switches build a
/// [HorizontSidebar] directly.
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
  Widget build(BuildContext context) => HorizontSidebar(
    header: header,
    footer: footer,
    width: width,
    children: [
      for (var i = 0; i < destinations.length; i++)
        HorizontSidebarItem(
          icon: destinations[i].icon,
          label: destinations[i].label,
          count: destinations[i].badge,
          selected: i == selectedIndex,
          onTap: () => onSelected(i),
        ),
    ],
  );
}

/// The sidebar of an app from 600 wide: an optional [header], the
/// [children] (usually [HorizontSidebarItem]s, grouped under
/// [HorizontSidebarLabel]s) scrolling, and a [footer] fixed at the foot
/// (a switch like the expert mode, actions like „Add source“).
///
/// It draws itself after the theme's style. Soft (the default): on the
/// paper of the page's surface with a hairline at the end, rows inset with
/// rounded corners, the chosen one on `accent-tint` without a line, quiet
/// rows in `text-muted`. Standard: on `sunken`, rows across the full width,
/// the chosen one with 2 px of the accent at the start.
///
/// ```dart
/// HorizontSidebar(
///   children: [
///     HorizontSidebarItem(icon: HorizontSymbols.today, label: 'Heute', count: '4', selected: true, onTap: …),
///     const HorizontSidebarLabel('Quellen', count: 2),
///     HorizontSidebarItem(icon: HorizontSymbols.rssFeed, label: 'regetskcob', onTap: …),
///   ],
///   footer: HorizontSidebarItem(icon: HorizontSymbols.settings, label: 'Einstellungen', onTap: …),
/// )
/// ```
class HorizontSidebar extends StatelessWidget {
  /// Creates a sidebar.
  const HorizontSidebar({
    required this.children,
    this.header,
    this.footer,
    this.width = HzSize.sidebar,
    super.key,
  });

  /// Rows and group labels, top to bottom; they scroll.
  final List<Widget> children;

  /// Shown above the rows, e.g. a `HorizontLockup`; most apps need none.
  final Widget? header;

  /// Fixed at the foot, outside the scrolling rows.
  final Widget? footer;

  /// Width: [HzSize.sidebar] 240, with a pointer down to [HzSize.rail].
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final c = theme.colors;
    final soft = theme.soft;
    // Soft rows are inset from both edges; standard rows span the width.
    final inset = soft ? HzSpace.s8 : 0.0;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: soft ? c.surface : c.sunken,
        border: BorderDirectional(
          end: BorderSide(color: c.line, width: HzLine.hairline),
        ),
      ),
      // Own Material: the sidebar often sits next to a Scaffold, not in one,
      // and its texts and ink need a Material ancestor.
      child: Material(
        type: MaterialType.transparency,
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
                    HzSpace.s8,
                  ),
                  child: header,
                ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    inset,
                    HzSpace.s8,
                    inset,
                    HzSpace.s16,
                  ),
                  children: children,
                ),
              ),
              if (footer != null)
                DecoratedBox(
                  // Standard sets the foot off with a hairline; soft leaves
                  // it on the same paper, white space separates.
                  decoration: BoxDecoration(
                    border: soft
                        ? null
                        : Border(
                            top: BorderSide(
                              color: c.line,
                              width: HzLine.hairline,
                            ),
                          ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      inset,
                      soft ? 0 : HzSpace.s4,
                      inset,
                      HzSpace.s8,
                    ),
                    child: footer,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The heading of a group in a [HorizontSidebar], with an optional [count]
/// (`QUELLEN · 2`) and [trailing] quiet actions (a `TextButton` „Alle“).
/// Soft: capitals in Mona Sans in `text`, standard: a [Kennung].
class HorizontSidebarLabel extends StatelessWidget {
  /// Creates a group heading.
  const HorizontSidebarLabel(
    this.title, {
    this.count,
    this.trailing,
    super.key,
  });

  /// The title, in normal case.
  final String title;

  /// An optional count after the title.
  final int? count;

  /// Quiet actions at the end.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final soft = theme.soft;
    return Padding(
      padding: soft
          ? const EdgeInsets.fromLTRB(
              HzSpace.s8,
              HzSpace.s24,
              HzSpace.s8,
              HzSpace.s4,
            )
          : const EdgeInsets.fromLTRB(
              HzSpace.s16,
              HzSpace.s24,
              HzSpace.s16,
              HzSpace.s8,
            ),
      child: Semantics(
        header: true,
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Kennung(
                  title,
                  count: count,
                  oneLine: true,
                  color: soft ? theme.colors.text : null,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// How loud a [HorizontSidebarItem] is.
enum HorizontSidebarTone {
  /// A destination or tool.
  normal,

  /// A hint that there is more („4 more tools in expert mode“).
  muted,

  /// An action that removes or disconnects, in `critical`.
  critical,
}

/// One row of a [HorizontSidebar]: icon 18, the label, an optional [count]
/// and [trailing] widget (a switch, a tier badge). [selected] marks the open
/// place: soft as `accent-tint` behind the row with icon and label in
/// `accent-text`, semibold; standard with the 2 px line at the start. Rows
/// are 44 high on touch and 32 with a pointer.
class HorizontSidebarItem extends StatelessWidget {
  /// Creates a sidebar row.
  const HorizontSidebarItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.selected = false,
    this.count,
    this.trailing,
    this.indent = 0,
    this.tone = HorizontSidebarTone.normal,
    this.tooltip,
    super.key,
  });

  /// The icon, usually one of `HorizontSymbols`.
  final IconData icon;

  /// The label, always shown.
  final String label;

  /// Opens the place or runs the action; null disables the row.
  final VoidCallback? onTap;

  /// Whether this is the open place.
  final bool selected;

  /// A count or short value after the label (unread articles, changes).
  final String? count;

  /// A widget at the end, e.g. `Switch.adaptive` or a badge.
  final Widget? trailing;

  /// Nesting depth: each step moves the row in by 16 (a feed in a folder).
  final int indent;

  /// How loud the row is.
  final HorizontSidebarTone tone;

  /// A longer explanation on hover and long press.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final c = theme.colors;
    final soft = theme.soft;
    final enabled = onTap != null;
    final Color fg;
    if (!enabled || tone == HorizontSidebarTone.muted) {
      fg = c.textFaint;
    } else if (tone == HorizontSidebarTone.critical) {
      fg = c.critical;
    } else if (selected) {
      fg = soft ? c.accentText : c.text;
    } else {
      fg = c.textMuted;
    }
    final height = theme.density == HorizontDensity.touch
        ? HzSize.touch
        : HzSpace.s32;
    final start = (soft ? HzSpace.s8 : HzSpace.s16) + indent * HzSpace.s16;
    final labelStyle = horizontTextStyle(
      HzType.callout,
      fg,
    ).copyWith(fontWeight: soft && selected ? FontWeight.w600 : null);
    final content = Container(
      constraints: BoxConstraints(minHeight: height),
      padding: EdgeInsetsDirectional.only(
        start: start,
        end: soft ? HzSpace.s8 : HzSpace.s12,
      ),
      decoration: soft
          ? null
          : BoxDecoration(
              border: BorderDirectional(
                start: BorderSide(
                  color: selected ? c.accent : Colors.transparent,
                  width: HzLine.selection,
                ),
              ),
            ),
      child: Row(
        children: [
          Icon(icon, size: HzIconSize.row, color: fg),
          const SizedBox(width: HzSpace.s8),
          Expanded(child: Text(label, style: labelStyle)),
          if (count != null) ...[
            const SizedBox(width: HzSpace.s8),
            Text(count!, style: theme.count),
          ],
          if (trailing != null) ...[
            const SizedBox(width: HzSpace.s8),
            trailing!,
          ],
        ],
      ),
    );
    final row = Semantics(
      selected: selected,
      button: enabled,
      child: Material(
        color: selected ? c.accentTint : Colors.transparent,
        borderRadius: soft
            ? const BorderRadius.all(Radius.circular(HzSoft.row))
            : null,
        clipBehavior: soft ? Clip.antiAlias : Clip.none,
        child: InkWell(onTap: onTap, child: content),
      ),
    );
    return tooltip == null ? row : Tooltip(message: tooltip, child: row);
  }
}
