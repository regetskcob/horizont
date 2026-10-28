# Horizont im Web

Leitfaden für Hugo-Seiten: Blog, Landingpages, Dokumentation, Web-Apps. Die
Regeln stehen in [CLAUDE.md](../CLAUDE.md).

## Einbinden

Alle Web-Oberflächen sind Hugo-Seiten (der Blog, die Landingpages von KNX
Monitor und Panzergefecht, Jagdaufseher liegt im Blog unter
`/jagdaufseher/`). Horizont kommt als Hugo-Modul:

```toml
[module]
  [[module.imports]]
    path = 'github.com/regetskcob/horizont'
    [[module.imports.mounts]]
      source = 'tokens'
      target = 'data'
    [[module.imports.mounts]]
      source = 'icons'
      target = 'data/horizont_icons'
      includeFiles = ['*.json']
    [[module.imports.mounts]]
      source = 'web/css'
      target = 'assets/css/horizont'
    [[module.imports.mounts]]
      source = 'web/partials'
      target = 'layouts/_partials/horizont'
    [[module.imports.mounts]]
      source = 'web/shortcodes'
      target = 'layouts/_shortcodes'
    # Ab 0.7.0: das Skript der Horizontlinie.
    [[module.imports.mounts]]
      source = 'web/js'
      target = 'assets/js/horizont'
    # Mona Sans, Material Symbols, Literata and Monaspace; the blog's theme
    # brings its own Literata and Monaspace in the same folders.
    [[module.imports.mounts]]
      source = 'web/fonts'
      target = 'static/fonts'
```

```bash
hugo mod get github.com/regetskcob/horizont@v0.7.0
```

Das ändert `go.mod` und `go.sum`. Wie die Apps hängt eine Seite an einem
Tag, nie an `main`; was sich zwischen zwei Tags ändert, steht im
[CHANGELOG](../CHANGELOG.md). Im CI braucht der Build Go, wie im Workflow
des Blogs.

CSS in der Reihenfolge Tokens, Komponenten, eigene Regeln. `tokens.css` ist
ein Template:

```go-html-template
{{ $hz := site.Data.horizont }}
{{ $css := slice
  (resources.Get "css/horizont/tokens.css" | resources.ExecuteAsTemplate "css/horizont-tokens.css" $hz)
  (resources.Get "css/horizont/components.css")
  (resources.Get "css/site.css")
  | resources.Concat "css/site.css" | minify | fingerprint }}
<link rel="stylesheet" href="{{ $css.RelPermalink }}">
```

`components.css` lädt die Schriften aus `../fonts/`, relativ zum CSS. Das
CSS liegt deshalb eine Ebene unter dem Ordner `fonts/`, etwa unter `css/`
oder `assets/`.

Auf `<html>` gehören:

- `data-product="jagdaufseher|knx|panzergefecht|regetskcob"`: setzt den
  Akzent (und bei Panzergefecht im Dunkeln das Gelände).
- `data-theme="light|dark"` nur, wenn der Modus erzwungen wird. Ohne das
  Attribut folgt die Seite dem System. Beides geht auch auf Teilbäumen, etwa
  für ein dunkles Mockup auf einer hellen Seite.
- `data-density="desktop"` für Web-Apps mit Zeiger (Steuerelemente 28,
  Zeilen 28).
- `class="hz"` auf `<body>`: Grundfarben und Schrift.

Gastgeber-Neutrale (Home Assistant) gibt es nur im Flutter-Paket. Im
Gastgeber läuft die App, keine Hugo-Seite, deshalb kennt das CSS kein
`data-host`.

Ein bestehendes Theme (wie typo im Blog) wird nicht umgeschrieben. Eine
Brücke setzt seine Variablen aus den Tokens, siehe
`assets/css/horizont-blog.css` im Blog.

## Variablen

