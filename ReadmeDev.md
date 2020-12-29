# Windows

siehe https://www.gamezworld.de/phpforum/viewtopic.php?id=13691

diese Schritte waren Ausgangspunkt für die Linux-Variante

# Linux

## Vorbereitung

Liste der Schritte, die nötig waren, um TVT unter Lubuntu zu compilieren.
Bislang ist es mir nicht gelungen, die ausführbare Datei zu erstellen.
Testen der Änderungen ging dann durch compile und run auf der Hauptdatei.

1. Download Blitzmax https://blitzmax.org/downloads/ (Linux-Variante)
1. Installation der nötigen Abhängigkeiten (https://blitzmax.org/docs/en/setup/linux/)
1. TVT clonen (und gewüschten Branch auschecken/neuen anlegen) (Oomph-Setup übernimmt das Clonen)
1. MaxIDE starten
1. TVT-Projekt importieren
1. TVTower.bmx öffnen

Ich konnte die Dateien nicht direkt in der IDE editieren, da dadurch das Format zerschossen wird.
Selbst wenn man Auto-Indent und Auto-UpperCasing deaktiviert, werden die Zeilenendzeichen umgeschrieben.
Dadurch ändert sich selbst bei Einzeiler-Änderungen die gesamte Datei.

Als Konsequenz habe ich die Code-Änderungen ausschließlich extern vorgenommen und MaxIDE nur für das Compilieren verwendet.
Z.B. Verwendung des minimalistischen aber für die Navigation und Suche von Typen hilfreichen Xtext-Editors (https://github.com/TVTower/TVTBlitzmaxEditor) via Oomph-Setup (https://raw.githubusercontent.com/TVTower/TVTBlitzmaxEditor/master/TVTBlitzmax.setup).

## Compilierbarkeit herstellen

Dieses Problem wurde durch die Reparatur eines Imports via Ticket #255 im Commit  46f844763811460aa8d9ee2daf42aea92780a502 behoben.
Mit dem Installieren der Blitzmax-Abhängigkeiten sollte alles funktionieren (ansonsten Vorgängerversion dieser Datei anschauen).

Das Setzen der Build-Option Quick-Build ist sinnvoll, damit nur die Änderungen nochmal gebaut werden und die Zeiten zwischen Code-Änderung und Ausprobieren gering gehalten werden.