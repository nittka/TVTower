# Windows

siehe https://www.gamezworld.de/phpforum/viewtopic.php?id=13691

diese Schritte waren Ausgangspunkt für die Linux-Variante

# Linux

## Vorbereitung

Liste der Schritte, die nötig waren, um TVT unter Lubuntu zu compilieren.
Bislang ist es mir nicht gelungen, die ausführbare Datei zu erstellen.
Testen der Änderungen ging dann durch compile und run auf der Hauptdatei.

1. Download Blitzmax https://blitzmax.org/downloads/ (Linux-Variante)
1. TVT clonen (und gewüschten Branch auschecken/neuen anlegen)
1. MaxIDE starten
1. TVT-Projekt importieren
1. TVTower.bmx öffnen

Ich konnte die Dateien nicht direkt in der IDE editieren, da dadurch das Format zerschossen wird.
Selbst wenn man Auto-Indent und Auto-UpperCasing deaktiviert, werden die Zeilenendzeichen umgeschrieben.
Dadurch ändert sich selbst bei Einzeiler-Änderungen die gesamte Datei.

Als Konsequenz habe ich die Code-Änderungen ausschließlich extern vorgenommen und MaxIDE nur für das Compilieren verwendet.

## Compilierbarkeit herstellen

Für das Durchlaufen des ersten Compile-Vorgangs gab es zwei wesentliche Hürden.

* fehlender C-Compiler sowie fehlende C-Header-Dateien; beides aufgrund nicht installierter Pakete
* ein fehlendes Blitz-Max-Interface, da sich möglicherweise zwischen alter und NG-Version etwas geändert hat

Die fehlenden Pakete habe ich nach und nach aufgrund der Fehlermeldungen mittels `sudo apt-get install` installiert (insb g++ für das Compilieren überhaupt).
Wenn eine Header-Datei als fehlend gemeldet wurde, kann man entweder eine Internet-Suche starten oder verwendet `apt-file search <pfad/datei.h>` um das fehlende Paket zu finden und dann zu installieren.
Das hat ziemlich gut funktioniert.
Eine Liste der Pakete findet sich auch unter https://blitzmax.org/docs/en/setup/linux/; die habe ich aber erst hinterher gefunden.

Ein zweites Problem war ein Import, der unter der NG-MayIDE aufgrund eines fehlenden Interfaces nicht aufgelöst werden konnte.

In `source/Dig/base.sfx.soundmanager.soloud.bmx` musste `Import audio.soloudaudiominiaudio` durch `Import audio.soloudminiaudio` ersetzt werden.

## Erster Compile-Lauf hat funktioniert, aber

Das Setzen der Build-Option Quick-Build ist sinnvoll, damit nur die Änderungen nochmal gebaut werden und die Zeiten zwischen Code-Änderung und Ausprobieren gering gehalten werden.

Mit dem Kommando `Build and Run` (auf der Hauptdatei ausgeführt) startet TVT anschließend.
In meinem Fall war die Frame-Rate dann aber 1FPS, da das Starten des Tons nicht funktioniert, aber permanent wieder angestoßen wurde (bemerkbar durch andauernde Logmeldungen `TSoundManager.Update()` und `PlayMusicOrPlaylist`).
Als Konsequenz habe ich die entsprechenden Blöcke in `source/Dig/base.sfx.soundmanager.base.bmx` auskommentiert um die Musikwiedergabe zu unterbinden.
Danach war die Frame-Rate dann OK und die eigentliche Arbeit konnte beginnen.
Die Änderungen in den sound-Dateien sollte man natürlich nur lokal machen und nicht zum Teil eines Pull-Request machen.