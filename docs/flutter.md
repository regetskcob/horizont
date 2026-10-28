# Horizont in Flutter

Leitfaden für die Umstellung von Jagdaufseher, KNX Monitor und Panzergefecht.
Die Regeln selbst stehen in [CLAUDE.md](../CLAUDE.md), die Werte in
[tokens/horizont.json](../tokens/horizont.json).

Wenn in der Sitzung verfügbar, zusätzlich die Skills
`flutter:design-system-structure`, `flutter:adaptive-layout` und
`flutter:accessibility-as-code` laden. Sie decken sich mit dem, was hier
steht. Die CLAUDE.md der jeweiligen App (l10n, Zustandsverwaltung,
Commit-Regeln) gilt weiter.

## Das Paket

Das Paket `horizont` liegt unter `flutter/` (Anleitung: `flutter/README.md`).
Die Apps binden es per Git-Abhängigkeit mit festem Tag ein:

```yaml
dependencies:
  horizont:
    git:
      url: https://github.com/regetskcob/horizont.git
      path: flutter
      ref: v0.8.0
```

Am Paket ändern v0.6.3, v0.7.9 (`HzMotion.calm` und `settle`) und v0.8.0
(Feldhöhen, `HorizontFieldIconButton`, `HorizontFieldDropdown`); die
übrigen 0.7er-Tags ändern nur das Web und die Exporte und lassen sich ohne
Weiteres eintragen.

Es bringt mit:

- `buildHorizontTheme(product, brightness, density:)` mit dem von Hand
  gesetzten `ColorScheme` aus der Tabelle unten, der Typografie und allen
  Komponenten-Themes.
- Die Extension `HorizontTheme`, gelesen mit `HorizontTheme.of(context)`.
  Sie assertet, statt still auf einen Ersatz zurückzufallen.
- `HorizontColors`, `HorizontSymbols`, die Werte `HzSpace`, `HzRadius`,
  `HzLine`, `HzSize`, `HzIconSize`, `HzBreakpoint`, `HzMotion`, `HzType`.
- Die Widgets `Kennung` (mit `count` und `oneLine`),
  `HorizontSectionHeader`, `HorizontField`, `HorizontFieldIconButton`,
  `HorizontFieldDropdown`, `HorizontBadge`,
  `HorizontStatusLine`, `HorizontLetterBadge`, `HorizontMetric`,
  `HorizontMetricRow`, `HorizontEmptyHint`, `HorizontTabBar`,
  `HorizontRail`, `HorizontMark` und `HorizontLockup`, dazu
  `horizontDialogAction`, `resolveMotion` und
  `HorizontTheme.of(context).criticalButton`.
- `registerHorizontLicenses()` für die Lizenzseite.
- Für Tests `package:horizont/testing.dart` mit `loadHorizontFonts()`: in
  `setUpAll` aufrufen, dann zeigen Goldens die echten Schriften und Symbole.

Tests im Paket: Kontrast (AA) für jedes Produkt und jeden Modus, Theme,
Widgets inklusive Grundlinie des Lockups. Goldens der Showcase-App liegen in
`flutter/example/test/goldens/`.

In einer App gilt: Nichts davon nachbauen. Fehlt etwas, kommt es ins Paket,
mit Token, Test und neuem Tag.

## Plattformgefühl

Horizont legt Farbe, Schrift, Linie, Abstand und Ton fest. Wie sich eine App
anfühlt, also Gesten, Rückmeldung, Übergänge, Systemdialoge und Dichte, bleibt
bei der Plattform. Das Paket sorgt dafür, solange die App es nicht übersteuert:

- **Rückmeldung beim Tippen:** auf Android die native Welle (Sparkle). Auf
  iOS, macOS, Windows, Linux und im Web keine Welle, sondern nur das
  Abdunkeln beim Drücken und ein Hover-Ton.
- **Seitenübergänge und Zurück-Gesten:** auf iOS und macOS die
  Cupertino-Übergänge mit Wischen zurück, auf Android Predictive Back.
- **Dichte:** Die Plattform bestimmt sie (`HorizontDensity.forPlatform`). Mit
  Zeiger auf Mac, Windows und Linux, Touch auf Telefon und Tablet. Übergeben
  wird sie nur, wenn die App es besser weiß, etwa beim iPad mit Tastatur und
  Trackpad.
- **Cupertino-Theme:** `Switch.adaptive`, `showAdaptiveDialog`,
  `CupertinoDatePicker` und Action Sheets erscheinen nativ, im Akzent und auf
  der Fläche des Produkts, aber mit der Systemschrift.

Für die App selbst gilt:

- **Adaptive Bausteine nutzen:** `Switch.adaptive`, `Slider.adaptive`,
  `Checkbox.adaptive`, `CircularProgressIndicator.adaptive`,
  `AlertDialog.adaptive` bzw. `showAdaptiveDialog`, `Icons.adaptive.*` für
  Zurück, Teilen und Mehr. Auf iOS Datum und Uhrzeit mit
  `CupertinoDatePicker`, Auswahl aus wenigen Aktionen als
  `CupertinoActionSheet`.
- **System nie nachbauen:** Teilen über das System-Sheet, Berechtigungen,
  Dateiauswahl, Textauswahl und Kontextmenüs bleiben nativ. Kein eigener
  Dialog im Horizont-Look, wo das System einen hat.
- **Scrollen nicht anfassen:** Gummiband auf Apple-Plattformen, Glow bzw.
  Stretch auf Android. Keine eigene `ScrollPhysics` ohne Grund.
- **Desktop:** Menüleiste auf macOS (`PlatformMenuBar`), Tastenkürzel,
  Hover-Zustände, Rechtsklick-Menüs, Fenstertitel. Auf dem Mac sitzt die
  Seitenleiste unter der transparenten Titelleiste.
- **Haptik wie die Plattform:** `HapticFeedback.selectionClick` beim Wechsel
  einer Auswahl auf iOS, sonst nur, wo das System es auch tut. Nie zur Zier.
- **Fernseher und Uhr:** Fokus-Engine und Siri Remote auf tvOS, Krone und
  Seitentaste auf watchOS bleiben beim System.

Bewusst anders als die Plattform, so entschieden in regetskcob/horizont#1:
Mona Sans statt Systemschrift in der App-Oberfläche, die Kennung mit linkem
Titel statt des großen iOS-Titels, die Auswahl als Linie statt als Pille.
Dazu entschieden bei KNX Monitor: die Tab-Bar unten markiert das Ziel mit
einer Tönung (`accent-tint`) statt einer Linie, weil die Linie am Gerät wie
ein Fehler wirkte; und die Hauptaktion steht auch auf iOS als FAB, weil sie
oben in der Leiste des iPhones kaum lesbar war. Darüber hinaus weicht nichts
ab, ohne dass es entschieden ist.

## Grundsätze

- Nie `ColorScheme.fromSeed`, nie `dynamic_color`, nie `google_fonts`. Hell
  und dunkel werden von Hand gesetzt, Schriften gebündelt.
- Keine rohen Werte außerhalb von `lib/theme/`. `Color(0x…)`, `Colors.*`,
  feste `BorderRadius`, `Duration` und `fontSize` in Widgets sind Fehler.
  Prüfen mit
  `grep -rnE "Colors\.|Color\(0x|BorderRadius\.circular\(|fontSize:" lib --include=*.dart | grep -v lib/theme/`.
- Elevation 0 überall, `surfaceTintColor: Colors.transparent` (im Theme),
  keine Schatten, keine Verläufe.
- Der Zustand trägt immer Wort und Zeichen. Farbe allein ist ein Fehler.
- Reduzierte Bewegung: `MediaQuery.disableAnimationsOf(context)` setzt alle
  Dauern auf `Duration.zero`.

## ColorScheme

Von Hand je Produkt und Modus. Die Namen in der rechten Spalte sind
Token-Schlüssel, `p.` steht für `color.product.<id>.<mode>`, `n.` für
`color.neutral.<mode>`, `s.` für `color.status.<mode>`.

| ColorScheme | Token |
| --- | --- |
| primary | p.accent |
| onPrimary | p.on-accent |
| primaryContainer | p.accent-tint |
| onPrimaryContainer | p.accent-text |
| secondary | p.accent-text |
| onSecondary | p.on-accent |
| secondaryContainer | n.sunken |
| onSecondaryContainer | n.text |
| tertiary | s.info |
| tertiaryContainer | s.info-tint |
| error | s.critical |
| errorContainer | s.critical-tint |
| onErrorContainer | s.critical |
| surface | n.bg |
| onSurface | n.text |
| onSurfaceVariant | n.text-muted |
| surfaceContainerLowest, surfaceContainerLow | n.surface |
| surfaceContainer, surfaceContainerHigh | n.sunken |
| surfaceContainerHighest | n.line |
| outline | n.line-strong |
| outlineVariant | n.line |
| inverseSurface / onInverseSurface | n.text / n.bg |
| surfaceTint | transparent |

`onError` ist `s.on-critical` (`#FFFFFF` in hell, `#121311` in dunkel). Bei
Panzergefecht ersetzen im Dunkeln die Werte aus `neutralDark` die `n.*`.

## ThemeExtension

Was nicht ins `ColorScheme` passt, liegt in der Extension `HorizontTheme`,
gelesen mit `HorizontTheme.of(context)` (das assertet, wenn die Extension
fehlt):

