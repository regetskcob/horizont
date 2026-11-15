# Niederrheinisches Software-Design

Ein Manifest für alle, die Software für den Niederrhein entwerfen oder bauen, Menschen wie
Claude. Stand 15.11.2026: **Entwurf, vom Nutzer noch nicht entschieden.** Es steht über Horizont:
Horizont ist die Umsetzung (Tokens, Bausteine), dieses Manifest sagt, wofür und für wen.

Lies es ganz, bevor du eine Oberfläche entwirfst. Die Regeln sind begründet, damit du in Fällen
entscheiden kannst, die hier nicht stehen. Wenn eine Regel im Einzelfall dem Menschen vor dem
Gerät schadet, gilt der Mensch, und du sagst, wo du abgewichen bist.

## Für wen wir bauen

Stell dir nicht „den Nutzer“ vor, sondern diese fünf. Jede Oberfläche muss für mindestens einen
von ihnen gemacht sein und darf keinen der anderen aussperren.

- **Die Landwirtin auf dem Schlepper.** Ein Daumen frei, Handschuhe oder nasse Hände, Sonne auf
  dem Glas, das Gerät wackelt. Sie schaut zwei Sekunden hin und muss dann wieder nach vorn sehen.
  Am Feldrand hat sie einen Balken Empfang oder keinen.
- **Der Bürger mit 74.** Er liest genau, aber langsam, hat die Schrift groß gestellt und tippt
  mit dem Zeigefinger. Er will nichts kaputt machen. Ein Symbol ohne Wort ist für ihn ein Rätsel,
  ein englisches Wort eine Hürde, und wenn etwas verschwindet, glaubt er, er sei schuld.
- **Der Handwerker auf der Baustelle.** Staub, Lärm, grobe Finger, das Telefon liegt im
  Verteilerschrank oder im Keller ohne Netz. Er braucht einen Wert oder einen Haken, sofort,
  und hat keine Geduld für Einrichtung.
- **Die Auszubildende mit 22.** Sie ist mit guten Apps groß geworden und merkt in Sekunden,
  ob etwas sorgfältig gemacht ist. Sie erwartet, dass es sofort reagiert, sich von selbst
  erklärt, im Dunkeln gut aussieht und sich so anfühlt wie das Beste auf ihrem Telefon. Riesige
  Knöpfe, Erklärtexte an jeder Ecke und altbackene Optik liest sie als „nicht für mich“, und sie
  ist diejenige, die den Eltern und dem Chef die App einrichtet oder davon abrät.
- **Die Fachfrau am Schreibtisch.** Großer Bildschirm, Tastatur, viele Daten. Sie will Dichte und
  Tempo, aber dieselbe Ruhe.

Die ersten drei bestimmen, was mindestens gehen muss: Größe, Kontrast, Wörter, Empfang. Die
Auszubildende bestimmt, wie gut es sein muss: Tempo, Sorgfalt, Eleganz. Die Fachfrau bestimmt,
was mit Zeiger zusätzlich erlaubt ist. Das ist kein Kompromiss zwischen Alt und Jung. Eine
Oberfläche, die klar, schnell und ruhig ist, ist für beide die beste, und genau die suchen wir.
Wo es doch eine Wahl gibt, gewinnt bei der Zugänglichkeit, wer es schwerer hat, und bei der
Ausführung, wer den höheren Anspruch hat.

## Das Leitbild

**Weites Land, tiefer Horizont, wenige klare Linien.** Am Niederrhein sieht man weit, weil wenig
im Weg steht. So soll sich die Software anfühlen: Man sieht sofort, wo man ist, was da ist und
wo es weitergeht.

Dazu gehört die Art der Leute: direkt, unaufgeregt, verlässlich. Man sagt, was ist, macht kein
Aufheben und hält, was man zusagt. Eine Oberfläche, die prahlt, drängelt oder etwas verschweigt,
passt hier nicht hin.

## Die Grundsätze

### 1. Auf einen Blick

Jeder Bildschirm beantwortet in zwei Sekunden drei Fragen: Wo bin ich, was ist los, was kann ich
tun. Das Wichtigste steht groß und oben, genau eine Aktion ist die Hauptaktion, alles andere
tritt zurück.

