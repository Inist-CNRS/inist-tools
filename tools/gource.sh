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
PROJECT_URL="$1"
PROJECT_NAME=$(echo $PROJECT_URL | rev | cut -d "/" -f1 | rev | cut -d "." -f 1)
SPRINT_NAME="$2"
SPRINT_START="$3"
SPRINT_END="$4"
GENERATE_VIDEO="1"

# ------------------------------------------------------------------------------
# Variables locales
# ------------------------------------------------------------------------------
TMP_DIR="/tmp/$PROJECT_NAME/$SPRINT_START/$SPRINT_NAME"

# ---------------------------------
# Création du répertoire temporaire
# ---------------------------------
mkdir -p "$TMP_DIR"
if [ ! -z "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
  cd "$TMP_DIR"
else
  exit 1
fi

# ----------------------
# Récupération du source 
# ----------------------
_it_std_consoleMessage "INFO" "Récupération des sources"
mkdir -p "$TMP_DIR/sources/"
if [ -d "$TMP_DIR/sources/$PROJECT_NAME/" ]; then
  cd "$TMP_DIR/sources/$PROJECT_NAME"
  git pull
  cd ../..
else
  cd "$TMP_DIR/sources/"
  git clone "$PROJECT_URL"
  cd "$TMP_DIR"
fi

# --------------------------
# Logs de commit des sources
# --------------------------
_it_std_consoleMessage "INFO" "Generation de $PROJECT_NAME.log"
gource --output-custom-log "$TMP_DIR/logs_$PROJECT_NAME.log" "$TMP_DIR/sources/$PROJECT_NAME/"
# vérifier l'usage de la ligne suivante durant les tests...
# sed -i -E "s#(.+)\|#\1|/$PROJECT_NAME/$PROJECT_NAME#" ./logs_$PROJECT_NAME.log

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
         --user-image-dir "/opt/inist-tools/gfx/gource/avatars/" \
         --path ./gource-range.log \
         -1024x576 -o - \
        | avconv -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libvpx -b 10000K "$TMP_DIR/gource-$PROJECT_NAME-$SPRINT_NAME.webm"
else
  gource --seconds-per-day 2 \
         --file-filter ".*node_modules.*" \
         --file-filter ".*dataset.*" \
         --output-framerate 60 \
         --user-scale 1.5 \
         --user-image-dir "/opt/inist-tools/libs/gfx/avatars/" \
         --path "$TMP_DIR/gource-range.log"
fi

_it_std_consoleMessage "OK" "Gource généré, disponible ici : « $TMP_DIR/gource-$PROJECT_NAME-$SPRINT_NAME.webm »"

#_it_std_consoleMessage "ACTION" "Nettoyage du dossier temporaire"
#if rm -rf "$TMP_DIR" ; then
  #_it_std_consoleMessage "OK" "« $TMP_DIR » supprimé"
  #exit $TRUE
#else
  #_it_std_consoleMessage "NOK" "impossible de supprimer « $TMP_DIR »"
  #exit $FALSE
#fi