- `colors` (`HorizontColors`): alle Slots, auch `positive`, `positiveTint`,
  `warning`, `warningTint`, `critical`, `criticalTint`, `onCritical`,
  `info`, `infoTint`, `textFaint`, `accentText` und `dataRamp` (fünf
  Stufen für Heatmaps)
- `product`, `brightness`, `density`, `controlHeight`, `rowHeight`
- Textstile `data` und `kennung` (Monaspace), `reading` und `display`
  (Literata), `field` (Eingabe in Fließtext: Mona Sans 16 auf Zeile 20)
- `fieldIconButton`: der Stil für einen Symbolknopf im Feld
- `criticalButton`: der Stil für den `FilledButton` einer unumkehrbaren
  Aktion

Abstände (`HzSpace.s2 … s96`), Radien (`HzRadius.r0 … r16`), Linien
(`HzLine.hairline` 1, `selection` 2), Größen (`HzSize`, `HzIconSize`) und
Bewegung (`HzMotion.fast` 120, `base` 200, `slow` 320, `calm` 560, Kurven
`standard` `Cubic(0.2, 0, 0, 1)`, `exit`, `settle`) sind Konstanten.

**`calm` mit `settle`** ist die ruhige Stufe für Bewegung, die niemand
ausgelöst hat oder die etwas bestätigt: ein Wert, der sich ändert, ein
Diagramm, das sich aufbaut, ein Haken nach dem Speichern, ein Zähler, der
hochläuft. Nie für Navigation, Blätter oder Tippen – dort bleiben `fast` bis
`slow`, damit die Oberfläche nicht träge wirkt. Wie alle Dauern unter
reduzierter Bewegung null.

## Typografie

| TextTheme | Token |
| --- | --- |
| displaySmall | display (Literata 300, 44/48) |
| headlineMedium | headline (Literata 300, 30/36) |
| titleLarge | title-1 (24/30, 600) |
| titleMedium | title-2 (20/26, 600) |
| titleSmall | title-3 (17/24, 600) |
| bodyLarge | body (16/24) |
| bodyMedium | callout (14/20) |
| bodySmall | caption (12/16) |
| labelLarge | label (13/16, 500) |

`data` (14/20) und `kennung` (11/16, 600, Sperrung 0.08 em, Versalien über
`toUpperCase()` im Widget, nicht im String der ARB) liegen in der Extension.
Beide sind Monaspace mit `FontFeature.tabularFigures()`. Zeilenhöhe als
`height = line / size`.

Die Schriften liegen in `flutter/fonts/`: Literata (Light, Light Italic,
SemiBold), Monaspace Argon (Regular, SemiBold), Mona Sans (Regular, Medium,
SemiBold) und für Panzergefecht Mona Sans Display Expanded (Bold, Black).
Lizenzen: `OFL.txt`, `MaterialSymbols-LICENSE.txt` (über
`registerHorizontLicenses()`); das Paket selbst steht unter MIT
(`flutter/LICENSE`), das nimmt Flutter von selbst auf. Familien im
`pubspec.yaml`: `Literata`, `MonaspaceArgon`, `MonaSans`,
`MonaSansDisplayExpanded`, `MaterialSymbolsSharp`.

UI-Ikonen kommen aus `MaterialSymbolsSharp-300.ttf` (Subset, Codepoints in
`icons/material-symbols.json`), etwa
`IconData(0xea99, fontFamily: 'MaterialSymbolsSharp', fontPackage: 'horizont')` für `forest`.
Nicht das Paket `material_symbols_icons`, es bündelt alle Symbole.

## Komponenten im Theme

- **AppBar:** `elevation: 0`, `scrolledUnderElevation: 0`, Hintergrund
  `surface` (= n.bg), unten eine Haarlinie (`shape: Border(bottom:
  BorderSide(color: outlineVariant))`). Über dem Titel eine Kennung statt
  eines Large Title. Titel in `titleLarge`, Aktionen als Icon-Buttons im
  Akzent.
- **Card:** `elevation: 0`, Farbe n.surface, Radius 10, Rand
  `outline` (line-strong, wie Felder und Knöpfe). Sparsam einsetzen, Listen brauchen keine Karten. Steht ein Kasten zwischen Feldern und Knöpfen (Formular), bekommt er Radius 6 wie sie.
- **Listen:** `ListTile` mit Trennlinie, die am Text beginnt (Einzug wie das
  Leading). Meta-Zeilen (IDs, Datum) im Stil `data` klein.
- **Knöpfe:** `FilledButton` (Akzent) nur für die eine Hauptaktion,
  `OutlinedButton` (Rand line-strong, Text n.text) für die zweite,
  `TextButton` (accent-text) für leise Aktionen. Radius 6, Mindesthöhe 44 auf
  Touch und 28 mit Zeiger.