Neutrale `--bg --surface --sunken --line --line-strong --text --text-muted
--text-faint`, Status `--positive --warning --critical --info` (je mit
`-tint`) und `--on-critical`, Produkt `--accent --on-accent --accent-tint
--accent-text`, Datenrampe `--data-1` bis `--data-5` (Heatmaps, wenig nach
viel), Schriften `--font-serif --font-sans --font-mono`, Abstände
`--s-<n>`, Radien `--r-<n>`, Linien `--line-hairline --line-selection
--line-focus`, Bewegung `--motion-fast|base|slow|calm --ease-standard|exit|settle`, Größen
`--size-<name>` (auch `form`, `search`, `sidebar`, `inspector`,
`grid-card`, `fact-term`), Symbolgrößen `--icon-badge|inline|row|bar|tab`,
Grund unter Fotos `--scrim-bg --scrim-text --scrim-text-muted
--scrim-bar-alpha` (Lightbox), Fernseher `--tv-safe-horizontal
--tv-safe-vertical --tv-type-scale --tv-focus --tv-focus-scale`, Hardware
`--device-<name>`. Typo-Klassen `.t-display` bis `.t-kennung`.

`--line-strong` ist der eine Umriss: Feld, Knopf, Segment, Schalter, Karte,
Dialog. Er hat mindestens 3:1 zu `--bg`, `--surface` und `--sunken`.
`--line` trennt nur Zeilen und Abschnitte.

## Komponenten

| Klasse | Zweck |
| --- | --- |
| `.hz-button` + `--primary --secondary --quiet --critical --dense` | Knöpfe, `--primary` nur einmal pro Ansicht |
| `.hz-field`, `.hz-input`, `.hz-help`, `.hz-error` | Formularfelder, Beschriftung über dem Feld; `aria-invalid="true"` für Fehler |
| `.hz-list`, `.hz-row` (`--inset`), `.hz-row-lead/-title/-meta/-trail` | Listen mit Haarlinie ab dem Text; `aria-selected="true"` trägt die Linie |
| `.hz-section-head` | Kennzeile über einem Abschnitt |
| `.hz-badge` + `--positive --warning --critical --info --accent` | Status, immer mit Zeichen und Wort |
| `.hz-segmented` (Buttons mit `aria-pressed`) | Umschalter, Auswahl als Linie unten |
| `.hz-tabs` (Links mit `aria-current`) | Tabs, Auswahl als Linie |
| `.hz-switch` | Schalter (`input type=checkbox`) |
| `.hz-card` | Fläche mit Umriss in `line-strong`, Radius 10, selten; neben Feldern und Knöpfen Radius 6 |
| `.hz-table`, `.hz-num`, `.hz-mono` | Datentabellen, Werte in Mono rechtsbündig |
| `.hz-kennung`, `.hz-muted`, `.hz-mono`, `.hz-rule` | Kennung, gedämpfter Text, Mono, Linie |
| `.hz-lockup` (`--mark`) | Marke und Name auf einer Grundlinie |
| `.hz-symbol` | Material-Symbols-Ikone per Codepoint (`&#xea99;` für `forest`, gefüllt `&#xff09a;` für `star_fill`, Liste in `icons/material-symbols.json`) |
| `figure.hz-device.hz-device--<gerät>` + `.hz-device-screen` | Geräterahmen für Screenshots |

Die Geräterahmen gibt es als `iphone`, `android`, `ipad`, `laptop`, `tv` und
`watch`, dazu `--cropped` (Telefon endet am Abschnittsrand, `--h` gibt die
Höhe). `--w` ist die Außenbreite, alles andere folgt daraus:

```html
<figure class="hz-device hz-device--iphone" style="--w: 300px">
  <div class="hz-device-screen"><img src="…" alt="…"></div>
</figure>
```

Fotos und Medien: `horizont/lightbox.html` zeigt Bilder groß auf dem Scrim.
Für einen Balken auf einem Foto, etwa den Titel auf einem Cover, gibt es
`.hz-scrim-bar`: Schrift in `--scrim-text`, der Grund läuft zum Bild hin
aus. `--fade-solid` ist die Höhe des festen Teils (Text samt Abstand),
`--hz-scrim-fade` die Länge des Verlaufs.

## Partials (für Layouts)

Jede Datei erklärt ihre Parameter im Kopf. Alle lesen Farben und Werte aus
den Tokens. Eigene Werte in einem Layout sind ein Fehler.

