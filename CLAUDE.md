# Horizont – Hinweise für Claude

Horizont ist das Designsystem von regetskcob (Blog) und den Projekten
**Jagdaufseher**, **KNX Monitor** und **Panzergefecht**. Dieses Repository ist
die einzige Quelle: Tokens, Web-Schicht, Marken, Icons und die Dokumentation
unter https://www.regetskcob.de/horizont/.

Wer eine Oberfläche baut oder ändert, egal ob Flutter-App, Landingpage, Blog
oder Store-Bild, liest zuerst diese Datei und dann den passenden Leitfaden:

- [docs/flutter.md](docs/flutter.md): Umsetzung in den Flutter-Apps (iOS,
  iPadOS, Android, macOS, Windows, Linux, Web, tvOS, watchOS)
- [docs/web.md](docs/web.md): Umsetzung im Web (Hugo-Seiten, Landingpages,
  Blog, Web-Apps)

Im Zweifel gilt die gerenderte Dokumentation (`site/layouts/home.html`). Sie
liest dieselben Tokens und zeigt jede Regel an einem Beispiel.

## Leitbild

**Minimalistisch wie die niederrheinische Feldflur.** Weites Land, ein tiefer
Horizont, wenige klare Linien: Feldränder, Gräben, eine Reihe Kopfweiden.
Daraus folgen alle Regeln:

| Feldflur | Oberfläche |
| --- | --- |
| weiter Himmel | Weißraum, der Bildschirm darf leer sein |
| Feldränder, Gräben | 1-px-Haarlinien ordnen, nichts schwebt |
| Äcker, Wiesen | Flächen ohne Rahmen und Schatten, nur Ton und Linie |
| der eine Baum | genau ein Akzent: die Hauptaktion und die Auswahl |
| tiefer Horizont | die Linie auf dem unteren Drittel, in Marke und Hero |
| Jahreszeiten | hell und dunkel, beide von Hand gesetzt, gleichwertig |

Hinter dem System steht ein Anspruch: Die Projekte sollen ganzheitlich im
Alltag der Nutzer ankommen, vom Handgelenk bis zum Fernseher. Eine Funktion
wird daher für alle Formfaktoren mitgedacht, nicht nur für das Telefon.

## Die sechs Regeln

1. **Inhalt vor Oberfläche.** Werte, Bilder und Texte tragen. Karten und
   Rahmen nur, wo sie etwas ordnen, Listen bekommen keine Karte pro Zeile.
2. **Linien statt Schatten.** Keine Elevation, kein Glow und keine Verläufe
   in der Oberfläche. Systemschatten (macOS-Fenster, iOS-Menüs) bleiben.
   Ausnahme: App-Icons, die sind Bilder.
3. **Eine Farbe pro Produkt.** Alles andere ist Papier und Tinte. Der Akzent
   markiert nur die Hauptaktion und die Auswahl, Status hat eigene Farben.
4. **Drei Stimmen.** Literata für das, was man liest (Überschriften der
   Landingpages, Fließtext, Onboarding). Mona Sans für das, was man bedient
   (Überschriften von Panzergefecht: Mona Sans Display Expanded).
   Monaspace Argon für das, was gemessen wird (Werte, Zeiten, Adressen,
   IDs, Koordinaten), immer mit Tabellenziffern.
5. **Zustand nie nur als Farbe.** Jeder Status hat Wort, Zeichen und Farbe:
   Haken (positive), Dreieck (warning), Achteck (critical), Kreis (info).
6. **Plattform ja, Mode nein.** Navigation, Gesten, Systemdialoge,
   Tastenkürzel und Teilen folgen der Plattform. Farbe, Schrift, Linie,
   Abstand und Ton folgen Horizont. Jede App soll sich auf ihrer Plattform
   nativ anfühlen: Das Paket hält Rückmeldung, Übergänge, Zurück-Gesten,
   Dichte und adaptive Widgets nativ (`docs/flutter.md`, „Plattformgefühl“),
   und die App baut keine Systemdialoge nach. Bewusst abweichend sind nur
   Mona Sans, die Kennung mit linkem Titel, die Auswahl als Linie, die
   Tab-Bar unten mit Tönung statt Linie und die Hauptaktion als FAB auch
   auf iOS (in der Leiste des iPhones war sie kaum lesbar). Alle fünf sind
   entschieden, siehe unten.