- **Felder:** `HorizontField(label:, help:, child:)` setzt die Beschriftung
  über das Feld; das `TextField` darin hat kein `labelText`, höchstens einen
  `hintText`. Der Rahmen kommt aus dem Theme: `OutlineInputBorder`, Radius
  6, Rand line-strong (3:1), im Fokus Akzent 2 px, Fehler critical mit
  Zeichen in der Hilfezeile.
- **Feldhöhe:** Jedes Feld ist genau `controlHeight` hoch, 28 mit Zeiger und
  44 auf Touch, leer wie gefüllt, mit Symbolen davor und dahinter. Der
  Rahmen richtet sich nach Zeile plus Innenabstand, nicht nach einer
  Mindesthöhe; das Theme rechnet deshalb mit der Zeile 20 (`data`) und zieht
  die Dichte ab (`isDense`, `contentPadding`, `hintStyle`, Symbolgrenzen in
  Feldhöhe). Daraus folgt eine Pflicht in der App: Ein `TextField` in
  Fließtext bekommt `style: HorizontTheme.of(context).field` (Material hat
  dafür keinen Platz im Theme, mit `bodyLarge` 16/24 wäre es 4 höher). In
  Mono reicht `style: hz.data`. Nie `constraints` oder eine feste Höhe
  setzen, das schneidet große Schrift ab.
- **Symbolknopf im Feld:** `HorizontFieldIconButton(icon:, tooltip:,
  onPressed:)` als `suffixIcon` oder `prefixIcon` (Suchen, Leeren,
  Anzeigen). So hoch und breit wie das Feld, Symbol 18. Ein normaler
  `IconButton` (40/48) macht das Feld höher.
- **Auswahlfeld:** `HorizontFieldDropdown(value:, items: [(wert, 'Wort')],
  onChanged:)` für wenige feste Werte im Formular (Tunnelart, Bedingung),
  statt eines `SegmentedButton`: ein `DropdownMenu` in Feldhöhe und voller
  Breite, ohne Tippen und Suche, der Pfeil als schlichtes Symbol. Ein
  eigenes `DropdownMenu` sitzt dank `dropdownMenuTheme` ebenfalls in
  Feldhöhe. Segmente bleiben für Ansichten (Liste, Karte).
- **Status:** ein eigenes Widget `HorizontBadge(kind, label)` mit Fläche
  `*Tint`, Zeichen (Haken, Dreieck, Achteck, Kreis) und Wort, Radius 2.
- **Auswahl als Linie:** `TabBar` mit `UnderlineTabIndicator(borderSide:
  BorderSide(width: 2, color: primary))` und `dividerColor: outlineVariant`.
  Für `NavigationRail` ein eigenes schlankes Widget, das die 2-px-Linie
  links vom Ziel zeichnet. Die Tab-Bar unten (`HorizontTabBar`) markiert
  das Ziel mit `accent-tint` (Radius 6), die Tönung umschließt Icon (24, in
  `accent-text`) und Wort (halbfett, in `text`). Den Pillen-Indikator von
  Material 3 nicht nachbauen (`indicatorColor: Colors.transparent` reicht
  nicht für die Linie).
- **SegmentedButton:** Radius 6, Rand line-strong, Auswahl mit
  accent-tint, `showSelectedIcon: false`.
- **Switch:** Spur accent, Daumen on-accent. Er ist die einzige runde Form
  neben Ortspunkt und Avatar.
- **FAB** (Touch: Telefon und Tablet, auch auf iOS; höchstens einer; mit
  Zeiger stattdessen in der Werkzeugleiste): `elevation: 0`, Radius 10,
  Akzent. Unter 600 quadratisch mit Symbol und Tooltip, ab 600
  `FloatingActionButton.extended` mit Wort (entschieden bei KNX Monitor).
- **Unumkehrbare Aktion:** `FilledButton(style:
  HorizontTheme.of(context).criticalButton)`, also `critical` mit
  `onCritical`. Die Bestätigung im Dialog mit `horizontDialogAction(…,
  primary: true, destructive: true)`.
- **Dialog, BottomSheet:** `elevation: 0`, Radius 10 (große Sheets 16),
  Rand `outline` (line-strong).
- **Divider:** outlineVariant, Dicke 1, Abstand 1.
- **Rückmeldung:** setzt das Paket je Plattform (Welle nur auf Android), siehe „Plattformgefühl“. Nicht in der App überschreiben.
- **Tab-Bar:** `HorizontTabBar` aus dem Paket. Lange Wörter bekommen in der
  ARB einen weichen Trennstrich (`Einrich\u00ADtungen`). Bei großer Schrift
  höchstens vier Ziele, sonst ab 600 die Rail. Labels nie kürzen,
  abschneiden oder verkleinern.