| Partial | Zweck |
| --- | --- |
| `horizont/lockup.html` | Marke und Name auf einer Grundlinie (`product`, `label`, `href`; für eine reine Glyphe wie `kalkar-it` ist `label` Pflicht) |
| `horizont/mark.html` | die Glyphe allein (`product`, `size`; auch `blog`, das offene Buch, `horizont`, die Sonne auf der Linie, und `kalkar-it`, der Prompt über der Linie) |
| `horizont/app-icon.html` | das illustrierte App-Icon (`product`, `size`, `variant`) |
| `horizont/kennung.html` | Kennung (Text oder `dict "text" "tag"`) |
| `horizont/badge.html` | Status mit Zeichen und Wort (`status`, `label`) |
| `horizont/symbol.html` | Material Symbol per Name (`name`, optional `label`) |
| `horizont/facts.html` | Begriff und Wert auf einer Grundlinie (`items`, `term`) |
| `horizont/device.html` | Screenshot im Geräterahmen (`device`, `width`, `image` oder `src`, `alt`, `cropped`) |
| `horizont/nav/horizon.html` | die Navigation: Horizontlinie mit Zeichen, Kapitelstrichen und Flurkarte (siehe „Navigation“) |
| `horizont/nav/karte.html` | die Flurkarte allein (`home`, `here`, `field`, `counts`, `map`, `projects`) |
| `horizont/nav/script.html` | das Skript dazu, einmal am Ende der Seite |
| `horizont/feld/hero.html`, `section.html`, `foot.html` | die Feldseite (siehe unten); den Kopf bildet der Horizont, `feld/head.html` gibt es seit 0.9.0 nicht mehr |
| `horizont/lightbox.html` | Bildansicht: Links mit `data-lightbox` öffnen ihr Bild groß, mit Untertitel (`data-caption`), Blättern innerhalb von `data-lightbox-group` und Zoom per Klick (`lang`) |
| `horizont/icons.html` | Platzhalter-Ikonen der Doku als SVG-Sprite |

```go-html-template
{{ partial "horizont/lockup.html" (dict "product" "knx" "href" "/knx/") }}
{{ partial "horizont/badge.html" (dict "status" "warning" "label" "Prüfen") }}
{{ partial "horizont/device.html" (dict "device" "iphone" "width" 300 "image" ($.Resources.Get "overview.png") "alt" "Übersicht") }}

{{/* SVG favicon from the app icon */}}
{{ $fav := partial "horizont/app-icon.html" (dict "product" "regetskcob" "size" 64) | resources.FromString "favicon.svg" }}
<link rel="icon" type="image/svg+xml" href="{{ $fav.RelPermalink }}">
```

## Shortcodes (für Inhalte)

Für Beiträge im Blog und Texte der Landingpages:

```markdown
{{< hz-device src="uebersicht.png" device="iphone" width="300" alt="Übersicht des Reviers" caption="Die Übersicht" >}}
{{< hz-kennung "Einrichtungen · 14" >}}
{{< hz-badge warning >}}Prüfen{{< /hz-badge >}}
{{< hz-symbol map "Karte" >}}
{{< hz-facts >}}
Zustand | gut, prüfen, defekt
Fotos | je Einrichtung
{{< /hz-facts >}}
{{< hz-karte home="regetskcob" >}}
```

`hz-device` nimmt ein Bild aus dem Page Bundle, verkleinert es auf WebP in
doppelter Breite und setzt es in den Rahmen. Ein Screenshot ohne `alt` bricht
den Build ab.

## Navigation

Jede Hugo-Seite hat dieselbe Navigation: den Horizont. Keine Menüleiste,
kein Hamburger, keine Dropdowns.

- **Linie und Zeichen.** Eine Linie über den Seitenrahmen, das Zeichen der
  Seite steht darauf und wandert beim Lesen von links nach rechts; links
  davon ist die Linie 2 px im Akzent nachgezogen. Bei reduzierter Bewegung
  bleibt das Zeichen links, nur die Linie wächst. Das Zeichen ist der
  einzige Knopf: es öffnet die Flurkarte und nennt beim Zeigen den Ort
  (`place`, kurz: „regetskcob / Blog“, „KNX Monitor“).
- **Kapitelstriche.** Jedes Kapitel ein Strich an seiner echten Stelle, der
  Titel klein unter der Linie, der aktuelle dunkel und ganz; wo Kapitel eng
  liegen, nur die Nummer. Unter drei Kapiteln steht die Linie allein. Im
  Blog-Index sind die Striche Jahre, so hoch wie ihre Beiträge (`n`).