## Erkennungszeichen

- **Kennung:** kleine Mono-Versalien mit Sperrung (`kennung` in der
  Typo-Skala, 11/16, 600, 0.08em, uppercase, `text-muted`). Sie benennt
  Abschnitte, IDs und Lagen, etwa `EINRICHTUNGEN · 14`, `HEGERING NORD ·
  412 HA` oder `01 — IN ENTWICKLUNG`. Sie ersetzt Eyebrow-Pillen und
  Abschnittstitel. Über dem Seitentitel steht eine Kennung statt eines Large
  Title (entschieden, siehe unten).
- **Auswahl ist eine Linie:** 2 px im Akzent, unter dem aktiven Tab, links
  an der gewählten Zeile, unten im Segment. Nie eine Pille als Indikator.
  Ein Tint (`accent-tint`) darf dazukommen. Ausnahme Tab-Bar unten: dort
  liegt das gewählte Ziel auf `accent-tint` (Radius 6, die Tönung umschließt
  Icon und Wort), das Icon 24 in `accent-text`, das Wort halbfett in `text`,
  ohne Linie (entschieden, siehe unten).
- **Fokus:** 2 px Akzent mit 2 px Abstand, auf dem Fernseher 3 px.
- **Felder:** Die Beschriftung steht über dem Feld (`label`, 13/16, 500, in
  `text`), nie schwebend im Rahmen; darunter höchstens eine Hilfezeile
  (Flutter `HorizontField`, Web `.hz-field`). Ein Feld ist genau so hoch wie
  ein Knopf: 28 mit Zeiger, 44 auf Touch, auch mit Symbolen und leer. Wenige
  feste Werte im Formular sind ein Auswahlfeld (`HorizontFieldDropdown`),
  kein Segment; Knöpfe im Feld nimmt `HorizontFieldIconButton`.
- **Lockup:** Steht eine Marke neben einem Namen, liegt ihre Horizontlinie
  auf der Grundlinie des Textes (web: `.hz-lockup`). Marke und Text nie
  mittig zueinander ausrichten.
- **Wert und Begriff:** In Faktenlisten stehen Begriff (Kennung) und Wert
  auf einer Grundlinie. Die Begriffsspalte hat eine feste Breite, damit
  Listen untereinander bündig stehen.
- **Status-Badge:** Fläche `*-tint`, Text und Zeichen in der Statusfarbe,
  Radius 2.
- **Navigation im Web ist der Horizont** (ab v0.7.0, `horizont/nav/
  horizon.html`): keine Menüleiste, kein Hamburger, keine Dropdowns. Eine
  Linie, das Zeichen der Seite steht darauf und wandert beim Lesen mit;
  links davon ist die Linie im Akzent nachgezogen. Kapitel sind Striche an
  ihrer echten Stelle, der Titel hängt klein unter dem Strich, der aktuelle
  dunkel und ganz; wo Kapitel eng liegen, nur die Nummer. Im Blog-Index
  sind die Striche Jahre, so hoch wie ihre Beiträge. Mit Zeiger steht die
  Linie oben, auf Touch unten (Streichen springt). Das Zeichen öffnet die
  Flurkarte (`horizont/nav/karte.html`): alle Seiten der Familie als Felder
  von oben, Fläche nach Inhalt, die Produkte hinter einem Feldweg; Daten in
  `tokens/flur.yaml`. Ein Produkt mit eigener Domain zeigt dort nur seine
  eigene Gemarkung (`map`, `projects`). Ohne JavaScript bleiben Ankerlinks
  und die Seite `/karte/`. Die Apps behalten ihre eigene Navigation.

## Werte (Tokens)

Alle Werte stehen in [tokens/horizont.json](tokens/horizont.json). Dort und
nur dort werden sie geändert. Nie Farben, Größen oder Zeiten hart in eine App
oder Seite schreiben.

- **Neutrale** (hell/dunkel): `bg`, `surface`, `sunken`, `line`,
  `line-strong` (der Umriss, mindestens 3:1 zu `bg`, `surface` und
  `sunken`), `text`, `text-muted`, `text-faint` (nur dekorativ, kein
  Lesetext). Sie haben einen Hauch Oliv, kein reines Grau.
- **Status:** `positive`, `warning`, `critical`, `info`, jeweils mit `-tint`,
  dazu `on-critical` (Schrift auf einer Fläche in `critical`).
