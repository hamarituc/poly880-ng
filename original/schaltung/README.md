Schaltungsbeschreibung
======================

Bus-System
----------

### Bustreiber

Der Systembus der CPU wird über die Gatter I17, I19, I21, I22, I24 - I26, I28
und I29 als unidirektionaler Bus weitergeführt. Diese Treiberschaltung ist
notwendig, da die damals eingesetzten nMOS-Schaltkreise nur begrenzt belastbar
waren und nur so die Lasten aller angeschlossenen Schaltkreise getrieben werden
konnten. Auf diese Weise stehen sowohl negierte als auch nichtnegierte Signale
zur Weiterverarbeitung bereit.

Die negierten Signale werden u.a. zur Adressdekodierung benötigt. Durch den
Verzicht auf DMA-Betrieb, stellt ein unidirektionaler Adressbus hier keine
Einschränkung dar.

Der Datenbus muss jedoch in beide Richtung betrieben werden können. Die
I/O-Schaltkreise sind direkt an den bidirektionalen Datenbus angeschlossen. Die
Speicherschaltkreise sind über einen getrennten Eingabedatenbus `DI` (zur CPU
hin) und ein Ausgabedatenbus `DO` (von der CPU hinweg) angebunden. Der
Ausgbedatenbus leitet sich aus den invertierenden Treiberstufen T5 bis T12 des
Bus-Analysators ab. Der Eingabedatenbus wird bei Lesezugriffen über das Signal
`DIEN` aus den Gattern I20C und I20D auf den bidirektionalen Datenbus
durchgeschaltet.

Der unidirektionale Datenbus ist invertiert ausgeführt. Bei RAM-Zugriffen ist
dies nicht von Belang, da die Daten jeweils beim Schreiben als auch beim Lesen
invertiert werden und somit wieder in Ausgangsform anliegen. Bei der
Programmierung des ROMs ist jedoch zu beachten, dass diese invertiert
beschrieben werden müssen.

Das Signal `!M1` wird durch Gatter I28A mit `!RESETB` verknpüft, um so die
PIO-Schaltkreise bei einem Reset zurückzusetzen.

### Bus-Analysator

Der Bus-Analysator zeigt den Zustand der Systembusse durch Leuchtdioden an. Den
Strom der Leuchtdioden des Adress- und Steuerbusses nehmen die Inverter der
Bustreiber auf. Für den Datenbus stehen mit T5 bis T12 separate Treiberstufen
bereit. Die Anzeigelogik ist positiv, d.h. die LEDs aktiver Signale leuchten.


Adressraum
----------

Der Adressraum wird über die Gatter I18, I20B, I23, I27 und I42 dekodiert.
Die Dekodierung ist nicht vollständig, sodass Speicherstellen unter mehreren
Adressen zugleich abgebildet werden.

### Festwertspeicher ROM

Die ROM-Schaltkreise sind als 1024x8 Bit Speicher organisiert. Es sind vier
ROM-Steckplätze I5 bis I8 vorhanden, die sich auf folgende Adressbereiche
aufteilen.

| Anfangsadresse | Endadresse | ROM |
|:--------------:|:----------:|:---:|
| `0x0000`       | `0x0FFF`   | I5  |
| `0x1000`       | `0x1FFF`   | I6  |
| `0x2000`       | `0x2FFF`   | I7  |
| `0x3000`       | `0x3FFF`   | I8  |

I5 und I6 enthalten das Monitor-Programm. Die Steckplätze I7 und I8 sind
standardmäßig nicht bestückt und frei für Erweiterungen. Das Speicherfenster
für jeden Schaltkreis ist 4kiB groß. Die ROMs verfügen nur über eine Kapazität
von 1kiB und erscheinen in ihrem Fenster somit vierfach wiederholt.

### Schreib-Lese-Speicher RAM

Der RAM ist als Parallelschaltung von 8 1024x1Bit-Schaltkreisen I9 bis I16
organisiert und hat eine Kapazität von 1kiB. Die Zuordnung der Adressleitungen
ist willkürlich, um das Platinenlayout zu vereinfachen. Der RAM ist auf den
Adressraum `0x4000` bis `0x7FFF` abgebildet und wiederholt sich 16 mal
innerhalb dieses Fensters.

### Ein-/Ausgabe

Die I/O-Baugruppen sind über den bidirektionalen Datenbus angebunden. Folgende
I/O-Komponenten stehen zur Verfügung:

 * **PIO 1:** System-PIO für Peripherieanschlüsse, Display, Tastatur,
   Einzelschelschrittsteuerung
 * **PIO 2:** PIO-Schnittstelle für Nutzeranwendungen
 * **CTC:** Zähler und Timer für Einzelschrittsteuerung und Nutzeranwendungen
 * **Digit-Treiber:** Ansteuerung des Displays