- **Mit Zeiger oben, auf Touch unten** (`(hover: none) and (pointer:
  coarse)`), wie die Ansichten in den Apps. Auf Touch tragen die Striche
  Nummern; mit dem Daumen über die Linie streichen springt durch die
  Kapitel.
- **Flurkarte.** Alle Seiten der Familie als Felder von oben, die Fläche
  nach dem Inhalt, die Furchen je Feld in eigenem Winkel; die Produkte
  hinter einem Feldweg. Das Feld, auf dem man ist, trägt Akzent und
  Zeichen. Daten in `tokens/flur.yaml`; eigene Zahlen gibt die Seite live
  mit (`counts`). Ein Produkt mit eigener Domain (KNX Monitor) zeigt auf
  seinen Seiten seine eigene Gemarkung als Feldkarte, ohne die übrigen
  Seiten: `"map" "knx" "home" "knx" "projects" false`. Auf englischen
  Seiten gelten `name_en` und `note_en`.
- **Ohne JavaScript** sind die Striche Ankerlinks in einer Reihe und das
  Zeichen ein Link auf `/karte/` (Shortcode `hz-karte`).

```go-html-template
{{ partial "horizont/nav/horizon.html" (dict
    "product" "regetskcob"
    "place" "regetskcob / Blog"
    "marks" (slice (dict "id" "jahr-2026" "label" "2026" "short" "26" "n" 13 "title" "2026 · 13 Beiträge"))
    "karte" (dict "home" "regetskcob" "here" "regetskcob" "field" "blog" "counts" (dict "blog" 151))) }}
…
{{ partial "horizont/nav/script.html" . }}
```

Die Linie folgt dem Seitenrahmen über `--horizon-width` (etwa
`.hz-horizon { --horizon-width: var(--size-page); }`).

## Landingpage („Feldseite“)

Aufbau, wie in der Doku unter „Entwürfe“, zusammengesetzt aus dem
Horizont und den Partials unter `horizont/feld/` in einem
`<div class="hz-feld">`. Ein Menü gibt es nicht (entschieden für 0.9.0):
Kapitel, der Weg zurück und die Sprache liegen auf der Linie.

1. Kopf: der Horizont (siehe „Navigation“) mit dem Zeichen des Produkts und
   den nummerierten Abschnitten als Striche, direkt in `<body>` vor
   `<div class="hz-feld">` (dessen Container hielte die Linie auf Touch am
   Seitenende fest). `"marks" "auto"` liest die Abschnitte samt Kennung aus
   der Seite, so muss der Rahmen sie nicht kennen.
2. Hero, links ausgerichtet: Kennung (`01 — IN ENTWICKLUNG · IPHONE ·
   ANDROID`), Überschrift in `.t-display` (Literata 300), ein Absatz in
   `text-muted`, eine Hauptaktion (`--primary`) und eine zweite
   (`--secondary`). Rechts das Produkt im Geräterahmen oder, bei Daten, die
   Daten selbst im Rahmen.
3. Die Horizontlinie: 2 px im Akzent über die volle Breite.
4. Abschnitte im Raster „Kennung links (`02 — EINRICHTUNGEN`) | Überschrift
   und Text | Fakten als Liste mit Begriff in Mono“. Begriffsspalte mit fester
   Breite, Begriff und Wert auf einer Grundlinie.
5. Fuß: Lockup „ein Projekt von regetskcob“ mit der Glyphe, rechts Impressum
   und Datenschutz.

Nicht verwenden: zentrierter Hero, Badge- oder Eyebrow-Pille, Kachelraster
mit Icon in getönter Fläche, abwechselnde Abschnittsfarben, Schatten unter
Screenshots, nackte Screenshots ohne Rahmen.

## Prüfen

- Hell und dunkel (Systemeinstellung und, wo vorhanden, Umschalter).
- 375 px Breite: kein horizontaler Überlauf. Schnell prüfbar mit
  `document.documentElement.scrollWidth === document.documentElement.clientWidth`.
- Grundlinien von Lockups und Faktenlisten nachmessen: die Horizontlinie
  der Marke (Oberkante + 2/3 der Höhe) liegt auf der Grundlinie des Textes.
- Keine Konsolenfehler, keine Assets über `http://` (Basis-URL immer
  `https://`).
- Keine externen Schriften oder Skripte (Datenschutz). Schriften liegen
  lokal.