## Dichte und Formfaktoren

- Gebaut wird nach Breite: `LayoutBuilder` bzw.
  `MediaQuery.sizeOf(context).width` gegen 600 / 840 / 1200, nie
  `Platform.isIOS` für das Layout.
- Unter 600: Tab-Bar, eine Spalte, Rand 16. Ab 600: Rand 24, und die Ziele
  wandern in die Seitenleiste (`HorizontRail`, `HzSize.sidebar` 240).
  Ausnahme: Hat ein Bildschirm wenige gleichrangige Ansichten desselben
  Inhalts, bleiben sie unten als Tab-Bar, und das Menü wird zur
  einklappbaren Seitenleiste links (CLAUDE.md, „Ansichten unten, Menü
  links“). Ab 840 quer: Inspektor rechts (`HzSize.inspector` 300). Ab 1200:
  Raster aus Karten (mindestens `HzSize.gridCard` 240 breit). Formulare
  höchstens `HzSize.form` 400, die Suche in der Titelzeile `HzSize.search`
  320.
- Mit Zeiger (macOS, Windows, Linux, Web am Rechner):
  `VisualDensity.compact`, Steuerelemente 28, Werkzeugleiste 52, Zeilen 28,
  Hover-Zustände, Tastenkürzel. Auf Touch bleibt jedes Ziel mindestens 44.
- tvOS und Android TV: Fokus statt Zeiger. Die fokussierte Kachel skaliert
  auf 1.06 und trägt einen Akzentring (3 px, Abstand 4). Schrift × 1,5,
  sicherer Rand 60/80.
- watchOS und Wear OS: ein Wert groß in `data`, eine Aktion, schwarze
  Fläche.

## Umstellung je App

Reihenfolge: KNX Monitor (hat schon Tokens), dann Jagdaufseher, dann
Panzergefecht. Jede App in einer eigenen Sitzung und einem eigenen Branch,
mit Goldens vorher und nachher.

### KNX Monitor (`~/dev/knx-monitor/KNX-Monitor-Source`, Repo `regetskcob/KNX-Monitor-Source`, privat)

