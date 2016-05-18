#!/usr/bin/env bash
########################################################################
#
# INIST-TOOLS / INIST PROXY FIREFOX
# 
# Positionne le proxy INIST pour Firefox.
#
# @author : INIST-CNRS/DPI
#
########################################################################

#-----------------------------------------------------------------------
# Environnement
#-----------------------------------------------------------------------
MODULE_NAME="INIST PROXY FIREFOX"
MODULE_DESC="Lance Firefox avec le proxy INIST positionné."
MODULE_VERSION=$(git describe --tags)
MODULE_VERSION_SHORT=$(git describe --tags | cut -d"-" -f1 )
CURDIR=$( cd "$( dirname "$0" )" && pwd )
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs/")
DIR_TOOLS=$(readlink -f "$DIR_MODULE/../tools/")

#-----------------------------------------------------------------------
# Chargement des libs (pour rendre le module autonome)
#-----------------------------------------------------------------------
if [ -f "$DIR_LIBS/inist.lib.sh" ]; then
  source "$DIR_LIBS/inist.lib.sh"
else
  logger -s "[$MODULE_NAME] [ERROR] Impossible de charger la librairie depuis « $DIR_LIBS ». Fin."
  exit 1
fi

#-----------------------------------------------------------------------
# Greeting
#-----------------------------------------------------------------------
cat "$DIR_LIBS/firefox.ansi"
IT_GREETING

#-----------------------------------------------------------------------
# Tester si firefox existe, sinon, adieu !
#-----------------------------------------------------------------------
if ! IT_CHECK_BINARY "firefox" ; then
  IT_MESSAGE "ERROR" "Firefox n'est pas installé. Fin."
  exit 1
fi
#-----------------------------------------------------------------------
# Positionnement du proxy pour l'environnement courant
#-----------------------------------------------------------------------
"$DIR_TOOLS/inist_proxy.sh"

#-----------------------------------------------------------------------
# Lancement de firefox
#-----------------------------------------------------------------------
firefox &