Warum: Die Landwirtin hat zwei Sekunden, der Handwerker keine Geduld, der ältere Bürger verliert
in einer vollen Ansicht den Faden. Weißraum ist hier kein Stil, sondern Platz zum Finden.

Prüfe: Deck den Bildschirm ab und zeig ihn zwei Sekunden. Wer dann nicht sagen kann, was der
nächste Schritt ist, sieht zu viel.

### 2. Das Wort trägt

Jede Aktion hat ein Wort. Symbole begleiten Wörter, sie ersetzen sie nicht. Die Wörter sind
Deutsch, kurz und alltäglich: „Speichern“, „Zurück“, „Später senden“, nicht „Sync“, „Submit“,
„Okay“ für alles. Fachwörter nur dort, wo die Zielgruppe sie selbst benutzt (ein Elektriker sagt
„Gruppenadresse“, ein Entwickler „Branch“).

Warum: Ein Symbol muss man gelernt haben, ein Wort kann man lesen. Wer unsicher ist, tippt nichts
an, dessen Folge er nicht kennt.

Ausnahmen sind die wenigen Zeichen, die jeder kennt (Zurück-Pfeil, Lupe, Schließen-Kreuz), und
Werkzeugleisten für Fachleute mit Zeiger, dort mit Tooltip. Die Hauptaktion trägt immer ein Wort.

### 3. Nichts geht verloren, nichts erschrickt

Jede Eingabe ist sofort lokal gesichert. Jeder Schritt lässt sich zurücknehmen, oder die App
fragt vorher, in einem Satz, der sagt, was passiert. Fehlermeldungen sagen, was los ist und was
man jetzt tun kann, ohne Schuld, ohne Code, ohne Ausrufezeichen.

Warum: Wer Angst hat, etwas kaputt zu machen, benutzt die Software nicht. Vertrauen entsteht,
wenn Fehler folgenlos bleiben.

Zustand ist nie nur Farbe: immer Wort, Zeichen und Farbe. Was sich von selbst ändert, sagt das
an derselben Stelle, an der man es zuletzt gesehen hat.

### 4. Erst das Gerät, dann das Netz

Die App funktioniert ohne Empfang. Netz ist ein Zusatz, kein Zustand, auf den man wartet.
Das ist eine Gestaltungsaufgabe, keine reine Technikfrage:

- **Zeig den Stand, nicht das Warten.** Statt eines Kreisels steht der letzte bekannte Wert mit
  seinem Alter: „Stand 08:12“. Ein alter Wert mit Uhrzeit ist mehr wert als ein leerer Bildschirm.
- **Nimm an, sende später.** Was jemand eingibt, gilt sofort. Wenn es nach draußen muss und kein
  Netz da ist, steht dabei „wird gesendet, sobald Empfang da ist“, mit Zeichen. Niemand muss
  warten, wiederholen oder daran denken.
- **Nie blockieren.** Kein Dialog, kein Vollbild-Laden, kein gesperrter Knopf wegen des Netzes.
  Was ohne Netz wirklich nicht geht, sagt das in einem Satz und bietet an, was stattdessen geht.
- **Leicht sein.** Schriften, Symbole und Kartenausschnitte liegen im Gerät. Bilder laden nach
  dem Text und nie als Voraussetzung. Eine Seite ist auch mit einem Balken in wenigen Sekunden
  lesbar.
- **Ehrlich sein.** Drei Lagen, jede mit Wort und Zeichen: aktuell, Stand von …, wartet auf
  Empfang. Kein grüner Haken, bevor es wirklich angekommen ist.

Warum: Am Feldrand, im Keller und im Stall ist das Netz schlecht, und genau dort wird die
Software gebraucht. Wer zweimal vor einem Kreisel stand, nimmt wieder den Zettel.

### 5. Groß genug für draußen

Was man tippt, ist groß. Was man liest, hat Kontrast. Die Oberfläche hält Sonne, Handschuh,
Wackeln und die größte Systemschrift aus.

- Tippziele mindestens 44, die Hauptaktion und alles, was man draußen bedient, 56. Zwischen
  zwei Zielen liegt Abstand, damit ein grober Finger nicht das falsche trifft.
