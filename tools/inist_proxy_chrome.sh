#!/usr/bin/env bash
########################################################################
#
# INIST-TOOLS / INIST_PROXY_CHROME
# 
# Positionne le proxy INIST pour Chrome.
#
# @author : INIST-CNRS/DPI
#
########################################################################

#-----------------------------------------------------------------------
# Environnement
#-----------------------------------------------------------------------
MODULE_NAME="INIST PROXY CROM[E|MIUM]"
MODULE_DESC="Lance Chrom[e|ium] avec le proxy.pac INIST positionné."
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

# Déterminer si c'est Chrome ou Chromium
if IT_CHECK_BINARY "chromium-browser" ; then
  BROWSER="chromium-browser"
  cat "$DIR_LIBS/chromium.ansi"
else
  BROWSER="google-chrome"
  cat "$DIR_LIBS/chrome.ansi"
fi

#-----------------------------------------------------------------------
# Greeting
#-----------------------------------------------------------------------
printf "$MODULE_NAME [$MODULE_VERSION]\n"
printf "$MODULE_DESC\n"

#-----------------------------------------------------------------------
# Lancement du navigateur
#-----------------------------------------------------------------------
$BROWSER --proxy-pac-url="http://proxypac.intra.inist.fr/proxy.pac" &
