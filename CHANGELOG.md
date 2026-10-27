# Änderungen

Jede Version gilt zugleich für Tokens (`tokens/horizont.json`), das
Flutter-Paket (`flutter/pubspec.yaml`) und den Git-Tag. Apps und Seiten hängen
an einem Tag; unter „Heben“ steht, was beim Wechsel zu tun ist.

## 0.8.10

App-Icon für Kalkar Kompakt.

### Neu

- **Kalkar Kompakt** (`color.mark.kalkar-kompakt`, `app-icon.html`,
  `mark.html`): Die Bürger-App von Kalkar IT ist kein Produkt der Familie
  (keine Akzentfarbe), bekommt aber ein App-Icon: das Rathaus Kalkar auf der
  Linie, Backstein unter Schieferdach, der Turm mit Uhr und rotem Wappen,
  davor Kopfsteinpflaster. Die Glyphe ist der Umriss des Rathauses.
  `tool/export_icons.py` erzeugt `icons/export/kalkar-kompakt/`.

### Heben

Nichts zu tun; Kalkar Kompakt kopiert die Icons aus `icons/export/kalkar-kompakt/`.

## 0.8.9

Das Favicon ist das App-Icon.

### Geändert

- **Favicon** (`site/layouts/home.html`, `tool/export_icons.py`): Der
  Browser-Tab zeigt das App-Icon jedes Produkts, dasselbe Bild wie der
  Homescreen, statt der Glyphe auf ihrem Feld. `icons/export/<produkt>/web/`
  liefert `favicon.svg` und `favicon-32.png` aus dem App-Icon. Die Glyphe
  bleibt für Kopf und Fuß und als Favicon nur, wo ein Produkt sie in
  `$glyphFavicon` ausdrücklich wünscht oder kein App-Icon hat (Blog,
  Horizont, Kalkar IT).

### Heben

- Apps und Seiten, die ihr Favicon aus `icons/export/<produkt>/web/`
  kopieren: neu kopieren (Panzergefecht: `store/tool/horizont_icons.py`).
- Seiten mit eigenem Favicon-Partial: nichts.

## 0.8.8

Panzergefecht zieht auf panzergefecht.de.

### Geändert

- **Panzergefecht mit eigener Domain** (`tokens/flur.yaml`): `site`
  https://panzergefecht.de und `path` `/` statt `/wargame/`. Die Parzelle
  auf regetskcob.de führt direkt dorthin, auf panzergefecht.de selbst zeigt
  sie auf die Startseite statt auf `/wargame/`, das dort nicht mehr besteht.

### Heben

- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.8.8`.
- Apps: nichts.

## 0.8.7

Die Flurkarte einer Produktseite zeigt die Produktseite.

### Neu

- **Eigene Gemarkung als Feldkarte** (`web/partials/nav/karte.html`):
  `map` wählt, welche Gemarkung als Feldkarte erscheint (Standard: die
  erste, regetskcob), `projects false` lässt Feldweg und übrige Seiten weg.
  Auf knx-monitor.de zeigt die Karte damit Start, Add-on, KNX-Box und
  Feedback statt des Portfolios.
- **Produkte mit eigener Domain** (`tokens/flur.yaml`): `site` je
  Gemarkung, KNX Monitor liegt auf https://knx-monitor.de und hat eigene
  Felder. Die Parzelle auf regetskcob.de führt direkt dorthin.
- **Englische Namen** für Felder (`name_en`, `note_en`); auf englischen
  Seiten heißen auch Kennung und Projekte englisch, das Kartenfenster
  „Map“ mit „Close“ statt „Flurkarte“ und „Schließen“.

### Geändert

- Links auf der eigenen Gemarkung mit `relLangURL` statt `relURL`, damit
  englische Seiten auf englische Seiten zeigen. Für einsprachige Seiten
  ändert sich nichts.

### Heben

- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.8.7`. Wer die
  Karte nicht anders aufruft, sieht nichts Neues außer dem KNX-Link.
- KNX-Monitor-Teaser: `"karte" (dict "home" "knx" "here" "knx" "map" "knx"
  "projects" false "field" …)`.
- Apps: nichts.

## 0.8.6

Seitentasten, die mit dem Geräterahmen mitwachsen.

### Geändert