- Lesetext mindestens 16, nichts Wesentliches unter 13. Versalien mit Sperrung nur für kurze
  Marken von ein bis drei Wörtern, nie für Sätze.
- Wesentliches (Werte, Aktionen, Status) hat mindestens 7:1 zum Grund, alles Lesbare mindestens
  4,5:1. Bedienelemente erkennt man an ihrem Umriss oder ihrer Fläche mit mindestens 3:1.
- Die Schrift skaliert mit dem System, nichts wird geklemmt oder abgeschnitten. Bei doppelter
  Größe bricht das Layout um, es schneidet nichts ab.
- Hell ist die Ansicht für draußen und wird zuerst entworfen. Dunkel ist gleichwertig, aber für
  drinnen.

Warum: Der Kontrast, der am Schreibtisch elegant wirkt, ist in der Mittagssonne unsichtbar. Der
Knopf, der im Simulator reicht, ist mit Arbeitshandschuh zu klein.

### 6. Eine Linie, ein Akzent

Flächen ohne Schatten und Verläufe, Ordnung durch Raum, Ton und wenige Linien. Eine Farbe pro
Produkt, und sie markiert nur die Hauptaktion und die Auswahl. Alles andere ist Papier und Tinte.

Warum: Wenn nur eines farbig ist, weiß man, wo man drücken soll. Jede weitere Farbe, jeder
Schatten und jede Karte ist etwas, das der Blick erst als unwichtig erkennen muss.

### 7. Wie das Gerät, das man kennt

Navigation, Gesten, Dialoge und Tastatur folgen der Plattform. Gleiche Dinge sehen überall
gleich aus und stehen am selben Ort, in jeder App der Familie.

Warum: Der Bürger hat sein Telefon einmal gelernt. Alles, was sich so verhält wie der Rest
seines Geräts, muss er nicht neu lernen.

### 8. Schlicht, nicht ärmlich

Minimal heißt: nichts Überflüssiges. Es heißt nicht: wenig Hilfe. Ein leerer Bildschirm sagt in
einem Satz, was hierher gehört, und bietet den ersten Schritt an. Schrift, Abstand und Linie sind
sorgfältig gesetzt, denn Sorgfalt ist die einzige Zier.

### 9. Einfach, nicht altbacken

Die Software ist von heute. Sie reagiert sofort, bewegt sich ruhig und genau, sieht hell wie
dunkel gut aus und hält den Vergleich mit den besten Apps auf demselben Gerät aus. Zugänglich
wird sie durch Klarheit, nicht durch eine Seniorenansicht: keine Riesenknöpfe, keine
Erklärkästen, kein eigener „einfacher Modus“. Dieselbe Oberfläche dient der Auszubildenden und
ihrem Großvater.

- **Selbsterklärend statt erklärt.** Wenn ein Bildschirm einen Hilfetext braucht, ist er zu
  kompliziert. Erst vereinfachen, dann beschriften.
- **Schnelle Wege, die niemanden stören.** Wischen, Suche, Tastenkürzel, langes Drücken und
  Teilen sind da für alle, die sie kennen. Jeder dieser Wege hat daneben einen sichtbaren mit
  Wort; keine Funktion gibt es nur als Geste.
- **Tempo ist Gestaltung.** Eine Antwort unter einer Zehntelsekunde fühlt sich direkt an. Was
  länger dauert, zeigt sofort den neuen Zustand und holt den Rest nach (siehe Grundsatz 4).
- **Größe folgt dem System.** Wer große Schrift braucht, stellt sie am Gerät ein, und die App
  folgt. Die Standardansicht ist nicht vorsorglich vergrößert.
- **Keine Mode.** Modern heißt sorgfältig und schnell, nicht Glas, Verlauf und Effekt. Was in
  zwei Jahren alt aussieht, lassen wir heute weg.

Warum: Auch am Niederrhein leben junge Leute, und sie sind mit minimaler, intuitiver Software
aufgewachsen. Sie entscheiden oft, was im Betrieb und in der Familie benutzt wird. Und was für
sie gut gemacht ist, ist für die anderen kein Hindernis: Klarheit und Tempo helfen dem
Vierundsiebzigjährigen genauso.

## Ton