Die Adressdekodierung ist ebenfalls unvollständig und laut Handbuch wie folgt
definiert:

| Anfangsadresse | Endadresse | Gerät         |
|:--------------:|:----------:| ------------- |
| `0x80`         | `0x83`     | PIO 1         |
| `0x84`         | `0x87`     | PIO 2         |
| `0x88`         | `0x8B`     | CTC           |
| `0x90`         | `0x93`     | PIO 1         |
| `0x94`         | `0x97`     | PIO 2         |
| `0x98`         | `0x9B`     | CTC           |
| `0xA0`         | `0xBF`     | Digit-Treiber |
| `0xC0`         | `0xC3`     | PIO 1         |
| `0xC4`         | `0xC7`     | PIO 2         |
| `0xC8`         | `0xCB`     | CTC           |
| `0xD0`         | `0xD3`     | PIO 1         |
| `0xD4`         | `0xD7`     | PIO 2         |
| `0xD8`         | `0xDB`     | CTC           |
| `0xE0`         | `0xFF`     | Digit-Treiber |

Diese Angaben sind missverständlich, da laut Dekodierung folgende Bereiche
sowohl durch PIO/CTC als auch den Digit-Treiber benutzt werden:

 * `0xA0` - `0xAB`
 * `0xB0` - `0xBB`
 * `0xE0` - `0xEB`
 * `0xF0` - `0xFB`

Insbesondere die für den Digit-Treiber dokumentierte Adresse `0xA0` sollte
daher nicht genutzt werden. Es wird empfohlen nur die Adressen zu benutzen, die
auch das Monitorprogramm verwendet:

| Adresse         | Gerät         |
| --------------- | ------------- |
| `0x80` - `0x83` | PIO 1         |
| `0x84` - `0x87` | PIO 2         |
| `0x88`          | CTC           |
| `0xFC`          | Digit-Treiber |


Einzelschrittlogik
------------------

Die Einzelschrittsteuerung unterliegt einer komplexen Ablaufsteuerung. Relevant
hierfür sind die Steuerbussignale `NMI` und `WAIT`. Ein aktives `NMI`-Signal
bringt das Monitor-Programm zur Ausführung. Ein aktives `WAIT`-Signal fügt
Wartezyklen ein und führt dazu zu einer stabilen Anzeige auf dem
Bus-Analysator. Gesteuert wird die Einzelschrittsteuerung durch die Tasten
`MON`, `MCYCL` und `CYCL`, sowie den Signalen `SEND` und `SCON`.

Die rückgekoppelten Gatter `I34C`, `I34A` und `I33B` bilden eine
Flip-Flop-Schaltung. Die Grundstellung wird durch drücken der Taste `MON`
hergestellt. Hierdurch geht der Ausgang von `I34A` auf High und der
Open-Kollektor-Ausgang von `I33B` auf Low. Der Ausgang von `I34C` liegt
ebenfalls auf Low. Durch die Rückkopplung bleibt der Zustand auch nach
loslassen der Taste `MON` erhalten. Zudem wird das Flip-Flop `I35B` gesetzt,
wodurch das Signal `NMI` aktiv wird und das Monitorprogramm aufruft.

Nach einem Reset befinden sich die Gatter `I34C`, `I34A` und `I33B` im selben
Zustand, wie nach dem Drücken der `MON`-Taste. Lediglich das Flip-Flop `I35B`
wird gelöscht, wodurch `NMI` nicht aktiv ist, d.h. die Programmabarbeitung beim
Reset-Vektor beginnt.

Beim Eintritt in den Monitor wird das Signal `SCON` auf High gesetzt, wodurch
das Flip-Flop `I35A` gelöscht wird (sofern `SEND` nicht High ist). Dadurch geht
der Ausgang von `I33B` auf High und deaktiviert den Set-Eingang an `I35B`. Die
beiden anderen Gatter der Flip-Flop-Konstruktion behalten ihren Zustand. Beim
Verlassen des Monitors geht `SCON` auf Low, setzt damit `I35B` zurück, wodurch
das `NMI`-Signal deaktiviert wird und somit ein erneuter Eintritt in den
Monitor verhindert wird.

Beim Verlassen des Monitors wird im Einzelschrittbetrieb ein Timer gestellt,
welcher einen kurzen High-Puls an `SEND` anlegt. Dieser Timer ist so gewählt,
dass der Puls während des ersten Befehls nach Verlassen der
Monitor-Interrupt-Routine aktiv wird. Hierdurch wird `NMI` wieder aktiv, sodass
effektiv nach einem Befehl wieder in den Monitor eingetreten wird. Der Timer
wird zudem während der Reset-Routine aktiviert, sodass nach einem Reset
automatisch der Monitor aktiviert wird.