- **Tasten der Geräterahmen relativ zur Breite** (`web/css/components.css`):
  Seitentasten von iPhone und Android ragen 1 % der Rahmenbreite heraus,
  die obere Taste des iPad 0,5 %, die Seitentaste der Uhr 1,9 %; über die
  1-px-Kante des Rahmens hinaus immer mindestens 1 px sichtbar (`--btn`).
  Bei den Standardbreiten (300, 600, 160) bleibt es bei 3 px. Vorher
  waren es immer 3 px; ein kleines Telefon in einer Szene (gut 40 px breit,
  etwa auf der Teaserseite von Kalkar IT) trug damit klobige Klötze.

### Heben

- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.8.6`; nichts
  sonst. Wer eigene Regeln für die Tasten hat, prüft sie gegen `--btn`.
- Apps: nichts.

## 0.8.5

Zwei Fehler in der Horizontlinie.

### Behoben

- **Marke über der Linie** (`.hz-walker` in `components.css`): In Browsern
  ohne CSS-`round()` (Chrome vor 125) schwebte die Marke rund 17 px über der
  Linie. Mit `var()` darin verwirft der Browser nicht nur die
  `round()`-Zeile, sondern das ganze `top`, die `calc()`-Zeile davor
  eingeschlossen. Jetzt steht ein ganzzahliges `calc()` ohne `round()` da,
  mit derselben Lage wie bisher (17 px am Desktop, 3 px auf Touch).
- **„Zurück“ nach dem Sprachwechsel** (`web/js/horizon.js`): Kam man über
  den Sprachumschalter, zeigte die Linie „Zurück“, das nur die Sprache
  zurückgewechselt hätte. Ist die Seite davor ein Ziel des Umschalters, bleibt
  „Zurück“ aus. Auf englischen Seiten (`<html lang="en">`) heißt es „Back“.

### Heben

- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.8.5`, sonst nichts.
- Apps: nichts.

## 0.8.4

Die Lightbox des Blogs kommt ins System.

### Neu

- **Lightbox** (`web/partials/lightbox.html`, `web/js/lightbox.js`, Styles
  `.hz-lightbox` in `components.css`): Ein Link mit `data-lightbox` öffnet
  sein Ziel, das große Bild, in einer dunklen Bildansicht. Darunter steht der
  Untertitel (`data-caption`, sonst der Alt-Text), darüber Zähler und der
  Titel der Gruppe (`data-lightbox-title`). Bilder derselben Gruppe (das
  nächste Element mit `data-lightbox-group`, sonst die Seite) blättert man
  mit Knöpfen, Pfeiltasten oder Wischen. Ein Klick zoomt auf volle Größe,
  Escape, der Schließen-Knopf oder ein Klick daneben schließen. Mit
  `data-exif` (JSON `[{label, value}]`) zeigt ein Knopf die Aufnahmedaten.
  Beschriftungen deutsch oder englisch (`lang`). Ohne JavaScript öffnet der
  Link einfach das Bild.

### Heben

- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.8.4`; die
  Lightbox ist neu und ändert nichts Bestehendes. Der Blog kann seine eigene
  (`partials/lightbox.html`, `assets/js/lightbox.js`) später ersetzen: die
  Klassen heißen hier `hz-lightbox…`, Gruppen markiert `data-lightbox-group`
  statt fester Selektoren.
- Apps: nichts.

## 0.8.3

Eine Glyphe für Kalkar IT Solutions.

### Neu

- **Glyphe `kalkar-it`** (`web/partials/mark.html`): ein Prompt `>` im
  linken Drittel, leicht über der Linie schwebend wie das Buch des Blogs;
  die Linie darunter ist sein Cursor, eine leere Eingabezeile. Aufliegend
  schlösse sich der Pfeil bei 16 px zum Dreieck. Mit `object true` (etwa
  als Wanderer der Horizontlinie) steht der Prompt in Weidengrün, dem
  Graugrün der Kopfweiden (`color.mark.kalkar-it.prompt`, hell #5A7A4E,
  dunkel #9DB98C), die Linie bleibt in der Textfarbe. Bewusst kein drittes
  Waldgrün neben Tanne und Bus. Wie Blog
  und Horizont nur Glyphe, ohne App-Icon und ohne eigene Farben; die
  Teaserseite von Kalkar IT nimmt weiter den Akzent Tinte.
- **Bild für Avatare von Kalkar IT** (`web/partials/app-icon.html`,
  `product "kalkar-it"`): die Bühne von regetskcob, Papier und Tinte, davor
  der Prompt flach in Weidengrün über der Linie, darunter sein Schatten auf
  dem Boden, rechts hinten klein die Buche als Absender. Für die
  GitHub-Organisation; kein Produkt-Icon und keine Plattform-Exporte. Die
  Farben liegen bei der Glyphe unter `color.mark.kalkar-it.icon`, das
  App-Icon liest sie dort, wenn es keinen Produkteintrag gibt.
- **Lockup mit reiner Glyphe** (`web/partials/lockup.html`): Für eine
  Marke ohne Eintrag unter `color.product` (blog, horizont, kalkar-it)
  nimmt das Lockup den übergebenen `label`; fehlt er, bricht der Build mit
  einer Meldung ab statt mit einem Template-Fehler.

### Heben

- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.8.3`; nichts
  sonst.
