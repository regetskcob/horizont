# Horizont 2.0 – Plan

Stand 16.11.2026: Der Nutzer hat den Plan freigegeben, er wird umgesetzt, wie er hier steht
(`CLAUDE.md`, „Horizont 2.0“). Erledigt ist der erste Schritt: Seit 0.16.0 ist `HorizontProduct`
eine Klasse, und Landbote, Gemarkung, Panzergefecht, Busclear und Kalkar Kompakt legen sich in
ihrem Repository selbst an (`tool/horizont/`, `lib/theme/product.dart`); Streuwerk hält dort seine
Dateien. Offen sind Kalkar IT, die Web-Schicht mit der Flurkarte, die Gestaltung aus Abschnitt 2
und `v2.0.0`. Jagdaufseher ist zurückgestellt und bleibt vorerst in Horizont. Das Manifest bleibt (Feldflur, sechs Regeln, drei
Stimmen, ein Akzent). 2.0 ändert, wer was festlegt, und hebt die Gestaltung der Apps.

Die Entwürfe am Bildschirm (Landbote, Gemarkung) liegen im Design-System-Artifact „Horizont“
unter „Horizont 2.0“.

## 1. Leitplanken statt Produktentscheidungen

Heute stehen Akzente, Icon-Farben, Marken und App-Icons aller Produkte in diesem Repository
(`color.product`, `web/partials/mark.html`, `app-icon.html`, `flutter/lib/src/widgets/mark.dart`,
`icons/svg`, `icons/export`, `tool/export_icons.py`). Jedes neue Produkt und jede Farbkorrektur
braucht einen Horizont-Tag, den dann alle heben.

### Was bleibt

Neutrale, Status, Datenrampe, Scrim, Gastgeber, Schriften, Typo-Skala, Raster, Radien (auch
`soft`), Linien, Bewegung, Größen, Fenstergrößen, Fernseher, Geräterahmen, UI-Symbole, alle
Bausteine (Flutter und Web), die Regeln und die Zeichenregeln für Marke und App-Icon. Dazu die
Dachmarke regetskcob (Tinte, Buche) als Vorgabe und die Glyphen ohne Produkt (Blog, Horizont).

### Was das Produkt liefert (Vertrag)

| Das Produkt liefert | Leitplanke, geprüft von Horizont |
| --- | --- |
| Akzent in vier Slots, hell und dunkel | `accent-text` ≥ 4,5:1 auf `bg`, `surface`, `sunken`; `on-accent` ≥ 4,5:1 auf `accent`; `text` ≥ 4,5:1 auf `accent-tint` |
| optional eigene Neutrale (heute nur Panzergefecht dunkel, KNX `soft`) | dieselben Kontrasttests wie die Neutralen von Horizont |
| Glyphe | Linie auf dem unteren Drittel, ein Gegenstand, Strich 7 von 100, eckige Enden |
| App-Icon und Plattform-Sätze | Bühne aus Himmel, Boden, Horizont bei zwei Dritteln; drei Töne, dunkle Kontur |
| Name, Rolle, Absenderzeile | „ein Projekt von regetskcob“ |

Form im Produkt-Repo: `horizont.product.json` (derselbe Aufbau wie heute ein Eintrag unter
`color.product`), daneben `mark/` und die Icon-Sätze. `tool/export_product.py <id> <ziel>` packt
genau das aus dem heutigen Stand; `--check` prüft nur die Kontraste.

### Was sich im Paket ändert (bricht, deshalb 2.0)

- **Flutter:** `HorizontProduct` wird vom erzeugten Enum zu einer `const`-Klasse, die das Produkt
  selbst anlegt (`const landbote = HorizontProduct(displayName: …, light: HzAccent(…), …)`).
  Gemarkung und Landbote nennen das Enum an je zwei, drei Stellen; der Umbau dort ist klein.
  `HorizontMark` nimmt die Pfade der Glyphe vom Produkt statt aus einem `switch`. Dazu
  `package:horizont/testing.dart` mit `expectProductHoldsContrast(product)`, damit die AA-Prüfung
  mit ins Produkt zieht.
- **Web:** `tokens.css` erzeugt kein `[data-product]` mehr. Die Seite setzt ihre vier
  Akzent-Variablen selbst (ein Partial liest `horizont.product.json` aus `data/`). `mark.html`
  und `app-icon.html` zeichnen nur noch die Dachmarke; die Produktseiten bringen ihr SVG mit.
- **Flurkarte:** `tokens/flur.yaml` bleibt hier (sie ist die Karte der Familie), verweist aber
  auf Zeichen und Akzent der Produkte, statt sie zu kennen. Offen, siehe unten.
- **Werkzeug:** `tool/export_icons.py` zieht als Skript in die werkbank oder bleibt hier als
  Werkzeug, das ein Produkt-Repo als Eingabe nimmt.

### Umzug je Produkt

