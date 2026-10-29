import 'package:flutter/material.dart';
import 'package:horizont/horizont.dart';

/// One screen built only from Horizont: header with Kennung, a strip of key
/// figures, sections, rows with status, controls, the one primary action as
/// FAB (symbol only under 600, with its word from 600) and the navigation,
/// which switches from tab bar to rail at 600.
class Showcase extends StatefulWidget {
  const Showcase({super.key});

  @override
  State<Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase> {
  int _tab = 0;
  bool _offline = true;
  String _view = 'list';
  String _kind = 'kanzel';

  static const _destinations = [
    HorizontDestination(icon: HorizontSymbols.forest, label: 'Übersicht'),
    // A soft hyphen lets a long German label break at a syllable, not
    // after any letter; never shrink or cut a label to make it fit.
    HorizontDestination(icon: HorizontSymbols.cottage, label: 'Einrich\u00ADtungen', badge: '14'),
    HorizontDestination(icon: HorizontSymbols.checklist, label: 'Aufgaben', badge: '3'),
    HorizontDestination(icon: HorizontSymbols.pets, label: 'Wild'),
    HorizontDestination(icon: HorizontSymbols.map, label: 'Karte'),
  ];

  static final _report = HorizontPrimaryAction(icon: HorizontSymbols.add, label: 'Meldung erfassen', onPressed: () {});

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final c = theme.colors;
    final wide = MediaQuery.sizeOf(context).width >= HzBreakpoint.medium;
    final content = _content(context, theme);
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            HorizontRail(
              destinations: _destinations,
              selectedIndex: _tab,
              onSelected: (i) => setState(() => _tab = i),
              header: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HorizontLockup(theme.product, label: theme.product.displayName),
                  const SizedBox(height: HzSpace.s16),
                  const Kennung('Revier'),
                  Text('Buchenhain', style: Theme.of(context).textTheme.titleMedium),
                  Text('412,5 ha · Bayern', style: theme.data.copyWith(fontSize: 11, color: c.textMuted)),
                ],
              ),
            ),
            Expanded(child: content),
          ],
        ),
        floatingActionButton: _report.fab(context),
      );
    }
    return Scaffold(
      body: content,
      floatingActionButton: _report.fab(context),
      bottomNavigationBar: HorizontTabBar(
        destinations: _destinations,
        selectedIndex: _tab,
        onSelected: (i) => setState(() => _tab = i),
      ),
    );
  }

  Widget _content(BuildContext context, HorizontTheme theme) {
    final c = theme.colors;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(HzSpace.s16, HzSpace.s12, HzSpace.s16, HzSpace.s12),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(child: HorizontTitle(kennung: 'Hegering Nord · 412 ha', title: 'Übersicht')),
                IconButton(onPressed: () {}, icon: const Icon(HorizontSymbols.search), tooltip: 'Suchen'),
              ],
            ),
          ),
          _Figures(theme: theme),
          HorizontSectionHeader('Einrichtungen', count: 14, trailing: TextButton(onPressed: () {}, child: const Text('Alle'))),
          const _Row(icon: HorizontSymbols.cottage, title: 'Kanzel am Bruch', meta: 'K-07 · geprüft 12.10.', status: HorizontStatus.positive, word: 'Gut'),
          const _Row(icon: HorizontSymbols.cottage, title: 'Leiter Schlagkante', meta: 'L-03 · geprüft 28.09.', status: HorizontStatus.warning, word: 'Prüfen'),
          const _Row(icon: HorizontSymbols.cottage, title: 'Kanzel Heckenweg', meta: 'K-11 · geprüft 02.08.', status: HorizontStatus.critical, word: 'Defekt'),
          const HorizontSectionHeader('Kanzel am Bruch'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: HzSpace.s16),
            child: Column(
              children: [
                HorizontFact(term: 'Kennung', value: 'K-07', measured: true),
                HorizontFact(term: 'Geprüft', value: '12.10.2026', measured: true),
                HorizontFact(term: 'Zustand', child: HorizontBadge(HorizontStatus.positive, label: 'Gut')),
              ],
            ),
          ),
          for (final (i, line) in ['Linie 1', 'Linie 2'].indexed)
            HorizontSelectable(selected: i == 0, onTap: () {}, child: Text(line)),
          HorizontSectionHeader('Bausteine', collapsed: false, onToggle: () {}),
          Padding(
            padding: const EdgeInsets.all(HzSpace.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: HzSpace.s8,
                  runSpacing: HzSpace.s8,
                  children: [
                    FilledButton(onPressed: () {}, child: const Text('Speichern')),
                    OutlinedButton(onPressed: () {}, child: const Text('Abbrechen')),
                    TextButton(onPressed: () {}, child: const Text('Alle anzeigen')),
                  ],
                ),
                const SizedBox(height: HzSpace.s16),
                // The label above the field, not inside the outline.
                HorizontField(
                  label: 'Name',
                  help: 'So heißt sie im Revier.',
                  child: TextField(
                    style: theme.field,
                    decoration: InputDecoration(
                      hintText: 'Kanzel am Bruch',
                      suffixIcon: HorizontFieldIconButton(
                        icon: const Icon(HorizontSymbols.close),
                        tooltip: 'Leeren',
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: HzSpace.s16),
                // A few fixed values inside a form: a field, not a segment.
                HorizontField(
                  label: 'Art',
                  child: HorizontFieldDropdown(
                    value: _kind,
                    items: const [('kanzel', 'Kanzel'), ('leiter', 'Leiter'), ('kirrung', 'Kirrung')],
                    onChanged: (v) => setState(() => _kind = v),
                  ),
                ),
                const SizedBox(height: HzSpace.s16),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'list', label: Text('Liste')),
                    ButtonSegment(value: 'map', label: Text('Karte')),
                  ],
                  selected: {_view},
                  showSelectedIcon: false,
                  onSelectionChanged: (s) => setState(() => _view = s.first),
                ),
                const SizedBox(height: HzSpace.s8),
                // Adaptive: a Cupertino switch on Apple platforms, in the accent.
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Offline speichern'),
                  value: _offline,
                  onChanged: (v) => setState(() => _offline = v),
                ),
                const SizedBox(height: HzSpace.s8),
                const Wrap(
                  spacing: HzSpace.s8,
                  runSpacing: HzSpace.s8,
                  children: [
                    HorizontBadge(HorizontStatus.positive, label: 'Gut'),
                    HorizontBadge(HorizontStatus.warning, label: 'Prüfen'),
                    HorizontBadge(HorizontStatus.critical, label: 'Defekt'),
                    HorizontBadge(HorizontStatus.info, label: 'Hinweis'),
                    HorizontBadge(HorizontStatus.neutral, label: 'Unbekannt'),
                  ],
                ),
                const SizedBox(height: HzSpace.s16),
                const HorizontStatusLine(HorizontStatus.positive, 'Abgeglichen um 06:42'),
                const SizedBox(height: HzSpace.s16),
                const HorizontMetricRow(
                  children: [
                    HorizontMetric(label: 'Ansitze', value: '27'),
                    HorizontMetric(label: 'Überfällig', value: '2', status: HorizontStatus.warning),
                  ],
                ),
                const SizedBox(height: HzSpace.s16),
                Row(
                  children: [
                    const HorizontLetterBadge('K', semanticLabel: 'Kanzel'),
                    const SizedBox(width: HzSpace.s4),
                    const HorizontLetterBadge('L', semanticLabel: 'Leiter', status: HorizontStatus.info),
                    const SizedBox(width: HzSpace.s16),
                    Icon(HorizontSymbols.starFill, size: HzIconSize.bar, color: c.accentText),
                    Icon(HorizontSymbols.pushPinFill, size: HzIconSize.bar, color: c.accentText),
                    const SizedBox(width: HzSpace.s16),
                    for (final step in c.dataRamp)
                      Container(width: HzSpace.s16, height: HzSpace.s16, color: step),
                  ],
                ),
                const SizedBox(height: HzSpace.s24),
                Text('Das Revier im Blick.', style: theme.display.copyWith(fontSize: 30, height: 36 / 30)),
                const SizedBox(height: HzSpace.s8),
                Text(
                  'Hochsitze, Kirrungen, Aufgaben und Strecke an einem Ort.',
                  style: theme.reading.copyWith(color: c.textMuted),
                ),
                const SizedBox(height: HzSpace.s24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Figures extends StatelessWidget {
  const _Figures({required this.theme});

  final HorizontTheme theme;

  @override
  Widget build(BuildContext context) {
    final c = theme.colors;
    Widget cell(String value, String label, {Color? color}) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: HzSpace.s16, vertical: HzSpace.s12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: theme.data.copyWith(fontSize: 22, height: 1.1, color: color)),
                Kennung(label),
              ],
            ),
          ),
        );
    final divider = Container(width: HzLine.hairline, color: c.line);
    // With large text the three figures stack instead of breaking their
    // labels mid-word.
    if (MediaQuery.textScalerOf(context).scale(1) > 1.4) {
      Widget row(String value, String label, {Color? color}) => Container(
            padding: const EdgeInsets.symmetric(horizontal: HzSpace.s16, vertical: HzSpace.s8),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(child: Kennung(label)),
                Text(value, style: theme.data.copyWith(fontSize: 22, height: 1.1, color: color)),
              ],
            ),
          );
      return Column(children: [row('3', 'Aufgaben'), row('3', 'Prüfen', color: c.critical), row('2', 'Strecke')]);
    }
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            cell('3', 'Aufgaben'),
            divider,
            cell('3', 'Prüfen', color: c.critical),
            divider,
            cell('2', 'Strecke'),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.title, required this.meta, required this.status, required this.word});

  final IconData icon;
  final String title;
  final String meta;
  final HorizontStatus status;
  final String word;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(meta),
          trailing: HorizontBadge(status, label: word),
          onTap: () {},
        ),
        Divider(indent: 56, color: theme.colors.line),
      ],
    );
  }
}
