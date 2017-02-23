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

# ------------------------------------------------------------------------------
# Conf
# ------------------------------------------------------------------------------
export PATH="$PATH:/opt/inist-tools"
PID="$$"
PARENT_COMMAND="$(ps -o comm= $PPID)"
MODULE_NAME="INIST-TOOLS"
DIR_MODULE="/opt/inist-tools" # fixé "en dur" en fonction du chemin définitif
DIR_CONF="$DIR_MODULE/conf"
DIR_LIBS="$DIR_MODULE/libs"
DIR_TOOLS="$DIR_MODULE/tools"
DIR_INSTALL="$DIR_MODULE/install"
DIR_ENV="$DIR_MODULE/env"

# ------------------------------------------------------------------------------
# Libs
# ------------------------------------------------------------------------------
source "$DIR_LIBS/ansicolors.rc"
source "$DIR_LIBS/std.rc"

# ------------------------------------------------------------------------------
# Ligne de commande
# ------------------------------------------------------------------------------
# TMP_DIR="$1"
PROJECT_URLS="$1"
SPRINT_NAME="$2"
SPRINT_START="$3"
SPRINT_END="$4"
AVATARS_DIR="$5"
GENERATE_VIDEO="1"

PROJECT_NAME_LIST=""

# ---------------------------------
# Création du répertoire temporaire
# ---------------------------------
TMP_DIR="/tmp/inist-gource/$SPRINT_NAME/$SPRINT_START"
mkdir -p "$TMP_DIR"
if [ ! -z "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
  cd "$TMP_DIR"
else
  _it_std_consoleMessage "ERROR" "« $TMP_DIR » introuvable !?!"
  exit 1
fi

# -----------------------
# Bouclage sur les dépôts
# -----------------------
for depot in $PROJECT_URLS
do

  if curl -I "$depot" 2>&1 | grep "HTTP/1.0 4" || curl -I "$depot" 2>&1 | grep "HTTP/1.0 5" ; then
    _it_std_consoleMessage "ERROR" "L'URL du dépôt ($IT_GOURCE_GITURL) ne semble pas valide ou pas atteignable. Commande interrompue."
    exit $FALSE
  fi
  
  # Nom du projet
  PROJECT_NAME=$(echo $depot | rev | cut -d "/" -f1 | rev | cut -d "." -f 1)

  # Récupération des sources
  _it_std_consoleMessage "INFO" "Récupération des sources pour '$PROJECT_NAME'"
  mkdir -p "$TMP_DIR/sources/"
  if [ -d "$TMP_DIR/sources/$PROJECT_NAME/" ]; then
    cd "$TMP_DIR/sources/$PROJECT_NAME"
    git pull
    cd ../..
  else
    cd "$TMP_DIR/sources/"
    git clone "$depot" "$PROJECT_NAME"
    cd "$TMP_DIR"
  fi

  # Logs de commit des sources
  _it_std_consoleMessage "INFO" "Generation de $PROJECT_NAME.log"
  gource --output-custom-log "$TMP_DIR/logs_$PROJECT_NAME.log" "$TMP_DIR/sources/$PROJECT_NAME/"

  PROJECT_NAME_LIST="$PROJECT_NAME_LIST$PROJECT_NAME "
  
done


# --------------- 
# Fusion des logs
# ---------------
for project in $PROJECT_NAME_LIST
do
  _it_std_consoleMessage "INFO" "Fusion des logs pour '$project'"
  sed -i -E "s#(.+)\|#\1|/$SPRINT_NAME/$project#" ./logs_$project.log
done

# --------------------- 
# Tri des logs par date
# ---------------------
_it_std_consoleMessage "INFO" "Tri des logs"
cat ./logs_*.log | sort -n > ./gource-all.log

# ---------------
# Plages de dates
# ---------------
TIMESTAMP1=`date --date="$SPRINT_START" +%s`
TIMESTAMP2=`date --date="$SPRINT_END" +%s`

# ------------------------------------------------
# Filtrage des logs en dehors de la plage de dates
# ------------------------------------------------
_it_std_consoleMessage "INFO" "Filtrage des plages de dates"
rm -f "$TMP_DIR/gource-range.log"
touch "$TMP_DIR/gource-range.log"

while read line
do
  TIMESTAMP=`echo $line | awk -F'|' '{ print $1 }'`
  if [ "${TIMESTAMP:-0}" -ge $TIMESTAMP1 ] ; then
    if [ "${TIMESTAMP:-0}" -le $TIMESTAMP2 ] ; then
      echo $line >> "$TMP_DIR/gource-range.log"
    fi
  fi
done < "$TMP_DIR/gource-all.log"

# --------------------
# Génération du gource
# --------------------
#        | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libvpx -b 10000K "$TMP_DIR/gource-$PROJECT_NAME-$SPRINT_NAME.webm"

_it_std_consoleMessage "ACTION" "Generation du gource\n"
if [ "$GENERATE_VIDEO" == "1" ]; then
  gource --seconds-per-day 2 \
         --file-filter ".*node_modules.*" \
         --file-filter ".*dataset.*" \
         --output-framerate 60 \
         --user-scale 1.5 \
         --user-image-dir "$AVATARS_DIR" \
         --path ./gource-range.log \
         -1920x1080 -o - \
        | avconv -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libvpx -b 50000K "$TMP_DIR/gource-$PROJECT_NAME-$SPRINT_NAME.webm"
else
  gource --seconds-per-day 2 \
         --file-filter ".*node_modules.*" \
         --file-filter ".*dataset.*" \
         --output-framerate 60 \
         --user-scale 1.5 \
         --user-image-dir "$AVATARS_DIR" \
         --path "$TMP_DIR/gource-range.log"
fi

if [ $? -eq $TRUE ]; then
  _it_std_consoleMessage "OK" "Gource généré, disponible ici : « $TMP_DIR/gource-$PROJECT_NAME-$SPRINT_NAME.webm »"
else
  _it_std_consoleMessage "NOK" "Un problème est survenu.»"
fi