- **Daten:** `color.data` ist eine sequenzielle Rampe in fünf Stufen (ein
  Ton, wenig nach viel) für Heatmaps und Dichten, im Dunkeln umgekehrt
  verankert. Sie ist weder Akzent noch Status; der Wert steht immer auch in
  Legende oder Beschriftung. Serienfarben von Diagrammen gehören der App.
- **Produkte** (`color.product.<id>`, ids `regetskcob`, `jagdaufseher`,
  `knx`, `panzergefecht`): `accent` (Fläche der Hauptaktion), `on-accent`,
  `accent-tint` (Auswahl-Hintergrund), `accent-text` (Text, Links, Linien,
  mindestens 4,5:1).

  | Produkt | Akzent | hell | dunkel |
  | --- | --- | --- | --- |
  | regetskcob | Tinte | #1B1C19 | #E7E7E0 |
  | Jagdaufseher | Tanne | #2F5D3A | #6CCB8A |
  | KNX Monitor | Bus | #437F18 | #9BD45E |
  | Panzergefecht | Signalgelb | #8F6400 | #FFB300 |

- **Gastgeber** (`color.host.<id>`, bisher `home-assistant`): Läuft ein
  Produkt eingebettet, etwa das KNX-Monitor-Add-on in Home Assistants
  Ingress, nimmt es die Neutralen des Gastgebers
  (`buildHorizontTheme(…, host: HorizontHost.homeAssistant)`). Akzent,
  Status, Schrift und Linien bleiben Horizont. Gastgeber gibt es nur in
  Flutter: Eingebettet läuft die App, keine Hugo-Seite, deshalb kennt
  `web/css/tokens.css` kein `[data-host]`.
- **Gelände:** Panzergefecht hat im Dunkeln eigene, olivgetönte Neutrale
  (`neutralDark`). Das ist die einzige Ausnahme, und sie gilt nur für die
  Neutralen. Spielwelt-Farben (Teams, Tarnanstriche, Kartengelände) gehören
  dem Spiel, nicht dem System.
- **Typo-Skala:** `display`, `headline` (Literata 300), `title-1/2/3`,
  `body`, `callout`, `label`, `caption` (Mona Sans), `reading` (Literata
  18/28), `data` und `kennung` (Monaspace). Die Größen sind die
  Standardgröße. In Apps skaliert alles mit der Systemschrift, nichts wird
  geklemmt oder abgeschnitten.
- **Abstand:** 4er-Raster, nur `0 2 4 8 12 16 24 32 48 64 96`.
- **Radien:** `0` Tabellen, `2` Status und Kennzeichen, `6` Knöpfe und
  Felder, `10` Karten und Sheets, `16` nur große Sheets. Was in einer Reihe
  mit Feldern und Knöpfen steht (Kasten im Formular, Hinweis über einem
  Knopf, Kachel in einer Seitenleiste), nimmt deren Radius 6, nicht den der
  Karte: Nebeneinander sollen Rundungen gleich sein. `10` nur für frei
  stehende Karten (Raster, Übersicht) und Sheets. Rund ist nur, was
  rund sein muss (Schalter, Ortspunkt, Avatar). Keine Pillen-Knöpfe, keine
  Pillen-Chips.
- **Linien:** 1 px Haarlinie, 2 px Auswahl und Fokus. Ein Umriss, eine
  Farbe: Alles mit Rahmen (Karte, Feld, Knopf, Segment, Chip,
  Kontrollkästchen, Dialog, Sheet, Menü) trägt die Haarlinie in
  `line-strong`, ebenso die Spur des ausgeschalteten Schalters.
  `line-strong` hat mindestens 3:1 zu jeder Fläche, damit Felder und Knöpfe
  als Bedienelement erkennbar sind (WCAG 1.4.11). `line` trennt nur Zeilen
  und Abschnitte (Listen, Kopf- und Fußlinien) und bleibt leise. So stehen
  Karte und Feld nebeneinander gleich.
- **Bewegung:** 120 / 200 / 320 ms, Kurve `cubic-bezier(0.2, 0, 0, 1)`, ohne
  Federn. Dazu die ruhige Stufe `calm` 560 ms mit der Kurve `settle`
  (`cubic-bezier(0.16, 1, 0.3, 1)`, läuft weich aus, schwingt nicht über),
  nur für Bewegung, die niemand ausgelöst hat oder die etwas bestätigt:
  ein Wert, der sich ändert, ein Diagramm, das sich aufbaut, ein Haken nach
  dem Speichern. Nie für Navigation, Blätter oder Tippen. Bei reduzierter
  Bewegung alles 0.