- Apps: nichts.

## 0.8.2

Jagdaufseher geht vorerst von der Flurkarte.

### Geändert

- **Flurkarte ohne Jagdaufseher** (`tokens/flur.yaml`): Die Landingpage unter
  `/jagdaufseher/` ist offline und das Backend gelöscht, die Arbeit geht in
  KNX Monitor. Damit verschwindet das Projekt auch aus der Projektliste der
  Startseite, die dieselbe Datei liest. Marke, Farben und Bausteine von
  Jagdaufseher bleiben im System; der Eintrag kommt zurück, wenn die Seite
  wieder steht.

### Heben

- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.8.2`; nichts
  sonst. Eine Landingpage, die die Flurkarte zeigt und nicht hebt, verlinkt
  weiter auf `/jagdaufseher/` und damit ins Leere.
- Apps: nichts.

## 0.8.1

Die Horizontlinie im Web: Kapitel auch im Text, ein Zurück und zwei
Wanderer in Farbe.

### Neu

- **Kapitel im Text:** Die Überschrift des Kapitels, das die Linie gerade
  markiert, steht in `text`, die übrigen Kapitelüberschriften treten in
  `text-muted` zurück (`.hz-chapter`, Übergang `slow`). Ist das Ziel einer
  Marke ein Abschnitt, gilt das für seine erste Überschrift. Nur mit dem
  Skript; ohne bleiben alle Überschriften wie gesetzt. Kein Wechsel der
  Stärke: Literata hat nur Light und SemiBold, der Sprung würde Zeilen beim
  Lesen neu umbrechen.
- **Zurück:** Kam man von einer Seite derselben Domain, steht „Zurück“ vor
  dem Anfang der Linie, nach links über den Rahmen hinaus, mit der
  Grundlinie auf der Linie; die Linie bleibt so lang wie bisher. Nur wo
  das Fenster links Platz lässt, also nicht auf Touch. Dazu ein Knopf
  „Zurück“ in der Flurkarte neben „Schließen“. Beide gehen in der
  Browser-Geschichte zurück, sodass die vorige Seite so wiederkommt, wie
  man sie verlassen hat, samt Scrollstand.
- **Wanderer von Horizont und Blog in Farbe** (`object true`, Farben unter
  `color.mark`): die Sonne als Halbscheibe in Orange mit goldenem Kern,
  das offene Buch mit weißen Seiten im braunen Einband. Das Buch schwebt
  jetzt über der Linie, statt von ihr angeschnitten zu werden. Überall
  sonst bleiben die Glyphen.

### Heben

- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.8.1`; nichts
  sonst. Wer Überschriften im Text eine eigene Farbe gibt, prüft, dass
  `.hz-chapter` sie überschreiben darf.
- Apps: nichts.

## 0.8.0

Felder in genau der Höhe der Bedienelemente und zwei Bausteine fürs Feld,
gefunden und am Gerät gemessen in KNX Monitor.

### Neu

- **Feldhöhe:** Jedes Eingabefeld ist so hoch wie ein Knopf, 28 mit Zeiger
  und 44 auf Touch, leer wie gefüllt, mit Symbolen davor und dahinter und
  als `DropdownMenu`. Bisher wurde ein Feld auf Touch 48 hoch (Material
  erzwingt das ohne `isDense`) und mit Zeiger 32. Das Theme rechnet nun mit
  der Zeile 20 (`data`), zieht die Dichte ab und begrenzt die Symbole auf
  die Feldhöhe; der Platzhalter steht auf derselben Zeile.
