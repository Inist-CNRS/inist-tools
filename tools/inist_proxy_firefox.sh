#!/usr/bin/env bash
########################################################################
#
# INIST-TOOLS / INIST_PROXY_FIREFOX
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
MODULE_DESC="Positionne le proxy INIST pour Firefox."
MODULE_VERSION=$(git describe --tags)
CURDIR=$( cd "$( dirname "$0" )" && pwd )
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs/")

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
echo "$MODULE_NAME [$MODULE_VERSION]"
echo "MODULE_DESC"
echo
