#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / prepare-deb.sh
#
# Nettoie l'arborescence du répertoire d'installation
#
# @author : INIST-CNRS/DPI
#
################################################################################

#-------------------------------------------------------------------------------
# Environnement
#-------------------------------------------------------------------------------
MODULE_NAME="CLEAN-DEB"
MODULE_DESC="Nettoie l'arborescence du répertoire d'installation"
MODULE_VERSION=$(git describe --tags)
MODULE_VERSION_SHORT=$(git describe --tags | cut -d"-" -f1 )
CURDIR=$( cd "$( dirname "$0" )" && pwd )
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_ROOT=$(readlink -f "$DIR_MODULE/../")
DIR_CONF=$(readlink -f "$DIR_MODULE/../conf")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs")
DIR_TOOLS=$(readlink -f "$DIR_MODULE/../tools")
DIR_INSTALL=$(readlink -f "$DIR_MODULE/../install")
DIR_SYSINSTALL="$DIR_INSTALL/opt"

# ------------------------------------------------------------------------------
# Nettoyage 
# ------------------------------------------------------------------------------
# Suppression Arbo /opt
if [ -d "$DIR_INSTALL/opt" ]; then
  rm -Rf "$DIR_INSTALL/opt"
fi

# Suppression .deb généré
# PACKAGE=$(find "$DIR_ROOT" -type f -name "*.deb")
# if [ ! -z "$PACKAGE" ]; then
#   rm "$PACKAGE"
# fi