- **`HorizontTheme.field`:** Eingabe in Fließtext, Mona Sans 16 auf Zeile
  20. Material hat für den Text eines `TextField` keinen Platz im Theme, die
  App setzt ihn deshalb am Feld: `style: HorizontTheme.of(context).field`.
  Felder in Mono (`data`) brauchen nichts.
- **`HorizontFieldIconButton`** und **`HorizontTheme.fieldIconButton`:**
  Symbolknopf im Feld (Suchen, Leeren, Anzeigen), quadratisch in
  Feldhöhe, Symbol 18.
- **`HorizontFieldDropdown<T>`:** wenige feste Werte im Formular als Feld
  statt als Segment, ohne Tippen und Suche, der Pfeil als schlichtes
  Symbol. `dropdownMenuTheme` gibt auch einem eigenen `DropdownMenu`
  Feldhöhe und Feldschrift.
- Ein Widget-Test misst alle Feldarten auf macOS, Windows (28), iOS und
  Android (44).

### Heben

- Apps: `ref: v0.8.0`. Jedes `TextField` in Fließtext bekommt `style:
  HorizontTheme.of(context).field`, sonst ist es 4 höher als die übrigen.
  Eigene Helfer für Feldhöhe, Symbolknöpfe im Feld und Auswahlfelder
  entfallen. Wer im Theme `constraints` für Felder gesetzt hat, nimmt sie
  heraus.
- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.8.0`; nichts
  sonst.

## 0.7.9

Eine ruhige Stufe der Bewegung, vorgeschlagen mit KNX Monitor, und die
Busklemme in Farbe auf der Horizontlinie.

### Neu

- **`calm` (560 ms) mit der Kurve `settle`** (`cubic-bezier(0.16, 1, 0.3,
  1)`, läuft weich aus, ohne Überschwingen) für Bewegung, die niemand
  ausgelöst hat oder die etwas bestätigt: ein Wert, der sich ändert, ein
  Diagramm, das sich aufbaut, ein Haken nach dem Speichern, ein Zähler, der
  hochläuft. Nie für Navigation, Blätter oder Tippen; dort bleiben `fast`
  bis `slow`. Unter reduzierter Bewegung 0 wie alle Dauern.
  - Flutter: `HzMotion.calm`, `HzMotion.settle`; mit `resolveMotion`
    wie die anderen Dauern.
  - Web: `--motion-calm`, `--ease-settle`.
- Die Doku zeigt `calm` als vierte Bahn mit ihrer Kurve.
- **Wanderer von KNX Monitor:** Auf der Horizontlinie steht die Busklemme
  in den Farben des App-Icons (rot für Plus, dunkelgrau für Minus) statt
  der Strich-Glyphe, für mehr Wiedererkennung. `mark.html` bekommt dafür
  `object true`; Produkte ohne farbiges Objekt zeichnen weiter ihre
  Glyphe. Überall sonst (Lockup, Kopf, Fuß, Favicon) bleibt die Glyphe.
- Der Wanderer steht auf ganzen Pixeln (`round()`), damit die Kanten einer
  gefüllten Marke scharf bleiben.

### Heben

- Apps: `ref` auf den neuen Tag, sobald es ihn gibt; nichts sonst. Wer
  bisher eigene, längere Dauern für Werte oder Diagramme hatte, nimmt
  `calm` mit `settle`.
- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.7.9`; nichts
  sonst.

## 0.7.8

Die breiten Bilder von Panzergefecht kommen aus Horizont. Keine Farbe, kein
Maß, kein Widget ändert sich.

### Neu

