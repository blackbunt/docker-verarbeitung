# docker-verarbeitung

**German! Do not let this lose on your English library.**

Dieser Container arbeitet mit [docker-rsscrawler](https://github.com/rix1337/docker-rsscrawler) zusammen und nutzt die "Recycle Bin" Funktion unter UNRAID. Ziel ist eine Aufbereitung für Plex.

Dateien werden umbenannt, verschoben, getaggt, remuxt und ggf. gelöscht. Es empfiehlt sich also, das Script vorab zu studieren und "Verarbeitung" nur im vollen Bewusstsein der Konsequenzen zu nutzen.

```
docker run -d \
  --name="Verarbeitung" \
  -v /path/to/config/:/log:rw \
  -v /path/to/downloads/:/downloads:rw \
  -v /path/to/plex-library/:/plex:rw \
  rix1337/docker-verarbeitung
  ```