- **Größen:** Tippziel 44, Zeile 44, dichte Zeile 28. Mit Zeiger (Mac,
  Web-App am Rechner) sind Steuerelemente 24 bis 28 hoch
  (`control-desktop`), die Werkzeugleiste 52 (`toolbar-desktop`). Breiten:
  Lesespalte 720 (`text-column`), Seite 1120 (`page`), Formular 400
  (`form`), Suche in der Titelzeile 320 (`search`), Seitenleiste 240
  (`sidebar`; mit Zeiger darf sie bis 200 schmal werden, `rail`), Inspektor
  300 (`inspector`), Karte im Raster mindestens 240 (`grid-card`).
- **Symbolgrößen** (`icon-size`): 14 im Status-Badge, 16 in einer
  Textzeile, 18 in Zeilen und Seitenleisten, 22 in Leisten und Knöpfen, 24
  in der Tab-Bar.
- **Fenstergrößen:** kompakt < 600, mittel < 840, erweitert < 1200, groß ab
  1200. Gebaut wird nach verfügbarer Breite, nie nach Gerät.
- **Geräterahmen:** Hardwarefarben unter `device`.

## Formfaktoren

| Gerät | Aufteilung |
| --- | --- |
| iPhone (kompakt) | Kopf mit Kennung und kleinem Titel, höchstens eine Kennzahlenleiste, Abschnitte mit Kennzeile, Tab-Bar mit 3 bis 5 Zielen. Die eine Hauptaktion als FAB (alle Touch-Plattformen), am Telefon nur mit Symbol, ab 600 mit Wort. |
| iPad (mittel/erweitert) | Hauptaktion als FAB, ab 600 mit Wort. Seitenleiste statt Tab-Bar, Kennzahlen am Fuß der Seitenleiste, Inhalt in der Mitte, Inspektor rechts (quer). Ebenen und Werkzeuge sitzen auf einer Fläche mit Haarlinie. Ausnahme: wenige gleichrangige Ansichten eines Inhalts (KNX Monitor: Übersicht, Objekte, Live) bleiben unten als Tab-Bar, das Menü wird zur einklappbaren Seitenleiste (entschieden, siehe unten). |
| Mac (groß) | Werkzeugleiste 52 mit Umschalter, Suche und der Hauptaktion (kein FAB mit Zeiger), Seitenleiste 200 bis 240 mit Kennungen, Inhalt als Raster aus Karten (mindestens 240), Inspektor 300. Dichte Zeilen, Tastatur zuerst. |
| Apple TV | Sicherer Rand 60/80, Schrift × 1,5. Titel mit Kennung, ein Regal aus großen Kacheln, unten Details und eine Aktion. Fokus: Kachel +6 % und Akzentring. HUD im Spiel nur in den Ecken, die Mitte bleibt frei. |
| Apple Watch | Uhrzeit oben rechts, ein Wert groß in Mono, eine Aktion. Die Krone blättert. Fläche schwarz oder Gelände. |
| Landingpage | „Feldseite“: Kopf mit Lockup, Hero links mit Kennung und Literata-Überschrift, rechts das Produkt im Geräterahmen, darunter die Horizontlinie (2 px Akzent), nummerierte Abschnitte mit Kennung links und Fakten in Mono, Fuß „ein Projekt von regetskcob“. Kein zentrierter Hero, kein Kachelraster, keine Badge-Pille. |

Karten (Jagdaufseher): Die Grundkarte bleibt ruhig wie die Feldflur. Farbe
tragen nur Reviergrenze (Akzent, 2,5 px), Auswahl und Zustand der
Einrichtungen.

## Marken und Icons

