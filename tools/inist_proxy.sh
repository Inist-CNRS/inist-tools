#!/usr/bin/env bash
########################################################################
#
# INIST-TOOLS / INIST_PROXY
# 
# Positionne les variables d'environnement de la session courante
# pour les proxies INIST.
#
# @author : INIST-CNRS/DPI
#
########################################################################

#-----------------------------------------------------------------------
# Environnement
#-----------------------------------------------------------------------
MODULE_NAME="INIST PROXY"
MODULE_DESC="Positionne les variables d'environnement de la session courante pour les proxies INIST"
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

# Exclusion du proxy
IT_MESSAGE "NOTICE" "Dépositionnement du proxy pour localhost"
export no_proxy=localhost,127.0.0.0/8,*.local
export NO_PROXY=localhost,127.0.0.0/8,*.local

# HTTP
IT_MESSAGE "NOTICE" "Positionnement du proxy INIST pour HTTPS"
export http_proxy="http://proxyout.inist.fr:8080"
export HTTP_PROXY="http://proxyout.inist.fr:8080"

# HTTPS
IT_MESSAGE "NOTICE" "Positionnement du proxy INIST pour HTTPS"
export https_proxy="http://proxyout.inist.fr:8080"
export HTTPS_PROXY="http://proxyout.inist.fr:8080"

# FTP
IT_MESSAGE "NOTICE" "Positionnement du proxy INIST pour FTP"
export ftp_proxy="http://proxyout.inist.fr:8080"
export FTP_PROXY="http://proxyout.inist.fr:8080"

# Sortie "propre"
exit 0
