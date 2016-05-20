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
# 
# 
#-----------------------------------------------------------------------
# Dir. par défaut de la conf FF
FF_CONF_DIR="$USER/.mozilla/firefox"
# Est-ce le répertoire FF_CONF_DIR existe ? Est-il pertinent ?
if [ -d $FF_CONF_DIR ]; then
  #OUI ? Hé ben c'est super !
  
else
  #NON... aïe...
  FF_CONF_DIR=$(find ~ -type d -name "firefox" | grep "\.mozilla")
  if [ -z FF_CONF_DIR ]; then
    # Répertoire totalement introuvable... on abondonne !
    IT_MESSAGE "ERROR" "Répertoire de configuration de Firefox totalement introuvable. Fin."
    exit 1
  fi
fi

# Est-ce qu'un user.js existe déjà ?
if [ -f "$FF_CONF_DIR/user.js" ]; then
  # OUI
  # On ajoute les paramètres de proxy au fichier
else
  # NON
  # On crée le fichier
  # On ajoute les paramètres de proxy au fichier nouvellement créé
fi

#-----------------------------------------------------------------------
# Suppression des paramètres de proxy
# dans le cas où on a l'option -d,--delete
#-----------------------------------------------------------------------
# ToDo

#-----------------------------------------------------------------------
# Positionnement du proxy pour l'environnement courant
#-----------------------------------------------------------------------
# "$DIR_TOOLS/inist_proxy.sh"

#-----------------------------------------------------------------------
# Lancement de firefox
#-----------------------------------------------------------------------
# firefox &