- **Marke:** eine Linie auf dem unteren Drittel, darauf ein Gegenstand:
  Buche (regetskcob), Kanzel (Jagdaufseher), Busklemme rot/grau auf dem
  grünen Buskabel (KNX Monitor), Panzer in Seitenansicht (Panzergefecht).
  Dazu drei Glyphen ohne App-Icon: das offene Buch für den Blog, die
  Sonne auf der Linie für Horizont und der Prompt `>` leicht über der
  Linie schwebend für Kalkar IT Solutions, die Linie ist sein Cursor; als
  Wanderer steht der Prompt in Weidengrün (`color.mark.kalkar-it`), und
  für Avatare gibt es ein flaches Bild mit der Buche klein im Hintergrund
  (`app-icon.html`, `product` "kalkar-it") (`mark.html`, `product` "blog",
  "horizont" bzw. "kalkar-it"). Kalkar IT ist kein Produkt der Familie und
  hat keine eigenen Farben; die Seite nimmt den Akzent Tinte.
- **App-Icon:** illustriert (`web/partials/app-icon.html`). Die Bühne ist
  Himmel oben und Boden unten mit einer hellen Horizontlinie bei zwei
  Dritteln. Davor steht ein Gegenstand in drei Tönen mit dunkler Kontur (1,6
  von 100) und weichem Schatten nach rechts unten. Farben unter
  `color.product.<id>.icon`.
- **Plattform-Sätze:** `icons/export/<produkt>/` (iOS, watchOS, macOS,
  Android adaptiv mit monochrom, tvOS in Ebenen, Web). Erzeugt von
  `tool/export_icons.py` aus den Partials; Icons in den Apps nie von Hand
  zeichnen oder skalieren, sondern kopieren. Nach einer Änderung an Icon oder
  Farben das Skript neu laufen lassen.
- **Glyphe** für Kopf, Fuß und Favicon unter 32 px:
  `web/partials/mark.html`, Strich 7 von 100, eckige Enden.
- **Absender:** Jedes Produkt trägt in Fußzeile, Über-Dialog und Store-Text
  „ein Projekt von regetskcob“ mit der Glyphe.
- **UI-Ikonen:** Material Symbols **Sharp**, Strichstärke 300, als Subset
  (`flutter/fonts/MaterialSymbolsSharp-300.ttf`,
  `web/fonts/MaterialSymbols/…woff2`). Es enthält genau die Namen aus
  `icons/material-symbols.txt`, die Codepoints stehen in
  `icons/material-symbols.json`. Eine Zeile `name:fill` nimmt die gefüllte
  Form dazu (`name_fill`, etwa `star_fill`, `push_pin_fill`); gefüllt heißt
  „an“ (angeheftet, Favorit), nie Zierde. Fehlt ein Symbol: Namen in die Liste
  eintragen, dann `tool/build_symbols.py` neu laufen lassen (Anleitung im
  Kopf der Datei). Nie den ganzen Font bündeln. Die SVGs in
  `web/partials/icons.html` sind Platzhalter der Doku.

## Screenshots

Jeder Screenshot steht in seinem Geräterahmen: iPhone, Android, iPad,
MacBook, Fernseher oder Watch. Minimal, aber realistisch: echte Proportionen,
Kamera-Aussparung, Seitentasten, Standfuß. Keine Spiegelung, keine
Perspektive, kein Schatten, nur Schwarz und Aluminium. Titelleisten und
Steuerelemente im Rahmen haben die Größe, die sie auf dem echten Bildschirm
hätten.

## Entscheidungen (v0.2)