- Sag, was ist: „Kein Empfang. Deine Eingabe ist gespeichert und wird später gesendet.“
- Kurz, ganze Sätze, Verben vorn. Kein Marketing, kein „Ups“, keine Ausrufezeichen.
- Sprich Menschen an, wie man am Gartenzaun spricht: freundlich, direkt, ohne Getue. Bürger-Apps
  siezen, Werkzeuge für Fachleute und eigene Projekte duzen. Innerhalb einer App nie mischen.
- Zahlen mit Einheit, Zeiten als Uhrzeit oder „vor 5 Minuten“, nie als Zeitstempel.

## Prüffragen vor jedem Entwurf

1. Wer von den fünfen benutzt das, und wo steht er gerade?
2. Versteht man in zwei Sekunden, was der nächste Schritt ist?
3. Hat jede Aktion ein Wort, das meine Großmutter kennt?
4. Was sieht man hier ohne Empfang? Ist es nützlich?
5. Was passiert, wenn jemand daneben tippt? Kommt er zurück?
6. Liest man es in der Sonne, mit größter Schrift, mit einer Hand?
7. Was kann weg, ohne dass jemand es vermisst?
8. Würde eine Zweiundzwanzigjährige das gern benutzen, oder nur ertragen?

Wenn du eine Frage mit „weiß ich nicht“ beantwortest, ist der Entwurf nicht fertig.

## Was das am heutigen Horizont in Frage stellt

Das Leitbild und die sechs Regeln von Horizont halten. Diese Punkte halten dem Manifest nicht
oder nur teilweise stand; sie sind Vorschläge und brauchen eine Entscheidung:

| Heute in Horizont | Problem | Vorschlag |
| --- | --- | --- |
| Empfang und Offline kommen nicht vor | Der wichtigste Ort der Nutzung fehlt | Grundsatz 4 aufnehmen; Bausteine für „Stand von …“ und „wartet auf Empfang“, Status `pending` mit eigenem Zeichen |
| FAB am Telefon nur mit Symbol | Die Hauptaktion ohne Wort ist für Ungeübte ein Rätsel | FAB am Telefon mit Wort, sobald es passt; nur bei Platznot das Symbol |
| Kennung 11/16 in Mono-Versalien, in vielen Zeilen | Zu klein, Versalien lesen sich langsam, vor allem für Ältere | Mindestens 12, nur noch als Marke je Abschnitt; Meta in Zeilen normal gesetzt (deckt sich mit dem 2.0-Entwurf) |
| Weiche Stufe: Umrisse in `line`, unter 3:1 | Felder und Knöpfe sind in der Sonne nicht als solche erkennbar | Umriss wieder mindestens 3:1 oder Fläche `sunken` mit 3:1; die bewusste Ausnahme streichen |
| Auswahl nur als Tönung | `accent-tint` ist draußen kaum zu sehen | Tönung plus Zeichen oder halbfettes Wort überall, nicht nur in der Seitenleiste |
| `text-muted` für Meta, 4,5:1 | Reicht für Beiwerk, nicht für Werte | Wesentliches nie in `text-muted`; 7:1 für Werte und Aktionen als Test |
| Literata 300 als Lesetext | Leichter Schnitt wird auf einfachen Android-Bildschirmen dünn | Lesetext in 400 prüfen, 300 nur ab 24 |
| Tippziel 44 für alles | Zu knapp mit Handschuh und in Bewegung | 56 nur für die Hauptaktion und für Bildschirme, die draußen bedient werden (`size.touch-field`); sonst bleibt 44, damit nichts klobig wird |
| „Der Bildschirm darf leer sein“ | Stimmt, aber leer darf nicht ratlos heißen | Ergänzen: Jeder leere Zustand sagt, was hierher gehört |
| Dichte und Symbolleisten vom Mac | Richtig für Fachleute, falsch als Vorgabe für Bürger-Apps | Zwei Lagen benennen: Alltag (Bürger, Feld) und Werkzeug (Fach, Zeiger); ein Produkt sagt, welche es ist |

Unberührt bleiben: ein Akzent, Linien statt Schatten, drei Stimmen, Zustand mit Wort und Zeichen,
Plattform vor Mode, gebündelte Schriften, Skalierung mit der Systemschrift, Unumkehrbares nur
mit Bestätigung.
