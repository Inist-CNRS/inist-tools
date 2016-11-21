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
MODULE_NAME="PUBLISH-DEB"
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
DIR_PROXYPAC=$(readlink -f "$DIR_MODULE/../proxypac")
DIR_RELEASES=$(readlink -f "$DIR_MODULE/../releases")
DIR_INSTALL=$(readlink -f "$DIR_MODULE/../install")
DIR_SYSINSTALL="$DIR_INSTALL/opt"

# ------------------------------------------------------------------------------
# Publication sur GitHub
# ------------------------------------------------------------------------------
# Trouver le .deb
# DOTDEB=$(find "$DIR_RELEASES" -type f -name "inist-tools_*.deb")
DOTDEB="$DIR_RELEASES/inist-tools_$MODULE_VERSION_FOR_CONTROL.deb"
if [ -z "$DOTDEB" ]; then
  _it_std_consoleMessage "ERROR" "Fichier .deb introuvable."
  exit 1
fi

PACKAGENAME=$(basename "$DOTDEB")

# Ajouter le .deb au dépôt
git add "$DIR_RELEASES/$PACKAGENAME"

# Ajouter le #latest au dépôt
git add "$DIR_RELEASES/inist-tools_latest.deb"

# Comitter
git commit -a -m "Publication du package « $PACKAGENAME » [$MODULE_VERSION]"

# Pusher
git push --tags && git push

# ------------------------------------------------------------------------------
# FIN !
# ------------------------------------------------------------------------------
exit 0