Durch Betätigung der `MCYCL`-Taste wird der Einzeltyklenbetrieb aktiviert.
`I34C` geht dabei auf High, `I34A` auf Low und folglich `I33B` auf High. Die
`MCYCL`-Led beginnt zu leuchten. Innerhalb der Monitor-Routine ist `I35A`
jedoch gelöscht, sodass über `I34B` und `I32B` sichergestellt ist, dass `I33D`
nicht nach Masse durchschaltet. Innerhalb des Monitors werden demnach keine
Wartezyklen eingefügt.

Außerhalb des Monitor-Betriebs sind beide Eingänge von `I33D` high, sodass das
`WAIT`-Signal dauerhaft aktiviert ist und die CPU Wartezyklen ausführt. Auf dem
Busmonitor ist dann ein stabiler Zustand ablesbar. Betätigt man nun die
`CYCL`-Taste, geht der Ausgang von `I32C` auf Low, wodurch die Kathode von `D1`
zunächst auf negatives Potential gezogen wird. Der Eingang 13 von `I33D` geht
ebenfalls auf Low und deaktiviert das `WAIT`-Signal. Die CPU beginnt den
nächsten Speicherzyklus. Über `R19` und `D1` wird `C9` wieder geladen und der
Eingang 13 von `I33C` erreicht vor dem nächsten Speicherzyklus wieder
High-Pegel, sodass die CPU wieder anhält. Lässt man `CYCL` wieder los, stellt
sich über `C9` der Grundzustand für den nächsten Zyklus ein.


Peripherie
----------

### Anzeige

Die acht 7-Segement-Anzeigen werden im Zeitmultiplexbetrieb angesteuert. Die
Anoden Digits werden über die Digit-Treiber T19 bis T26 getrieben. Die
Ansteuerung dieser Treiber erfolgt über die Schieberegister I40 und I41, welche
als Latch fungieren. Die Latches werden direkt über den I/O-Adressraum durch
das Signal `CLDIG` vom Adressdekoder angesteuert.

Ein Low-Pegel aktiviert das Digit. Aus Programmierersicht ist die Logik
positiv, da die Latch-Eingabe vom negierten Datenbus abgegriffen wird.
Prinzipiell lassen sich mehr als ein Digit zeitgleich ansteuern, was aber in
der Praxis wenig Sinn ergibt.

Um eine ausreichende Helligkeit zu erzielen, ist der Stromfluss durch die
Anzeigen größer dimensioniert als für den Dauerbetrieb zulässig. Ein
dauerhaftes Aktivieren der Digits ist daher unzulässig und führt zu einer
Zerstörung der Anzeigen. Um eine ungewollte Zerstörung durch Programmierfehler
zu vermeiden, bilden T17 und T18 eine Schutzschaltung. Beim Aktivieren der
Latches, wird C35 über T17 entladen. Das RC-Glied bestehend aus R147 und C35
lädt sich nach dem Schreibzyklus langsam auf. Erfolgt innerhalb einer Zeit von
ca. 3ms kein weiterer Schreibimpuls, hat sich C35 so weit aufgeladen, dass T18
durchsteuert und die MC-Eingänge der Schieberegister auf Low-Pegel zieht.
Spätestens nach 8 Taktzyklen nehmen damit alle Ausgänge der Schieberegister
High-Pegel an und die Digits sind automatisch deaktiviert. Damit das
Anzeigebild bestehen bleibt, muss also innerhalb von 3ms jeweils ein anderes
Digit aktiviert werden.

Die Ansteuerung der Segmente erfolgt über den Kanal A der System-PIO I2. Die
Die Logik ist aus Programmierersicht ebenfalls positiv.

### Tastatur

Die Tastatur wird ebenfalls im Zeitmultiplexverfahren abgetastet. Die Tasten
sind in einer Matrix von 8 Zeilen und 3 Spalten angeordnet. Die Abtastung der
Zeilen erfolgt über den Digit-Treiber der 7-Segment-Anzeigee. Zur Abfrage der
Tastatur muss daher der Refresh-Zyklus von 3ms eingehalten werden.

Die Spaltensignale werden über den Kanal B der System-PIO I2 eingelesen. Die
Entkopplung über die Dioden D2 bis D9 stellt sicher, dass bis zu zwei Tasten
gleichzeitig gedrückt werden können. Werden mehr als zwei Tasten zeitgleich
betätigt, kann es zur Erkennung von Phantom-Eingaben kommen.

Die Entprellung der Tastatureingaben ist in Software zu realisieren.
