# Horizont

Das Designsystem von regetskcob und seinen Projekten Jagdaufseher, KNX Monitor
und Panzergefecht. Leitbild: minimalistisch wie die niederrheinische Feldflur.

Dokumentation und Entwürfe: https://www.regetskcob.de/horizont/

Stand: v0.8.9, das Favicon jedes Produkts ist sein App-Icon. KNX Monitor ist als erste App umgestellt (App auf v0.6.1,
Landingpage auf v0.7.9), Jagdaufseher als zweite (App inklusive Web auf v0.7.7,
Landingpage offline seit 22.10.2026), Panzergefecht als dritte (Spiel und Landingpage auf
v0.7.8, regetskcob/wargame#31);
der Blog hängt an v0.7.7. Was sich je Version geändert hat, steht in
[CHANGELOG.md](CHANGELOG.md).

Wer Oberflächen umsetzt, ob Mensch oder Claude-Sitzung, beginnt mit
[CLAUDE.md](CLAUDE.md) (Leitbild, Regeln, Tokens, offene Entscheidungen,
Arbeitsweise) und liest dann [docs/flutter.md](docs/flutter.md) für die Apps
bzw. [docs/web.md](docs/web.md) für Hugo-Seiten.

## Aufbau

| Ordner | Inhalt |
| --- | --- |
| `tokens/horizont.json` | Die einzige Quelle aller Werte: Farben hell und dunkel, Produkt-Akzente, Status, Datenrampe, Gastgeber, Schrift, Abstand, Radien, Linien, Größen, Symbolgrößen, Bewegung, Icon-Paletten |
| `web/css/` | Die Web-Schicht: `tokens.css` (Hugo-Template, erzeugt die CSS-Variablen aus den Tokens) und `components.css` (Knöpfe, Felder, Listen, Status, Tabellen) |
| `web/partials/` | Hugo-Partials: Marke, App-Icon, Lockup, Geräterahmen, Kennung, Badge, Symbol, Fakten, Feldseite (`feld/`) |
| `web/shortcodes/` | Hugo-Shortcodes für Inhalte: `hz-device`, `hz-kennung`, `hz-badge`, `hz-symbol`, `hz-facts` |
| `web/fonts/` | Literata, Mona Sans, Monaspace Argon (SIL OFL, `OFL.txt`) und Material Symbols Sharp als Subset (Apache 2.0), als WOFF2 |
| `flutter/` | Flutter-Paket `horizont`: Theme, Widgets, Schriften (`flutter/fonts/`), Showcase-App und Goldens (`flutter/example/`) |
| `icons/` | Material-Symbols-Liste und Codepoints, eigene Symbole (`icons/symbols/`), die SVG-Quellen der App-Icons (`icons/svg/`) und die fertigen Sätze je Plattform (`icons/export/`) |
| `tool/` | `generate_tokens.dart` (Tokens für Flutter), `build_symbols.py` (Material Symbols zuschneiden), `draw_symbols.py` (eigene Symbole zeichnen), `subset_fonts.py` (Schriften auf Latein kürzen), `export_icons.py` (App-Icons für alle Plattformen) |
| `site/` | Nur die Dokumentationsseite |
| `docs/` | Umsetzungsleitfäden für Flutter und Web |
| `CLAUDE.md` | Kurzfassung aller Regeln für Claude-Sitzungen |
| `CHANGELOG.md` | Was sich je Version geändert hat und was Apps und Seiten beim Heben tun |

Hugo bindet die Ordner über `module.mounts` in `hugo.toml` ein, das Repository
muss deshalb nicht wie eine Hugo-Seite aussehen.

## Lokal ansehen

```sh
hugo server --baseURL http://localhost:1313/horizont/
```

Dann http://localhost:1313/horizont/ öffnen.

## Deploy

Jeder Push auf `main` baut die Seite und veröffentlicht sie über GitHub Pages
(`.github/workflows/pages.yml`). Weil die Nutzerseite `regetskcob.github.io`
die Domain `www.regetskcob.de` trägt, erscheint dieses Repository als
Projektseite unter `/horizont/`.

## App-Icons

`icons/export/<produkt>/` enthält die fertigen Sätze. Die Apps kopieren sie
und erzeugen sie nicht selbst.

| Ordner | Inhalt |
| --- | --- |
| `ios/AppIcon.appiconset/` | 1024 ohne Alpha, Xcode leitet die übrigen Größen ab |
| `watchos/` | 1024 ohne Alpha, das System maskiert den Kreis |
| `macos/AppIcon.iconset/` | nach Apples Vorlage (824 auf 1024, Schatten), alle Größen; `iconutil -c icns` macht daraus die `.icns` |
| `android/` | adaptive Ebenen (Vorder-, Hintergrund, monochrom) für alle Dichten, `ic_launcher.xml`, das klassische Icon, `playstore-512.png` |
| `tvos/` | Vorder- und Hintergrundebene in 400×240, 800×480 und 1280×768 |
| `web/` | `favicon.svg` und `favicon-32.png` (App-Icon, die Glyphe nur auf Wunsch), `apple-touch-icon.png`, `icon-192/512.png`, `icon-512-maskable.png` |

Neu erzeugen, nachdem sich ein Icon oder seine Farben geändert haben:

```sh
python3 -m venv .venv && .venv/bin/pip install pillow
.venv/bin/python tool/export_icons.py
```

Das Skript baut die Doku-Seite, die die SVG-Quellen aus den Partials
veröffentlicht, und rendert sie mit Chrome.


## Lizenz

Horizont steht unter der [MIT-Lizenz](LICENSE): frei nutzbar, auch
kommerziell, solange der Copyright-Hinweis (© 2026 Daniel Bocksteger)
mitkommt. Ausgenommen sind:

- **Schriften:** Literata, Mona Sans und Monaspace unter der SIL Open Font
  License 1.1 (`OFL.txt`), Material Symbols unter Apache 2.0
  (`MaterialSymbols-LICENSE.txt`), jeweils neben den Schriften in
  `flutter/fonts/` und `web/fonts/`.
- **Marken und Namen der Produkte** (Zeichen, App-Icons, `icons/svg/`,
  `icons/export/`): Sie kennzeichnen regetskcob und seine Projekte und sind
  nicht für andere Produkte freigegeben.
- **Das Flutter-Logo** in der Showcase-App, eine Marke von Google.

Das Flutter-Paket trägt dieselbe Lizenz in `flutter/LICENSE`; Flutter nimmt
sie von selbst in die Lizenzseite der Apps auf, die Schriften kommen über
`registerHorizontLicenses()` dazu.
