#!/usr/bin/env bash
########################################################################
#
# INIST-TOOLS / INIST NO PROXY
# 
# Reset toutes les variables d'environnement de la session courante
# pour le proxy INIST.
#
# @author : INIST-CNRS/DPI
#
########################################################################

#-----------------------------------------------------------------------
# Environnement
#-----------------------------------------------------------------------
MODULE_NAME="INIST NO PROXY"
MODULE_DESC="Reset toutes les variables d'environnement de la session courante pour le proxy INIST"
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
printf "$MODULE_NAME [$MODULE_VERSION]\n"
printf "$MODULE_DESC\n"

#-----------------------------------------------------------------------
# Reset des variables d'environnement
#-----------------------------------------------------------------------
unset "no_proxy"
unset "http_proxy"
unset "https_proxy"
unset "ftp_proxy"

unset "NO_PROXY"
unset "HTTP_PROXY"
unset "HTTPS_PROXY"
unset "FTP_PROXY"
