# docker-verarbeitung

This container is designed to work in tandem with [docker-rsscrawler](https://github.com/rix1337/docker-rsscrawler).

This will rename/tag/delete Media files with Filebot. Use at your own risk!

```
docker run -d \
  --name="Verarbeitung" \
  -v /path/to/config/:/log:rw \
  -v /path/to/downloads/:/downloads:rw \
  -v /path/to/plex-library/:/plex:rw \
  rix1337/docker-verarbeitung
  ```
