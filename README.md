# KameraFux 0.2.0.0

KameraFux verschiebt die aktive Außenkamera eines Fahrzeugs zusätzlich über
den Ziffernblock. Die normale Maussteuerung, das Mausrad, WASD und die
AutoDrive-Mausbedienung bleiben unverändert.

## Steuerung

| Taste | Funktion |
|---|---|
| Num 8 / Num 2 | Vor / zurück |
| Num 4 / Num 6 | Links / rechts |
| Num 9 / Num 3 | Hoch / runter |
| Num 0 | Zusatzversatz zurücksetzen |

Die Bewegung funktioniert nur in einer Fahrzeug-Außenkamera. Innenkameras
werden absichtlich nicht verändert. NumLock muss gegebenenfalls aktiviert sein.

Version 0.2 registriert die Eingaben direkt an der jeweils aktiven
Fahrzeugkamera. Das entspricht dem von aktuellen FS25-Kameramods verwendeten
Lebenszyklus und vermeidet verlorene Fahrzeug-Callbacks.

## Installation

`FS25_KameraFux.zip` unverändert nach
`Dokumente/My Games/FarmingSimulator2025/mods` kopieren und im Spielstand
aktivieren.

## Teststatus

Die ZIP-, XML- und Lua-Struktur wurde statisch geprüft. Ein echter Lauf in LS25
ist für diese erste Version noch erforderlich. Falls der Mod nicht reagiert oder
Fehler erzeugt, bitte `log.txt` aus dem FarmingSimulator2025-Ordner bereitstellen.

## Lizenz

MIT, siehe `LICENSE`.