Umgestellt auf v0.6.0 (Branch `horizont`, regetskcob/KNX-Monitor#23); was
v0.6.1 aus KNX ins Paket geholt hat, steht im [CHANGELOG](../CHANGELOG.md). Was
dabei entstanden ist, steht unten unter „Referenz: KNX Monitor“. Die Punkte
hier waren der Plan:

- Theme in `lib/theme/`: `brand.dart`, `app_theme.dart` (heute
  `fromSeed(lime)` mit vielen Überschreibungen), `palette.dart` (auch für
  den PDF-Export), `tokens.dart`. Struktur behalten, Werte auf Horizont
  setzen, `fromSeed` durch das von Hand gesetzte Schema ersetzen.
- Radien 18/12/8 werden 10/6/2, Dialoge 20 werden 16, Popups 14 werden 10.
- Telegrammtypen: W (schreiben) = accent, R (lesen) = warning, A (Antwort) =
  info, immer mit Buchstabe. Die Serienfarben der Diagramme bleiben
  Datenfarben.
- Werte (Gruppenadressen, Zeiten, Messwerte) in Monaspace statt nur mit
  Tabellenziffern.
- Übernehmen, was gut ist: Aktivitätsleiste (Ø Tel./min mit Balken der
  letzten 60 s), Raumkarten mit ↙ Status und ↗ Befehl, große Werte mit
  Verlauf und Mittelwert. Abschnittsköpfe werden zu Kennungen mit Zähler.
- Icon: `LogoPainter` zeichnet heute das Telegramm. Neu ist die Busklemme
  auf dem Buskabel (siehe `web/partials/app-icon.html`, Produkt `knx`).
- Das Home-Assistant-Add-on übernimmt die Neutralen von HA, Akzent und
  Schrift bleiben: `buildHorizontTheme(HorizontProduct.knx, b, host:
  HorizontHost.homeAssistant)`, nur wenn die App in Ingress läuft.

### Jagdaufseher (`~/dev/jagdaufseher`, Repo `regetskcob/jagdaufseher`)

- Theme in `lib/app/theme.dart` (`appTheme(Brightness)` mit `fromSeed`
  #2F5D3A). Ersetzen durch ein `lib/theme/` nach diesem Leitfaden.
- Harte Farben ersetzen: Aufgabenpriorität in
  `lib/features/tasks/model/task.dart` (`Colors.blueGrey/blue/deepOrange`)
  und Zustand der Einrichtungen in
  `lib/features/facilities/model/facility.dart` (`green/orange/red/grey`)
  werden Status-Tokens mit Zeichen und Wort (gut = positive, prüfen =
  warning, defekt = critical, unbekannt = neutral). Der Ortspunkt der Karte
  (`#1A73E8`) wird info.
- Radien 16/20/10/6/4 auf die Skala bringen.
- Fünf Ziele: Übersicht, Einrichtungen, Aufgaben, Wild, Karte. Auf dem iPad
  Seitenleiste mit den vier Kennzahlen (offene Aufgaben, überfällig, prüfen,
  Strecke) am Fuß.
- Karte: Grundkarte gedämpft, Reviergrenze im Akzent, Einrichtungen als
  eckige Marker mit Zustandsrand und Kennung (`K-07`).
- Laut App-CLAUDE.md: Texte über die ARB-Dateien, Zustand mit flutter_bloc,
  jeder FAB mit eigenem `heroTag`.
- Icon: die Kanzel am Waldrand ersetzt die Leiter auf dem Verlauf.

### Panzergefecht (`~/dev/wargame`, Repo `regetskcob/wargame`)

- Theme in `lib/src/ui/theme.dart` (`GameColors`, `buildGameTheme`), Formen
  in `lib/src/ui/widgets/panel.dart` (`GameShapes`, `Plate`). Heute gibt es
  nur dunkel.
- Dunkel mit Gelände-Neutralen (`neutralDark`), Akzent Signalgelb #FFB300
  auf `on-accent` #1A1405. Hell (Store, Hilfe) mit den normalen Neutralen
  und #8F6400.
- Die Fasen an Panels entfallen, es gelten Radius 6/10 und Haarlinien. Die
  Überschriften bleiben in Versalien, schwer und gesperrt, als Spielcharakter
  (Mona Sans Display Expanded).
- Die Spielwelt bleibt unberührt: Gelände der Karten
  (`lib/src/game/map_theme.dart`), Team- und Tarnfarben
  (`lib/src/game/game_config.dart`), Flame-Komponenten.
- HUD nur in den Ecken: Panzerung oben links, Lage oben rechts, runde Karte
  unten rechts. Werte in Monaspace.
- Warteraum: Code groß in Mono, QR, „Besatzungen im Raum“, Fahrzeuge als
  Regal mit Wertebalken (Panzerung, Tempo, Wendigkeit, Feuerkraft).
- Watch: Start mit Name und einer Hauptaktion, im Gefecht nur „n übrig“ und
  die Panzerung.
- Icon: der Panzer in Seitenansicht auf dem Horizont.

## Referenz: KNX Monitor

KNX Monitor ist die erste App auf Horizont. Die folgenden Muster sind dort
gebaut und am iPhone und iPad abgenommen. Die nächsten Apps übernehmen sie,
statt eigene zu erfinden. Wird ein Muster in einer zweiten App gebraucht,
wandert es ins Paket (mit Token, Test und Tag). Pfade beziehen sich auf
`regetskcob/KNX-Monitor`.

### Aufbau des Theme-Ordners

- `lib/theme/tokens.dart`: App-Namen für Paketwerte (`Gap`, `Radii`,
  `Lines`, `Widths`, `Breakpoints`, `Motion`, `metaSeparator` = „ · “).
  Gedacht als Aliase und Ableitungen. Auf v0.6.0 stehen in `Widths` noch
  eigene Zahlen (Formular 400, Suche 320, Seitenleiste 240, Inspektor 300,
  Kartenraster 240); seit v0.6.1 gibt es sie als `HzSize.form`, `search`,
  `sidebar`, `inspector` und `gridCard`, `metaSeparator` als
  `horizontMetaSeparator`. Eine neue App nimmt die Paketwerte.
- `lib/theme/palette.dart`: `context.hz`, `context.hzTheme` und
  `context.mono(style)`. **`mono` setzt `fontFamily: HzFont.mono` und
  `package: HzFont.package` neu**; wer stattdessen die Familie eines Stils
  mit `copyWith` weiterreicht, verdoppelt das Paketpräfix und bekommt still
  die Ersatzschrift.
- `lib/theme/app_icons.dart`: App-Namen auf `HorizontSymbols`.

### Bildschirmrahmen (`lib/ui/log_view.dart`)

- **Touch unter 600:** Tab-Bar unten, Menü als eigene Seite, Suche als Zeile
  unter der AppBar.
- **Touch ab 600:** Tab-Bar bleibt unten. Menü als Seitenleiste links
  (`Widths.sidebar` 240), ein- und ausklappbar, Zustand gespeichert. Suche
  rechtsbündig in der AppBar (`Widths.search` 320).
- **Zeiger:** Ansichten als `SegmentedButton` in der Werkzeugleiste, die
  Hauptaktion daneben, kein FAB.
- **FAB-Platz:** links ein schwebender Begleiter (Pause bzw. Abspieler),
  rechts die Hauptaktion. Beide mit `FloatingActionButtonLocation.startFloat`
  in einer Zeile; der Begleiter steckt in `IntrinsicHeight`, sonst wächst er
  auf volle Höhe. Pause ist ein quadratischer Knopf mit Umriss (56 Telefon,
  48 Tablet), nie mit Wort.
- **Menü:** Gruppen mit Kennung und Zähler, Zeilen mit Haarlinie. Werkzeuge
  tragen `expertOnly`; ohne Expertenmodus eine Gruppe „Werkzeuge“. Der
  Schalter für den Expertenmodus ist am Fuß angeheftet (`MoreMenu.pinned`).

### Startbildschirm (`lib/ui/connect_screen.dart`)

- Kopf als Lockup: App-Icon, darüber eine Kennung („MIT KNX/IP-GATEWAY
  VERBINDEN“), daneben der Name in `titleLarge`.
- Unter 840 eine Spalte mit `Widths.form` (400). Ab 840 zwei Spalten im
  Verhältnis 3:2, zusammen höchstens `HzSize.page`: links das Formular mit
  der Hauptaktion, rechts Zuletzt verwendet, Kopplung, „Ohne Verbindung“
  (Demo, Aufnahmen) und die Einstellungen mit dem Expertenmodus.
- Ohne Expertenmodus nur die nötigen Felder. Weitere Felder (Port,
  Tunneladresse, Optionen, Keyring) klappen beim Umschalten mit
  `AnimatedSize` (Dauer und Kurve aus `Motion`) auf und zu, statt zu springen.
  Ein abweichender Wert bleibt sichtbar, auch ohne Expertenmodus.
- Felder mit `HorizontField` (Beschriftung darüber, nicht im Rahmen), die
  Sprachwahl als `SegmentedButton` mittig unter allem.

### Übersicht als Dashboard (`lib/ui/value_board.dart`)

- **Sektionskopf:** Kennung mit Zähler links, rechts leise Symbolknöpfe
  (Anheften, „+“, Auf-/Zuklappen). Zugeklappt steht rechts der neueste Wert
  in Mono, höchstens die halbe Zeile. Angeheftet = Symbol in `accent-text`
  auf `accent-tint`. Ist der Kopf schmal, kürzt der Begriff mit „…“, der
  Zähler bleibt (im Paket: `Kennung(title, count: n, oneLine: true)` bzw.
  `HorizontSectionHeader`).
- **Karten im Raster:** Spalten = Breite / 240 (`columnsFor`), Zeilen gleich
  hoch über `IntrinsicHeight`. Name in Sans, Wert groß in Mono, darunter
  Adresse, DPT, Zeit und Absender klein in Mono, rechts ein Verlauf mit
  gestrichelter Mittelwertlinie. Neue Werte tönen die Karte kurz in
  `accent-tint`.
- **Kleine Sektionen teilen sich eine Zeile**, solange ihre Karten zusammen
  in die Spaltenzahl passen; jede behält ihren Kopf und die Kartenbreite des
  Rasters. Sonst bleibt rechts Fläche leer.
- **Angeheftete Sektionen** liegen oben auf einem eigenen Band: `sunken`
  über die volle Breite, unten eine Haarlinie, ohne Radius.
- **Unter 600** werden aus Karten Zeilen mit Haarlinie, keine Karte pro
  Zeile.
- **Nichts springt während der Bedienung:** Neue Karten und Sektionen kommen
  ans Ende und werden erst nach 1,5 s Ruhe einsortiert.

### Auswahl wie im Dashboard (`lib/ui/address_picker.dart`)

Müssen Nutzer aus vielen Einträgen wählen (Adressen für ein Diagramm, fürs
Senden), dann nicht über Chips oder lange Häkchenlisten, sondern in der
Ansicht, die sie kennen: dieselben Sektionen und Karten, mit Werten.

- Vollbild-Dialog (`fullscreenDialog`), links Schließen, rechts ein
  `FilledButton` „Übernehmen · n“.
- Unter der AppBar ein Filterfeld mit der Filtersprache der App, daneben
  „gewählt / möglich“ in Mono, bei erreichter Höchstzahl in `warning`.
- Häkchen je Karte (oben rechts) und je Sektion (im Kopf: alle/keine).

### Kennzahlen und Werte

- `HorizontMetric` (in KNX `Metric`): Kennung als Begriff, darunter der Wert
  in Mono in der Größe von `titleMedium`, eine Größe für alle; Zustand als
  Parameter (Zeichen und Farbe, das Wort steht im Begriff).
  `HorizontMetricRow` bricht um, statt zu verkleinern.
- `AddressTitle`: Adresse in Mono, Name dahinter in Sans.
- Telegrammtyp als quadratisches Kennzeichen mit Buchstabe (W/R/A), Radius 2,
  Fläche `*-tint`, wächst mit der Schrift (im Paket:
  `HorizontLetterBadge`).
- Ein Zustand im Fließtext als Zeichen und Wort in der Statusfarbe
  (`HorizontStatusLine`), eine leere Ansicht mit `HorizontEmptyHint`.
- Aktivitätsleiste: Kennzahlen nebeneinander in einer Größe, die Balken der
  letzten 60 s rechts bündig auf derselben Grundlinie.

### Hinweise und Gefahr (`lib/ui/replay_sheet.dart`)

- **Hinweis:** Zeile auf `*-tint`, Radius 6, Zeichen in der Statusfarbe,
  Text in `text`. Für Warnungen vor einer Aktion, nicht als Ersatz für das
  Status-Badge.
- **Unumkehrbare Aktion:** Hinweis (warning) oben, Auswahl und Optionen in
  der Mitte, unten rechts ein `FilledButton` in `critical` mit Anzahl im Wort
  („122 Telegramme senden“). Danach `showAdaptiveDialog` mit Anzahl, Ziel und
  „lässt sich nicht rückgängig machen“. Während sie läuft, schließt das
  Sheet nur über „Stopp“ (`PopScope`, `isDismissible: false`), Fortschritt
  als Linie und `Metric`s.
- **Original bleibt:** Wer Daten vor so einer Aktion bearbeitet, arbeitet auf
  einer Kopie; „Als Kopie speichern“ und „Zurücksetzen“ erscheinen erst, wenn
  etwas geändert ist.

### Sekundärfunktion per langem Druck

Ein langer Druck darf eine Variante der Aktion auslösen (Aufnahme mit 10 s
Vorlauf), nie etwas anderes. Dann: Tooltip auf Touch abschalten
(`TooltipTriggerMode.manual`, mit Zeiger bleibt er), im Tooltip-Text die
Variante nennen, `Semantics(onLongPressHint:)` setzen,
`HapticFeedback.mediumImpact` und eine Snackbar, die sagt, was passiert ist.

### Diagramme und Zeitreihen

- Serienfarben sind Datenfarben (`Palette.series`), keine Statusfarben.
  Legende als `InputChip` mit eckigem Farbfeld, Wert unter dem Fadenkreuz in
  Mono.
- Eine Achse je Einheit, die Einheit steht in jeder Beschriftung, nicht
  zusätzlich darüber; Beschriftungen einzeilig mit „…“.
- Die Diagramme teilen sich die Bildschirmhöhe, bis der Nutzer eine Höhe
  zieht.
- Gespeicherte Diagramme gehören zur Anlage (Projekt, sonst Gateway), nicht
  zum Gerät.
- Heatmaps färben mit `colors.dataRamp` (fünf Stufen, ein Ton), nicht mit
  dem Akzent in Transparenz; die Legende nennt die Werte der Stufen.
- Heatmaps wählen die Auflösung nach der Zeitspanne: bis 1 h je Minute, bis
  12 h je 5 Minuten, bis 7 Tage Tag × Stunde, darüber Wochentag × Stunde. Die
  Auflösung steht in der Kennung („AKTIVITÄT · JE MINUTE“).
- Abspielen einer Aufzeichnung: schwebende Leiste im FAB-Platz, über dem
  Regler die Dichte der Ereignisse als Balken, Zeiten in Mono.

### Prüfen

- Goldens (`test/golden_test.dart`, Tag `golden`) für Telefon, iPad und Mac,
  hell und dunkel, Textgröße 1, das Telefon auch 2. Live-Daten über eine timerfreie
  Simulation mit fester Uhr, sonst hängen die Tests. Die Schriften lädt
  `loadHorizontFonts()` aus `package:horizont/testing.dart`.
- CI schließt die Goldens aus (`--exclude-tags golden`); sie werden lokal
  erzeugt und angesehen.

## Prüfen vor dem Abschluss

- Goldens in hell und dunkel, bei Textgröße 1.0 und 2.0, LTR.
- Kein roher Wert außerhalb von `lib/theme/` (grep oben).
- Jeder Status mit Wort und Zeichen, Screenreader-Label inklusive.
- Kontrast: Text mindestens 4,5:1, große Schrift, Umrisse von
  Bedienelementen und Linien, die einen Zustand zeigen, 3:1. Die
  Token-Paare sind geprüft (`flutter/test/contrast_test.dart`), eigene
  Kombinationen nicht.
- Auf einem echten Gerät ansehen. Store-Screenshots kommen in den
  Geräterahmen der Doku.
