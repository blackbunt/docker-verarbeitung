# docker-verarbeitung
Read through the github repo and fully understand what it does before you let it lose on your files!
This will rename/tag/delete Media files with Filebot.

```
docker run -d \
  --name="Verarbeitung" \
  -v /path/to/config/:/log:rw \
  -v /path/to/downloads/:/downloads:rw \
  -v /path/to/plex-library/:/plex:rw \
  rix1337/docker-verarbeitung
  ```
