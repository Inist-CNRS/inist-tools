#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / prepare-deb.sh
#
# Crée le .deb pour inist-tools
#
# @author : INIST-CNRS/DPI
#
################################################################################

#-------------------------------------------------------------------------------
# Environnement
#-------------------------------------------------------------------------------
MODULE_NAME="PACKAGE-DEB"
MODULE_DESC="Crée le .deb"
MODULE_VERSION=$(git describe --tags)
MODULE_VERSION_SHORT=$(git describe --tags | cut -d"-" -f1 )
MODULE_VERSION_FOR_CONTROL=$(git describe --tags | cut -d"-" -f1 | cut -d "v" -f 2)
CURDIR=$( cd "$( dirname "$0" )" && pwd )
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_ROOT=$(readlink -f "$DIR_MODULE/../")
DIR_CONF=$(readlink -f "$DIR_MODULE/../conf")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs")
DIR_TOOLS=$(readlink -f "$DIR_MODULE/../tools")
DIR_INSTALL=$(readlink -f "$DIR_MODULE/../install")
DIR_SYSINSTALL="$DIR_INSTALL/opt"
DIR_RELEASES=$(readlink -f "$DIR_MODULE/../releases")


#-------------------------------------------------------------------------------
# ROOT own U !
#-------------------------------------------------------------------------------
chmod -R 755 "$DIR_INSTALL"
# chown -R root:root "$DIR_INSTALL"

#-------------------------------------------------------------------------------
# Build...
#-------------------------------------------------------------------------------
fakeroot dpkg-deb --build "$DIR_INSTALL" "$DIR_RELEASES/inist-tools_$MODULE_VERSION_FOR_CONTROL.deb"

# ------------------------------------------------------------------------------
# On repositionne les droits pour que le user courant puisse y accéder
# ------------------------------------------------------------------------------
# chown -R $USER:$USER "$DIR_INSTALL"
# chmod -R 777 "$DIR_INSTALL"

# ------------------------------------------------------------------------------
# FIN !
# ------------------------------------------------------------------------------
exit 0
