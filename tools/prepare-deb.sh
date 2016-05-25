#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / prepare-deb.sh
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
MODULE_DESC="Prépare l'arborescence et les fichiers en vue de créer le .deb"
MODULE_VERSION=$(git describe --tags)
MODULE_VERSION_SHORT=$(git describe --tags | cut -d"-" -f1 )
CURDIR=$( cd "$( dirname "$0" )" && pwd )
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_ROOT=$(readlink -f "$DIR_MODULE/..")
DIR_CONF=$(readlink -f "$DIR_MODULE/../conf")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs")
DIR_TOOLS=$(readlink -f "$DIR_MODULE/../tools")
DIR_INSTALL=$(readlink -f "$DIR_MODULE/../install")
DIR_SYSINSTALL="$DIR_INSTALL/opt"

# ------------------------------------------------------------------------------
# Nettoyage 
# ------------------------------------------------------------------------------
if [ -d "$DIR_INSTALL/opt" ]; then
  rm -Rf "$DIR_INSTALL/opt"
fi

# ------------------------------------------------------------------------------
# Création de l'arbo
# ------------------------------------------------------------------------------
mkdir -p "$DIR_INSTALL/opt/inist-tools"

# ------------------------------------------------------------------------------
# Copie des fichiers utiles (et seulements ceux-là)
# ------------------------------------------------------------------------------
cp "$DIR_ROOT/inist" "$DIR_SYSINSTALL/inist-tools/"
cp -R "$DIR_CONF" "$DIR_SYSINSTALL/inist-tools/"
cp -R "$DIR_LIBS" "$DIR_SYSINSTALL/inist-tools/"
cp -R "$DIR_TOOLS" "$DIR_SYSINSTALL/inist-tools/"


# ------------------------------------------------------------------------------
# FIN !
# ------------------------------------------------------------------------------
exit 0