- `tool/export_icons.py` zeichnet für Panzergefecht aus Boden und Panzer
  der TV-Ebenen (`scene()`, als Vektor über Chrome, daher scharf in jeder
  Größe):
  - `tvos/topshelf-*.png`: Top Shelf 1920×720 und breit 2320×720, je
    @1x und @2x, der Name in Mona Sans Display Expanded mit der Grundlinie
    auf dem Horizont wie im Lockup
  - `tvos/launch-tank-*.png`: der Panzer allein fürs Startbild des
    Apple TV
  - `android/tv-banner-*.png`: das Banner von Android TV, Google TV und
    Fire TV, 320×180 und 640×360, ohne Namen
  - `imessage/icon-1024x768.png`: das 4:3-Icon der Nachrichten-App
  - `launch/ground-1200.png` und `launch/tank-*.png`: Boden mit dem
    Horizont in der Mitte und der Panzer, der darauf steht, wenn beide
    zentriert liegen (Startbildschirm von iOS, Android und Web)
- Headless Chrome startet bis zu dreimal: auf macOS bricht er gelegentlich
  vor dem Zeichnen ab.

### Heben

- Panzergefecht: `store/tool/horizont_icons.py` kopiert die neuen Bilder.
  Andere Apps: nichts zu tun.

## 0.7.7

### Geändert

- In `tokens/flur.yaml` steht Horizont als erstes Projekt. Jagdaufseher, KNX
  Monitor und Panzergefecht tragen `status: Vorschau`, solange sie nicht
  erschienen sind; die Flurkarte setzt das Wort vor ihre Zeile.

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.7`; nichts sonst.

## 0.7.6

### Neu

- Jedes Projekt in `tokens/flur.yaml` trägt einen Satz (`text`), etwa für
  die Abzweige der Landingpage im Blog.

### Geändert

- Die Doku verliert den Abschnitt „Was danach käme“; was noch offen ist,
  steht in den Umstellungs-Issues der Apps und in #5.

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.6`; nichts sonst.

## 0.7.5

Die Doku ist kein Feld der Familie.

### Neu

- `horizont/nav/horizon.html` nimmt `link` (`url`, `hint`) statt `karte`:
  das Zeichen ist dann ein einfacher Link, eine Flurkarte gibt es nicht.
  Der Hinweis beim Zeigen kommt aus `data-hint` („Karte“ oder der `hint`).
- Die Doku nutzt das: die Sonne führt zurück auf regetskcob.de.

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.5`; nichts sonst.

## 0.7.4

Der Sprachschalter ist zu sehen.

### Geändert

- **Sprachschalter am Ende der Linie:** beide Sprachen in einem kleinen
  Rahmen („DE | EN“), die aktuelle mit der Akzentlinie, die andere als Link;
  auf Touch 32 px hoch. Die Linie und ihre Striche enden davor. `lang` nimmt
  dafür `current` (die Sprache der Seite).

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.4`, in `lang` das Feld
  `current` ergänzen. Wer `.hz-horizon-lang` selbst anspricht: das ist jetzt
  der Rahmen, der Link liegt darin (`.hz-horizon-lang a`).

## 0.7.3

Zwei Zeichen mehr, und Horizont ist ein eigenes Projekt auf der Flurkarte.

### Neu

- **Glyphen „blog“ und „horizont“** in `mark.html`: das offene Buch auf der
  Linie für den Blog und die Sonne auf der Linie für Horizont. Nur als
  Glyphe, ohne App-Icon.
- `horizont/nav/horizon.html` nimmt `mark`: das Zeichen, das über die Linie
  wandert, wenn es nicht das des Produkts ist (im Blog das Buch).
- **Horizont als Projekt** in `tokens/flur.yaml`, hinter dem Feldweg neben
  den Apps; bei regetskcob übernimmt „Über“ seinen Platz. Felder und
  Gemarkungen können ein eigenes `mark` tragen.

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.3`; nichts sonst.

## 0.7.2

Der Horizont auf jeder Feldseite, und die Flurkarte stört sie nicht mehr.

### Behoben

- **Die Felder der Flurkarte heißen `.hz-parzelle`** (Liste
  `.hz-parzellen`, `.hz-parzelle-name`, `.hz-parzelle-count`). Seit 0.7.0
  hießen sie `.hz-feld` wie der Rahmen der Feldseite; dessen Seiten bekamen
  dadurch Schraffur, Rahmen und ein Flex-Layout, das auf schmalen
  Bildschirmen über den Rand lief.
- `body.hz` hat keinen Außenabstand mehr; eine Seite auf Horizont läuft von
  Rand zu Rand.

### Neu

- **`"marks" "auto"`** in `horizont/nav/horizon.html`: das Skript liest die
  Kapitel aus der Seite, auf einer Feldseite die nummerierten Abschnitte
  (`.hz-feld-section[id]`) mit ihrer Kennung als Titel. Ein anderer
  Selektor geht über `"auto"`.
- Auf einer Feldseite steht der Horizont direkt in `<body>` vor
  `.hz-feld` und hält deren Rahmen (Breite und Einzug).

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.2`. Wer die Klassen
  der Flurkarte im eigenen CSS anspricht, benennt sie um.

