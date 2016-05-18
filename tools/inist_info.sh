#!/usr/bin/env bash
########################################################################
#
# INIST-TOOLS / INIST INFO
# 
# Affiche un certain nombre d'informations concernant l'environnement
# en cours.
#
# @author : INIST-CNRS/DPI
#
########################################################################

#-----------------------------------------------------------------------
# Environnement
#-----------------------------------------------------------------------
MODULE_NAME="INIST INFO"
MODULE_DESC="Affiche des informations sur l'environnement en cours"
MODULE_VERSION=$(git describe --tags)
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
printf "$MODULE_NAME [$MODULE_VERSION]\n"
printf "$MODULE_DESC\n"

#-----------------------------------------------------------------------
# Récupération des infos
#-----------------------------------------------------------------------

## Réseau
# Combien d'interfaces filaires ?
INFO_NET_ETH_COUNT=$(ifconfig -s | grep -i "eth" | wc -l)
# Combien d'interfaces WiFi ?
INFO_NET_WLAN_COUNT=$(ifconfig -s | grep -i "wlan" | wc -l)
# INIST ou pas INIST ?
if IT_CHECK_CONNECTION ; then
  INFO_NET_INIST="INIST"
else
  INFO_NET_INIST="en mobilité"
fi
# Wifi ou filaire ?
if $(ifconfig | grep -i "wlan") ; then
  INFO_NET_TYPE="wifi"
else
  INFO_NET_TYPE="ethernet"
fi
# Adresse IP
INFO_NET_IP=$(hostname  -I | cut -f1 -d' ')

## Docké ou pas ?
if IT_CHECK_DOCKED ; then
  INFO_GENERAL_DOCKED="oui"
else
  INFO_GENERAL_DOCKED="non"
fi

#-----------------------------------------------------------------------
# Affichage des infos
#-----------------------------------------------------------------------

printf "\n"
printf "Général\n"
printf "Dock  :\t$INFO_GENERAL_DOCKED\n"


printf "\n"
printf "Informations Réseau\n"
printf "Interface(s) ETH active(s)  :\t$INFO_NET_ETH_COUNT\n"
printf "Interface(s) WIFI active(s) :\t$INFO_NET_WLAN_COUNT\n"
printf "Réseau en cours             :\t$INFO_NET_TYPE\n"
printf "Adresse IP                  :\t$INFO_NET_IP\n"
printf "Réseau utilisé              :\t$INFO_NET_INIST\n"

printf "\n"
printf "Environnement\n"
printf "Utilisateur courant     : $USER\n"
printf "Répertoire d'exectution : $CURDIR\n"

