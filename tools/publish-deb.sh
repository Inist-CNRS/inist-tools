#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / publish-deb.sh
#
# Prépare l'arborescence en vue de créer le .deb pour inist-tools
#
# @author : INIST-CNRS/DPI
#
################################################################################

#-------------------------------------------------------------------------------
# Environnement
#-------------------------------------------------------------------------------
MODULE_NAME="PREPARE-DEB"
MODULE_DESC="Publie le .deb sur github"
MODULE_VERSION=$(git describe --tags)
MODULE_VERSION_SHORT=$(git describe --tags | cut -d"-" -f1)
MODULE_VERSION_FOR_CONTROL=$(git describe --tags | cut -d"-" -f1 | cut -d "v" -f 2)
CURDIR=$( cd "$( dirname "$0" )" && pwd )
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_ROOT=$(readlink -f "$DIR_MODULE/..")
DIR_CONF=$(readlink -f "$DIR_MODULE/../conf")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs")
DIR_TOOLS=$(readlink -f "$DIR_MODULE/../tools")
DIR_INSTALL=$(readlink -f "$DIR_MODULE/../install")
DIR_SYSINSTALL="$DIR_INSTALL/opt"

# ------------------------------------------------------------------------------
# Publication sur GitHub
# ------------------------------------------------------------------------------
# Trouver le .deb
DOTDEB=$(find "$DIR_ROOT" -type f -name "inist-tools_*.deb")
if [ -z "$DOTDEB" ]; then
  _it_std_consoleMessage "ERROR" "Fichier .deb introuvable."
  exit 1
fi

# Ajouter le .deb au dépôt
git add "$DOTDEB"

# Comitter
git commit -a -m "Publication du package « $DOTDEB » [$MODULE_VERSION]"

# Pusher
git push

# ------------------------------------------------------------------------------
# FIN !
# ------------------------------------------------------------------------------
exit 0