## 0.7.1

Die Flurkarte passt in jede Breite.

### Geändert

- **Flurkarte folgt ihrer eigenen Breite.** Sie richtet sich nach dem Platz,
  den sie hat (Container Query), nicht nach dem Fenster: im Dialog wie in
  einer Textspalte unter 760 px einspaltig, die Projekte darunter. Vorher
  liefen in schmalen Feldern Namen wie „Niederrhein.“ oder „Film-Rezepte“
  über den Feldrand.
- Schmale Felder (unter 150 px) setzen den Namen kleiner; lange Namen
  trennen mit Bindestrich (`lang="de"`, `hyphens: auto`).
- Die Horizontlinie richtet die Titel am Ende nach links aus und teilt sich
  den Platz mit dem Strich davor; eng stehende Striche zeigen keine Worte.

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.1`; nichts sonst.

## 0.7.0

Eine Navigation für alle Hugo-Seiten: der Horizont. Keine Farbe, kein Maß,
kein Widget der Apps ändert sich.

### Neu

- **Horizontlinie** (`horizont/nav/horizon.html`, `.hz-horizon`): keine
  Menüleiste, eine Linie mit dem Zeichen der Seite, das beim Lesen
  mitwandert; Kapitel als Striche an ihrer echten Stelle mit dem Titel
  darunter; mit Zeiger oben, auf Touch unten mit Streichen. Skript
  `web/js/horizon.js` (rund 3 KB, ohne Abhängigkeiten) über
  `horizont/nav/script.html`.
- **Flurkarte** (`horizont/nav/karte.html`, Shortcode `hz-karte`,
  `.hz-karte`): alle Seiten der Familie als Felder, Fläche nach Inhalt, die
  Produkte hinter einem Feldweg. Daten in `tokens/flur.yaml`.
- Die Doku nutzt beides; der Schalter Auto/Hell/Dunkel entfällt, die Seite
  folgt dem System.

### Heben

- Hugo-Seiten: neuer Mount `web/js` → `assets/js/horizont` (docs/web.md,
  „Einbinden“), dann den Kopf durch `horizont/nav/horizon.html` ersetzen und
  `horizont/nav/script.html` ans Ende der Seite setzen.
- `feld/head.html` bleibt bis 0.8.0, wird aber nicht mehr verwendet.
- Apps: nichts zu tun, `ref: v0.7.0` ist gleich 0.6.3.

## 0.6.3

Kleinere Schriften und die Symbole von Panzergefecht. Keine Farbe, kein Maß,
kein Widget ändert sich.

### Geändert

- **Schriften auf Latein gekürzt.** Literata, Mona Sans (auch Display
  Expanded) und Monaspace enthalten nur noch Latein mit seinen Erweiterungen,
  Satzzeichen, hoch- und tiefgestellte Ziffern, Pfeile, Rechenzeichen und die
  Zeichen, die die Produkte als Text setzen (✓, ★, ●, ▲, ⋯, ⏯), ohne
  Hinting; Layout-Features (Tabellenziffern, Texture Healing, Kerning)
  bleiben. Im Flutter-Paket 0,85 statt 2,3 MB (gzip 0,48 statt 1,28 MB), im
  Web 385 statt 930 KB WOFF2. Der Webbuild einer Flutter-App lädt jede Schrift
  vor dem ersten Bild; bei Panzergefecht war das über ein Megabyte Wartezeit.
  Geprüft gegen alle Texte von KNX Monitor, Jagdaufseher und Panzergefecht
  und gegen die Doku; kein Zeichen, das eine Schrift vorher hatte, fehlt dort.
  Gekürzt wird mit `tool/subset_fonts.py`, der Bereich steht im Kopf der
  Datei.

### Neu

- 65 Symbole für Panzergefecht: Modi, Fahrzeuge, Nachschub
  (`local_gas_station`, `inventory_2`, `local_fire_department`, `fort`,
  `military_tech` …), Gelände und Wetter (`landscape`, `terrain`, `park`,
  `waves`, `ac_unit`, `wb_sunny`, `nightlight_round`), Steuerung (`keyboard`,
  `mouse`, `settings_remote`, `qr_code_scanner`) und Menüs (`school`,
  `leaderboard`, `language`, `volume_up`, `volume_off`, `login`,
  `swap_horiz` …). Das Subset ist damit 31 KB als TTF und 15 KB als WOFF2
  (vorher 22 und 10).

### Heben

- Apps: `ref: v0.6.3`. Alle bisherigen Symbole behalten ihren Codepoint;
  Text, der Zeichen außerhalb des Bereichs nutzt (Griechisch, Kyrillisch),
  fällt auf die Systemschrift zurück.
- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.6.3`.

