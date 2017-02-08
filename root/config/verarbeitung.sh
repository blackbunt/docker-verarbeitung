#!/bin/bash

LOGFILE="/log/Verarbeitung.log"
echo "$(date "+%d.%m.%Y %T") : Starte Verarbeitungsmonitor" >> $LOGFILE 2>&1
# Log Timestamp
echo "$(date "+%d.%m.%Y %T") : Starte Verarbeitungsmonitor"

# True is always true, thus loop indefinately
while true
do 
youngfile=false
# Find any mkv in RSScrawler folder
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for f in $(find /downloads/RSScrawler/ -type f  -name '*.mkv');
do
  # Check if the mkv has been modified (extracted) in the last 5 seconds
  if ! [ `stat --format=%Z $f` -le $(( `date +%s` - 5 )) ]; then
    youngfile=true
   echo "[$f wird gerade entpackt. Breche ab!]"
  fi
done
IFS=$SAVEIFS
# if no young file was found, execute the main script
if [ "$youngfile" = false ] ; then
  # Fixing Permissions
  chmod -R 666 /downloads/RSScrawler/

  # Remove Clutter
  find /downloads/RSScrawler/ -name "*.srt" -type f -delete
  find /downloads/RSScrawler/ -name "*.sub" -type f -delete
  find /downloads/RSScrawler/ -name "*.idx" -type f -delete
  find /downloads/RSScrawler/ -name "*.m3u" -type f -delete
  find /downloads/RSScrawler/ -name "*.url" -type f -delete
  find /plex/.Temp/ -name "*.srt" -type f -delete
  find /plex/.Temp/ -name "*.sub" -type f -delete
  find /plex/.Temp/ -name "*.idx" -type f -delete
  find /plex/.Temp/ -name "*.m3u" -type f -delete
  find /plex/.Temp/ -name "*.url" -type f -delete

  # Adding Tags
  find /downloads/RSScrawler/ -type f -name '*.mkv' | while read filename
  do
    echo "[Tagge $filename]"
    mkvpropedit "$filename" --edit info --set title="RiX" --edit track:v1 --set name="RiX" --edit track:a1 --set name="RiX" &>/dev/null
    mkvpropedit "$filename" --edit info --set title="RiX" --edit track:v1 --set name="RiX" --edit track:a1 --set name="RiX" --edit track:a2 --set name="RiX" &>/dev/null
    mkvpropedit "$filename" --edit info --set title="RiX" --edit track:v1 --set name="RiX" --edit track:a1 --set name="RiX" --edit track:a2 --set name="RiX" --edit track:a3 --set name="RiX" &>/dev/null
  done
  find /downloads/RSScrawler/Drone/ -name '*.mkv' -exec mv {} /plex/.Temp/Drone/ \; &>/dev/null
  
  # Move YouTube Videos
  mv /downloads/RSScrawler/YouTube/* /plex/YouTube/ &>/dev/null
  
  # Move Movies/Shows for Remuxing
  filebot -script /config/rename.groovy "/downloads/RSScrawler/Remux" --output "/downloads/Remux" --log-file "/log/Verarbeitung.log" --action move --conflict override -non-strict --def music=n --def skipExtract=y --def clean=y --log info --lang "de" --def "seriesFormat=/downloads/Remux/Serien/{n}/{'S'+s.pad(2)}/{s00e00} - {t} - {source}-{vf}" "movieFormat=/downloads/Remux/{fn =~ /3d/ ? '3D-Filme' : 'Filme'}/{n} ({y}){fn =~ /3d/ ? ' [3D]' : ''}/{n} ({y}){fn =~ /3d/ ? ' [3D].H-SBS' : ''}" --def "animeFormat=/downloads/Remux/Serien/{n}/{'S'+s.pad(2)}/{s00e00} - {t} - {source}-{vf}" &>/dev/null
 
  # Move 3D-Movies
  filebot -script /config/rename.groovy "/downloads/RSScrawler/3Dcrawler" --output "/plex/.Temp" --log-file "/log/Verarbeitung.log" --action move --conflict override -non-strict --def music=n --def skipExtract=y --def clean=y --log info --lang "de" --def "seriesFormat=/plex/.Temp/Serien/{n}/{'S'+s.pad(2)}/{s00e00} - {t} - {source}-{vf}" "movieFormat=/plex/.Temp/3D-Filme/{n} ({y}) [3D]/{n} ({y}) [3D].H-SBS" --def "animeFormat=/plex/.Temp/Serien/{n}/{'S'+s.pad(2)}/{s00e00} - {t} - {source}-{vf}" &>/dev/null
    
  # Move Movies/Shows for Sorting
  filebot -script /config/rename.groovy "/downloads/RSScrawler" --output "/plex/.Temp" --log-file "/log/Verarbeitung.log" --action move --conflict override -non-strict --def music=n --def skipExtract=y --def clean=y --log info --lang "de" --def "seriesFormat=/plex/.Temp/Serien/{n}/{'S'+s.pad(2)}/{s00e00} - {t} - {source}-{vf}" "movieFormat=/plex/.Temp/{fn =~ /3d/ ? '3D-Filme' : 'Filme'}/{n} ({y}){fn =~ /3d/ ? ' [3D]' : ''}/{n} ({y}){fn =~ /3d/ ? ' [3D].H-SBS' : ''}" --def "animeFormat=/plex/.Temp/Serien/{n}/{'S'+s.pad(2)}/{s00e00} - {t} - {source}-{vf}" &>/dev/null

  # Rename Show Qualities
  find /plex/.Temp -type f -name '*- -480p.mkv' | while read f; do mv -v "$f" "${f%- -480p.mkv}- DVDRip-480p.mkv"; done
  find /plex/.Temp -type f -name '*- -576p.mkv' | while read f; do mv -v "$f" "${f%- -576p.mkv}- DVDRip-480p.mkv"; done
  find /plex/.Temp -type f -name '*- -720p.mkv' | while read f; do mv -v "$f" "${f%- -720p.mkv}- WEBDL-720p.mkv"; done
  find /plex/.Temp -type f -name '*- WEBRip-720p.mkv' | while read f; do mv -v "$f" "${f%- WEBRip-720p.mkv}- WEBDL-720p.mkv"; done
  find /plex/.Temp -type f -name '*- Web-DL-720p.mkv' | while read f; do mv -v "$f" "${f%- Web-DL-720p.mkv}- WEBDL-720p.mkv"; done
  find /plex/.Temp -type f -name '*- WEB-DL-720p.mkv' | while read f; do mv -v "$f" "${f%- WEB-DL-720p.mkv}- WEBDL-720p.mkv"; done
  find /plex/.Temp -type f -name '*- WEB.DL-720p.mkv' | while read f; do mv -v "$f" "${f%- WEB.DL-720p.mkv}- WEBDL-720p.mkv"; done
  find /plex/.Temp -type f -name '*- ithd-720p.mkv' | while read f; do mv -v "$f" "${f%- ithd-720p.mkv}- WEBDL-720p.mkv"; done
  find /plex/.Temp -type f -name '*- iTunesHD-720p.mkv' | while read f; do mv -v "$f" "${f%- iTunesHD-720p.mkv}- WEBDL-720p.mkv"; done
  find /plex/.Temp -type f -name '*- NetflixHD-720p.mkv' | while read f; do mv -v "$f" "${f%- NetflixHD-720p.mkv}- WEBDL-720p.mkv"; done
  find /plex/.Temp -type f -name '*- BD-720p.mkv' | while read f; do mv -v "$f" "${f%- BD-720p.mkv}- BluRay-720p.mkv"; done
  find /plex/.Temp -type f -name '*- BDRip-720p.mkv' | while read f; do mv -v "$f" "${f%- BDRip-720p.mkv}- BluRay-720p.mkv"; done
  find /plex/.Temp -type f -name '*- WEBRip-1080p.mkv' | while read f; do mv -v "$f" "${f%- WEBRip-1080p.mkv}- WEBDL-1080p.mkv"; done
  find /plex/.Temp -type f -name '*- WEB-DL-1080p.mkv' | while read f; do mv -v "$f" "${f%- WEB-DL-1080p.mkv}- WEBDL-1080p.mkv"; done
  find /plex/.Temp -type f -name '*- -1080p.mkv' | while read f; do mv -v "$f" "${f%- -1080p.mkv}- BluRay-1080p.mkv"; done
  find /plex/.Temp -type f -name '*- BD-1080p.mkv' | while read f; do mv -v "$f" "${f%*- BD-1080p.mkv}- BluRay-1080p.mkv"; done

  # Verschiebe 3D-Filme
  ser=/plex/.Temp/3D-Filme
  while IFS=  read -r -d $'\0'; do
    ## This loop is white space safe
    j="$REPLY"
    fn="$(basename "$j")"             # $j in subshell must be quoted
    fd="$(readlink -f "$j")"          # absolute path
    px="${j/\/plex\/.Temp\//\/plex\/}" # destination
    pxd="$(dirname "$px")"            # destination dir
    printf "[Verschiebe $fn nach: $pxd\n"
    # This find command will move the existing file to recycle bin
    find "$pxd" -type f -name "$fn" -exec \
        bash -c 'rbin="${0/\/plex\//\/plex\/.Recycle.Bin\/}"
        mkdir -p "$(dirname "$rbin")"
        printf "Und vorhandene Datei nach: $rbin]\n"
        # mv -f is used, intention is to overwrite existing file in recycle bin
        mv -f "$0" "$rbin"' \
        {} \; 2>/dev/null
    # Now mv can be executed
    mkdir -p "$pxd"                   # Create the destination dirs
    mv "$fd" "$px"                    # Execute the mv
  done < <(find "$ser" -type f -name '*.mkv' -print0)
  find /plex/.Temp/3D-Filme/* -empty -type d -delete &>/dev/null
  
  # Verschiebe Filme
  ser=/plex/.Temp/Filme
  while IFS=  read -r -d $'\0'; do
    ## This loop is white space safe
    j="$REPLY"
    fn="$(basename "$j")"             # $j in subshell must be quoted
    fd="$(readlink -f "$j")"          # absolute path
    px="${j/\/plex\/.Temp\//\/plex\/}" # destination
    pxd="$(dirname "$px")"            # destination dir
    printf "[Verschiebe $fn nach: $pxd\n"
    # This find command will move the existing file to recycle bin
    find "$pxd" -type f -name "$fn" -exec \
        bash -c 'rbin="${0/\/plex\//\/plex\/.Recycle.Bin\/}"
        mkdir -p "$(dirname "$rbin")"
        printf "Und vorhandene Datei nach: $rbin]\n"
        # mv -f is used, intention is to overwrite existing file in recycle bin
        mv -f "$0" "$rbin"' \
        {} \; 2>/dev/null
    # Now mv can be executed
    mkdir -p "$pxd"                   # Create the destination dirs
    mv "$fd" "$px"                    # Execute the mv
  done < <(find "$ser" -type f -name '*.mkv' -print0)
  find /plex/.Temp/Filme/* -empty -type d -delete &>/dev/null
  
  # Verschiebe Serien
  ser=/plex/.Temp/Serien
  while IFS=  read -r -d $'\0'; do
    ## This loop is white space safe
    j="$REPLY"
    fn="$(basename "$j")"             # $j in subshell must be quoted
    ep_pat="(^[Ss][0-9]+[Ee][0-9]+)"
    [[ $fn =~ $ep_pat ]]
    ep="${BASH_REMATCH[1]}"           # episode string e.g S01E234
    fd="$(readlink -f "$j")"          # absolute path
    px="${j/\/plex\/.Temp\//\/plex\/}" # destination
    pxd="$(dirname "$px")"            # destination dir
    printf "[Verschiebe $fn nach: $pxd\n"
    # This find command will move the existing file to recycle bin
    find "$pxd" -type f -name "$ep*.mkv" -exec \
        bash -c 'rbin="${0/\/plex\//\/plex\/.Recycle.Bin\/}"
        mkdir -p "$(dirname "$rbin")"
        printf "Und vorhandene Datei nach: $rbin]\n"
        # mv -f is used, intention is to overwrite existing file in recycle bin
        mv -f "$0" "$rbin"' \
        {} \; 2>/dev/null
    # Now mv can be executed
    mkdir -p "$pxd"                   # Create the destination dirs
    mv "$fd" "$px"                    # Execute the mv
  done < <(find "$ser" -type f -name '*.mkv' -print0)
  find /plex/.Temp/Serien/* -empty -type d -delete &>/dev/null
  
   # Remux DL
  ser=/downloads/Remux/
  while IFS=  read -r -d $'\0'; do
    ## This loop is white space safe
    j="$REPLY"
    fn="$(basename "$j")"             # $j in subshell must be quoted
    fd="$(readlink -f "$j")"          # absolute path
    px="${j/\/downloads\/Remux\//\/downloads\/RSScrawler\/}" # destination (for muxing)
    pl="${j/\/downloads\/Remux\//\/plex\/}" # 720p.mkv
	rbin="${j/\/downloads\/Remux\//\/plex\/.Recycle.Bin\/}" # 720p.mkv
    pxd="$(dirname "$px")"            # destination dir
    if [ -f "$pl" ]; then
        printf "[Remuxe $fn zu zweisprachiger Datei in $pxd]\n"
        mkdir -p "$pxd"                   # Create the destination dirs
        # Merge mkv at RSScrawler folder with Video from existing File (in Plex Library) and Subtitles, Chapters, and Audio from File at Remux
        mkvmerge -o "$px" -A -S --no-chapters "$pl" -D "$j"
        # Create Folder at Recycle Bin and move Remux file there
        mkdir -p "$(dirname "$rbin")"
        mv -f "$j" "$rbin"
    fi
  done < <(find "$ser" -type f -name '*.mkv' -print0)
  find /downloads/Remux/* -empty -type d -delete &>/dev/null
fi
# Wait a minute
sleep 1m
done