| Produkt | Ziel-Repo | zieht um |
| --- | --- | --- |
| Gemarkung | `regetskcob/gemarkung` | Heide, Wegweiser, Icons |
| Landbote | `regetskcob/landbote` | Altrhein, Briefkasten, Icons |
| Streuwerk | `regetskcob/streuwerk` | Pflaume, Saatsack, Icons |
| KNX Monitor | `regetskcob/KNX-Monitor-Source` | Bus, Busklemme, `soft`, Icons |
| Jagdaufseher | `regetskcob/jagdaufseher` | Tanne, Kanzel, Icons |
| Panzergefecht | `regetskcob/wargame` | Signalgelb, Panzer, Gelände (`neutralDark`), tvOS-Ebenen |
| Kalkar Kompakt | `Kalkar-IT-Solutions/kalkar-kompakt` | Backstein, Rathaus, Icons |
| Kalkar IT | `Kalkar-IT-Solutions/landing-page` | Prompt in Weidengrün (`color.mark.kalkar-it`) |

Reihenfolge: erst Gemarkung und Landbote (beide jung, wenig Bezug), dann Streuwerk, zuletzt
KNX Monitor als Referenz und die übrigen.

## 2. Die nächste Ebene der Gestaltung

Grundlage ist das Manifest ([manifest.md](manifest.md)), vom Nutzer am 15.11.2026 angenommen.
Jede Änderung unten muss seinen Prüffragen standhalten. Aus dem Manifest kommen dazu:

- **Lage statt Kreisel.** Neuer Baustein `HorizontLage` mit drei Zuständen, je Wort und Zeichen:
  aktuell, Stand von …, wartet auf Empfang. Dazu der Status `pending` in `HorizontStatus`.
- **Wort an der Hauptaktion.** `HorizontPrimaryAction` zeigt am Telefon das Wort, wenn es passt.
- **Zwei Lagen je Produkt:** `alltag` (Bürger, Feld; Tippziel 56 für die Hauptaktion) und
  `werkzeug` (Fachleute, Zeiger). Gemarkung ist Werkzeug, Landbote Alltag.
- **Mindestgrößen:** Kennung 12, Meta 13, Lesetext 16. Kontrasttest 7:1 für Werte und Aktionen.
- **Umriss wieder 3:1** auch in der weichen Stufe; Auswahl als Tönung plus halbfettes Wort.

Sechs Änderungen, alle aus dem Leitbild abgeleitet:

1. **Flächen wie Äcker.** Spalten unterscheiden sich im Ton (`sunken` Seitenleiste, `bg` Liste,
   `surface` Inhalt und Inspektor). Haarlinien trennen Abschnitte, nicht jede Zeile und Spalte.
2. **Der Horizont in der App.** Unter dem Seitenkopf liegt die Horizontlinie (2 px). Ihr
   Akzentteil trägt eine Lage: Gelesenes, Lesefortschritt, Zeitbudget, Abgleich. Neuer Baustein
   `HorizontHorizon(value:)`, im Web gibt es ihn schon.
3. **Kennung einmal je Ebene.** Mono-Versalien für Seitenkopf und Abschnitt. Meta in Zeilen wird
   `caption`; Mono bleibt dem Gemessenen.
4. **Lesen in Literata.** Was man in der App liest (Artikeltitel, Onboarding, leere Zustände),
   steht in Literata. Neuer Typo-Stil `title-read` (Literata 600, 17/24).
5. **Zahlen tragen.** Kennzahlen 32/36 in Mono, ohne Kästen. Neuer Typo-Stil `figure`.
6. **Raum statt Linie.** Zeilen mit 12 Innenabstand und Radius 6, Auswahl als Tönung,
   Ungelesenes ein Punkt im Akzent (dazu volles Gewicht, also nicht nur Farbe).

Punkt 1, 3 und 6 berühren Entscheidungen von v0.6 und der weichen Stufe („Ein Umriss“, Kennung
in Mona Sans in Apps, Seitenleiste auf `surface`). Sie gelten erst nach Freigabe.

## 3. Schritte

1. Freigabe der Richtung anhand der beiden Entwürfe.
2. Paket 2.0 auf einem Branch: `HorizontProduct` als Klasse, `HorizontHorizon`, die zwei
   Typo-Stile, Seitenleiste und Zeilen nach Punkt 1 und 6, Goldens neu.
3. Gemarkung und Landbote: `tool/export_product.py`, Produkt im Repo anlegen, auf den Branch
   heben, Bildschirme nach den Entwürfen, je ein PR.
4. Web-Schicht und Doku umbauen, Produkte aus `tokens/horizont.json` nehmen, Tag `v2.0.0`.
5. Übrige Produkte heben.

## Offen (entscheidet der Nutzer)

- 2.0 direkt, obwohl v1.0 „alle am selben Tag“ noch nicht erreicht ist?
- Bleibt die Flurkarte mit allen Produktzeichen in Horizont, oder liefert jede Seite ihr Feld?
- Seitenleiste auf `sunken` statt `surface` (Punkt 1), auch in der weichen Stufe?
- Zieht `export_icons.py` in die werkbank?