## 0.6.2

Zehn Symbole mehr, damit Jagdaufseher aufhören kann, vier verschiedene Dinge
mit demselben Zeichen zu benennen. Sonst ändert sich nichts: keine Farbe,
kein Maß, kein Widget.

### Neu

- Symbole für Jagdaufseher: `deck`, `cabin`, `tools_ladder`, `event_seat`
  (die vier Arten von Ansitzeinrichtung, an der Form unterscheidbar: Plattform
  auf Pfosten, geschlossene Kanzel, Leiter, Sitz am Boden), `grain`,
  `rice_bowl`, `diamond` (was eine Versorgungsstelle vorhält: gestreutes
  Korn, volle Schale, Salzblock), `yard` (Wildacker) und `gate` (Schranke).
- `undo` in den Aktionen. Es fehlte, und wer es brauchte, nahm `replay` -
  ein Kreispfeil, der „noch einmal abspielen“ heißt, nicht „zurücknehmen“.

Das Subset ist damit 22 KB als TTF und 10 KB als WOFF2 (vorher 20 und 10).

### Heben

- Apps: `ref: v0.6.2`. Nur nötig, wenn eines der neuen Symbole gebraucht
  wird; alles bisherige behält seinen Codepoint.
- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.6.2`.

## 0.6.1

Aufräumen nach der Umstellung von KNX Monitor: Code, Doku und gerenderte
Seite sagen wieder dasselbe, der Umriss hat genug Kontrast, und was KNX
Monitor gebaut hat, liegt jetzt im Paket.

### Geändert

- **`line-strong` ist dunkler** und hat jetzt mindestens 3:1 zu `bg`,
  `surface` und `sunken` (WCAG 1.4.11), in allen Neutralen. Seit 0.6.0 ist
  er der einzige Umriss von Feldern, Knöpfen, Karten und Dialogen und lag bei
  1,5 bis 2,3:1. Entschieden: eine Umrissfarbe bleibt, sie wird kräftiger.

  | Neutrale | vorher | jetzt | zu `bg` |
  | --- | --- | --- | --- |
  | hell | `#C8C9C0` | `#8A8B84` | 1,60 → 3,29 |
  | dunkel | `#42453E` | `#656760` | 1,91 → 3,25 |
  | Gelände dunkel | `#4A5838` | `#667154` | 2,32 → 3,43 |
  | Home Assistant hell | `#BDBDBD` | `#8B8B8B` | 1,80 → 3,26 |
  | Home Assistant dunkel | `#474747` | `#676767` | 2,03 → 3,34 |

- `onError` im `ColorScheme` ist jetzt `on-critical` (hell `#FFFFFF`, dunkel
  `#121311`); vorher hing es an `surface` bzw. `bg` und damit am Gastgeber.
- `HorizontRail` ist standardmäßig `HzSize.sidebar` breit (unverändert 240).
- Symbolgrößen im Paket kommen aus `HzIconSize` (Werte unverändert).

### Neu

- Tokens: `color.status.*.on-critical`; `color.data` (sequenzielle Rampe in
  fünf Stufen für Heatmaps, ein Ton, weder Akzent noch Status);
  `size.sidebar` 240, `size.inspector` 300, `size.grid-card` 240,
  `size.form` 400, `size.search` 320; `icon-size` (badge 14, inline 16, row
  18, bar 22, tab 24). Im CSS als `--on-critical`, `--data-1` bis `--data-5`,
  `--size-*` und `--icon-*`.