Vom Nutzer entschieden (regetskcob/horizont#1). Nicht wieder aufmachen,
ohne zu fragen:

- **Zwei Grün bleiben.** Tanne für Jagdaufseher, Bus (Lime) für KNX Monitor.
  Im Dunkeln trägt Jagdaufseher ein leuchtendes Grün (#6CCB8A, Text
  #7ED399), kein blasses Mint.
- **Mona Sans** ist die Bedienschrift (SIL OFL 1.1, kostenlos, auch
  gewerblich und gebündelt in Apps nutzbar, nur nicht allein verkäuflich).
  Sie liegt mit Literata und Monaspace in `web/fonts/` (WOFF2) und
  `flutter/fonts/` (TTF/OTF).
- **Kennung statt Large Title auf iOS:** über dem kleinen Titel steht eine
  Kennung, der große iOS-Titel wird nicht genutzt.
- **Gelände** ist als einzige Ausnahme freigegeben: Panzergefecht hat im
  Dunkeln eigene Neutrale.
- **Tab-Bar mit Tönung statt Linie** (entschieden bei KNX Monitor): Die
  2-px-Linie über dem gewählten Tab wirkte am Gerät wie ein Fehler. Das
  gewählte Ziel liegt auf `accent-tint` (Radius 6, keine Pille), die Tönung
  umschließt Icon und Wort und füllt nicht das ganze Feld. Icon 24 in
  `accent-text`, Wort halbfett in `text`.
- **Hauptaktion als FAB auf Touch** (entschieden bei der Umstellung von KNX
  Monitor, regetskcob/KNX-Monitor#23): Auf Telefon und Tablet steht die eine
  Hauptaktion als schwebender Knopf, auf iOS wie auf Android. Oben in der
  Leiste neben Kennung, Titel und Symbolen war sie am iPhone kaum lesbar.
  Unter 600 ist der FAB quadratisch (56) mit Symbol und Tooltip, ab 600
  `extended` mit Wort. Mit Zeiger (Mac, Windows, Linux) sitzt sie in der
  Werkzeugleiste, kein FAB.
- **Ein Umriss mit 3:1** (entschieden für v0.6.1): `line-strong` wurde
  dunkler, statt einen eigenen Rand für Bedienelemente einzuführen. Karten,
  Dialoge und Sheets tragen damit dieselbe, kräftigere Linie wie Felder und
  Knöpfe; die eine Umrissfarbe bleibt.

## Entscheidungen aus KNX Monitor (v0.6.0 und danach)

KNX Monitor ist die erste App auf Horizont. Was der Nutzer dort am Gerät
entschieden hat, gilt für alle folgenden Apps. Die Muster dazu mit Code
stehen in [docs/flutter.md](docs/flutter.md), „Referenz: KNX Monitor“.

- **FAB am Telefon nur mit Symbol** (die Regel steht oben unter
  „Hauptaktion als FAB auf Touch“). Ein Umschalter, der neben der
  Hauptaktion im FAB-Platz steht (Pause), trägt nie ein Wort. Beide stehen
  in einer Flucht und gleich hoch. Während eine Suche den Fokus hat,
  verschwinden sie.
- **Ansichten unten, Menü links.** Hat ein Bildschirm wenige gleichrangige
  Ansichten desselben Inhalts, bleiben sie auch auf dem Tablet unten als
  Tab-Bar. Das Menü (Werkzeuge, Daten) wird ab 600 zur Seitenleiste links,
  ein- und ausklappbar, der Zustand bleibt gespeichert. Links in der Leiste
  steht erst Zurück, dann der Umschalter der Seitenleiste. Mit Zeiger wird
  die Tab-Bar zum `SegmentedButton` in der Werkzeugleiste.
- **Suche in der Titelzeile.** Ab 600 sitzt das Suchfeld rechtsbündig in der
  AppBar statt als eigene Zeile darunter.
- **Das Menü heißt „Menü“**, nicht „…“ oder „Mehr“.
- **Expertenmodus statt Einstellungsseite für Fachfunktionen.** Ein Schalter,
  fest am Fuß des Menüs (eigene Fläche `sunken` mit Haarlinie oben) und auf
  dem Startbildschirm. Ohne ihn sieht man nur die Alltagswerkzeuge in einer
  Gruppe „Werkzeuge“. Was Expertenmodus ist, legt die App fest und schreibt
  es in ihr README.
- **Unumkehrbares nur mit Bestätigung, in critical.** Eine Aktion, die nach
  außen wirkt und sich nicht zurücknehmen lässt (KNX: Aufnahme auf den Bus
  senden), steht nie als Hauptaktion im Akzent. Sie zeigt vorher einen
  Hinweis (warning) und fragt mit `showAdaptiveDialog` nach. Ihr Knopf ist
  ein `FilledButton` in `critical` mit Schrift in `on-critical`
  (`HorizontTheme.of(context).criticalButton`), der Bestätigungsknopf
  `destructive` (`horizontDialogAction(…, destructive: true)`).
- **Auswahl auf Karten:** Eine gewählte Karte trägt 2 px Akzent als Umriss
  und `accent-tint` als Fläche, dazu ein Häkchen oben rechts. Das ist die
  „Auswahl ist eine Linie“ für Karten, keine Ausnahme.
- **Datenlisten nutzen die Seitenbreite.** `HzSize.textColumn` (720) gilt für
  Text, den man liest. Listen von Daten (Aufnahmen, Prüfergebnisse) gehen auf
  dem Tablet bis `HzSize.page` (1120), sonst bleibt rechts und links zu viel
  leer.
- **Startbildschirm in Systemweiß und -schwarz.** Der native Launch Screen
  kann keine Token-Farben, also liegen Icon und Fläche auf reinem Weiß bzw.
  Schwarz, vorgeflacht als PNG. Der Flutter-Splash danach nimmt dieselben
  Werte, sonst springt die Farbe beim Übergang.

Neue offene Fragen kommen als Issue mit dem Label `question` und werden vom
Nutzer entschieden, nicht von der Sitzung.

## Arbeitsweise in diesem Repository

- Werte nur in `tokens/horizont.json` ändern. CSS (`web/css/tokens.css`)
  und Doku lesen sie von dort.
- Aufbau: `tokens/` (Quelle), `web/` (wiederverwendbare Web-Schicht: CSS,
  Partials, Schriften), `flutter/` (das Paket `horizont` mit Schriften,
  Showcase-App unter `flutter/example/` und Tests), `icons/` (Liste und
  Codepoints der Symbole), `tool/` (`generate_tokens.dart`,
  `build_symbols.py`, `subset_fonts.py`), `site/` (nur die Dokumentationsseite).
- Nach jeder Änderung an `tokens/` oder `icons/`:
  `dart run tool/generate_tokens.dart`, dann `cd flutter && flutter test`.
  Die Kontrasttests sind die AA-Prüfung des ganzen Systems. Schlägt einer
  fehl, wird der Token korrigiert, nicht der Test. Goldens nach einer
  bewussten Änderung mit `cd flutter/example && flutter test
  --update-goldens` neu erzeugen und ansehen.
- Jede Änderung, die Apps oder Seiten betrifft, kommt in
  [CHANGELOG.md](CHANGELOG.md) unter die nächste Version.
- Versionen: Tokens (`version` im JSON), Paket (`flutter/pubspec.yaml`) und
  Git-Tag (`v0.8.7`) laufen gemeinsam. Die Apps hängen an einem Tag, nie an
  `main`. Hugo hängt die
  Ordner per `module.mounts` ein (`hugo.toml`).
- Lokal ansehen:
  `hugo server --baseURL http://localhost:1313/horizont/`
- Prüfen vor jedem Commit: hell und dunkel, 375 px Breite ohne horizontalen
  Überlauf, keine Konsolenfehler. Bei Lockups und Faktenlisten die
  Grundlinien nachmessen, nicht nur ansehen.
- **Jeder Push auf `main` geht sofort live** (GitHub Pages, Projektseite
  unter `/horizont/`). Vor dem Push ausdrücklich nachfragen.
- Commit-Nachrichten auf Englisch, Betreff als Satz, im Text das Warum.
  Code-Kommentare englisch, Oberflächentexte deutsch. Keine Geburtsdaten,
  Wohnorte oder andere persönlichen Angaben in Texten.
- **Hugo:** Landingpages und Blog setzen sich aus den Partials unter
  `web/partials/` (Lockup, Geräterahmen, Kennung, Badge, Symbol, Fakten,
  Feldseite) und den Shortcodes unter `web/shortcodes/` (`hz-device`,
  `hz-kennung`, `hz-badge`, `hz-symbol`, `hz-facts`) zusammen, nie aus
  nachgebautem HTML. Die Mounts stehen in `docs/web.md`. Fehlt ein Baustein,
  kommt er hierher, nicht in die Seite.
- **Wer Horizont nutzt:** der Blog (Hugo-Modul, in `go.mod` auf einen Tag
  gepinnt, derzeit v0.8.2; heben mit `hugo mod get
  github.com/regetskcob/horizont@v0.8.2`) und die Vorschau unter
  `/preview/` (Repository `regetskcob/preview`). KNX Monitor ist die
  Referenz für die anderen Apps (App auf v0.6.1, Landingpage auf v0.7.9);
  Jagdaufseher läuft auch im Browser (App auf v0.7.7; die Landingpage ist
  seit 22.10.2026 offline und das Projekt nicht auf der Flurkarte); Panzergefecht hat Spiel und Landingpage auf v0.7.8
  (regetskcob/wargame#31), siehe [docs/flutter.md](docs/flutter.md). Für
  Apps ändern v0.6.3, v0.7.9 (`calm` und `settle`) und v0.8.0 (Feldhöhen,
  `HorizontFieldIconButton`, `HorizontFieldDropdown`) das Paket, die
  übrigen 0.7er-Tags nur das Web und die Exporte.
