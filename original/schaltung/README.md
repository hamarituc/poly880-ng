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