- Symbole: gefüllt `star_fill` und `push_pin_fill` (Codepoint 0xF0000 + der
  umrissene). `tool/build_symbols.py` kennt dafür die Zeile `name:fill`.
- Flutter, aus KNX Monitor übernommen:
  - `Kennung(text, count:, oneLine:)`: einzeilig kürzt der Begriff mit „…“,
    der Zähler bleibt; `horizontMetaSeparator` („ · “).
  - `HorizontSectionHeader`: Kennung mit Zähler und leise Aktionen rechts.
  - `HorizontMetric` und `HorizontMetricRow`.
  - `HorizontStatusLine`: Zustand im Fließtext, Zeichen und Wort in der
    Statusfarbe.
  - `HorizontLetterBadge`: Kürzel als quadratisches Kennzeichen.
  - `HorizontEmptyHint`.
  - `horizontDialogAction` mit `destructive`, und
    `HorizontTheme.of(context).criticalButton` für den `FilledButton` einer
    unumkehrbaren Aktion. KNX nutzte dafür bisher zwei verschiedene
    Vordergründe (`bg` und `onAccent`).
  - `HorizontColors.onCritical` und `HorizontColors.dataRamp`.
  - `package:horizont/testing.dart` mit `loadHorizontFonts()` für Goldens.
- Tests: `line-strong` 3:1 auf allen Flächen, `accent-text` auf
  `accent-tint`, `on-critical` auf `critical`, Statusfarben auf `bg` und
  `surface`, die Datenrampe (monoton, letzte Stufe 3:1).
- Showcase-Goldens mit `HorizontField`, FAB, Tablet (Seitenleiste, FAB mit
  Wort) und KNX in Home Assistant hell und dunkel.

### Doku

- Eine FAB-Regel statt zwei: unter 600 quadratisch mit Symbol und Tooltip,
  ab 600 mit Wort, auf iOS wie auf Android.
- Die bewussten Abweichungen von der Plattform nennen jetzt auch die getönte
  Tab-Bar und den FAB auf iOS.
- Tab-Bar überall gleich beschrieben und im Entwurf gleich gezeichnet: die
  Tönung umschließt Icon und Wort, Icon in `accent-text`, Wort halbfett in
  `text`.
- Felder mit `HorizontField` (Beschriftung darüber), „Ansichten unten, Menü
  links“ statt „ab 600 Seitenleiste“, Radius 6 für Kästen neben Feldern, ein
  Umriss in `line-strong`, Gastgeber nur in Flutter, gemessene Größe des
  Symbol-Subsets, der Blog hängt an einem Tag.

### Heben

- Apps: `ref: v0.6.1`. Eigene Zahlen für Formular, Suche, Seitenleiste,
  Inspektor und Kartenraster durch `HzSize.*` ersetzen, `critical`-Knöpfe auf
  `criticalButton` bzw. `horizontDialogAction(…, destructive: true)`,
  Heatmaps auf `colors.dataRamp`, eigene Kopien von SectionLabel, Metric,
  TypeBadge, EmptyHint und dem Schriftladen in Tests durch die Paket-Widgets.
  Goldens neu erzeugen: alle Umrisse sind dunkler.
- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.6.1`.

## 0.6.0

KNX Monitor ist die erste App auf Horizont; was dort am Gerät entschieden
wurde, gilt für alle Apps.

- Hauptaktion als FAB auf jeder Touch-Plattform, auch iOS; mit Zeiger in der
  Werkzeugleiste.
- `HorizontField`: die Beschriftung über dem Feld, Feld und Beschriftung als
  eine Gruppe für den Screenreader.
- Ein Umriss für alles mit Rahmen: `line-strong`. `line` trennt nur Zeilen.
- Tab-Bar unten mit Tönung statt Linie, die Tönung umschließt Icon und Wort,
  die Leiste ist nur so hoch wie ihre Tabs.
- Kästen zwischen Feldern und Knöpfen nehmen deren Radius 6.
- Knöpfe behalten mit Zeiger die Steuerhöhe 28.
- Gastgeber-Neutrale für Home Assistant (`HorizontHost.homeAssistant`).
- Symbole für KNX Monitor, darunter Wetter, Seitenleiste auf und zu.
- Showcase-Goldens.
