#!/usr/bin/env bash
################################################################################
#
# inist-tools / libs / gource / gource.sh
# 
# Script de génération d'un gource à partir d'un repository git
#
# @author : INIST-CNRS/DPI
#
################################################################################

TMP_DIR="$1"
PROJECT_REPOSITORY="$2"
PROJECT_NAME="$3"
SPRINT_NAME="$4"
SPRINT_START="$5"
SPRINT_END="$6"
GENERATE_VIDEO="1"

if [ ! -z "TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
  cd "TMP_DIR"
else
  exit 1
fi

# get all the istex github repositories name
# and generate a commit log for each repository
MODULES=$(/opt/inist-tools/libs/gource/get-repository-list.js)
for M in $MODULES
do
  # clone source code
  echo "-> Getting source code"
  mkdir -p "TMP_DIR/sources/"
  if [ -d "TMP_DIR/sources/$M/" ]; then
    cd "TMP_DIR/sources/$M"
    git pull
    cd ../..
  else
    cd "TMP_DIR/sources/"
    #
    # ~ Refactoring ~
    # Structure des variables à renseigner
    # git clone "git@$GIT_SERVER:$GIT_REPO[/$MODULE_NAME].git"
    #
    git clone "git@vpgithub.intra.inist.fr:istex/$M.git"
    cd ..
  fi
  # code source commit logs
  echo "-> Generating $M.log"
  gource --output-custom-log "./logs_$M.log" ./sources/$M/
  sed -i -E "s#(.+)\|#\1|/$PROJECT_NAME/$M#" ./logs_$M.log
done

# sort by date
echo "-> Sorting *.log"
cat ./logs_*.log | sort -n > ./gource-all.log

# date range
TIMESTAMP1=`date --date="$SPRINT_START" +%s`
TIMESTAMP2=`date --date="$SPRINT_END" +%s`

# filter logs out of the date range
echo "-> Filtering date range"
rm -f ./gource-range.log
touch ./gource-range.log
while read line
do
  TIMESTAMP=`echo $line | awk -F'|' '{ print $1 }'`
  if [ "${TIMESTAMP:-0}" -ge $TIMESTAMP1 ] ; then
    if [ "${TIMESTAMP:-0}" -le $TIMESTAMP2 ] ; then
      echo $line >> ./gource-range.log
    fi
  fi
done < ./gource-all.log

echo "-> Generating the gource"
# generate the video
if [ "$GENERATE_VIDEO" == "1" ]; then
  gource --seconds-per-day 2 \
         --file-filter ".*node_modules.*" \
         --file-filter ".*dataset.*" \
         --output-framerate 60 \
         --user-scale 1.5 \
         --user-image-dir ./avatars/ \
         --path ./gource-range.log \
         -1024x576 -o - \
        | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libvpx -b 10000K gource-$PROJECT_NAME-$SPRINT_NAME.webm
else
  gource --seconds-per-day 2 \
         --file-filter ".*node_modules.*" \
         --file-filter ".*dataset.*" \
         --output-framerate 60 \
         --user-scale 1.5 \
         --user-image-dir ./avatars/ \
         --path ./gource-range.log
fi
echo "-> Gource generated"
