#!/usr/bin/env bash
########################################################################
#
# INIST-TOOLS / T.U. Réseau
# 
# @author : INIST-CNRS/DPI
#
########################################################################

#-----------------------------------------------------------------------
# Environnement
#-----------------------------------------------------------------------
MODULE_NAME="T.U. Réseau"
MODULE_DESC="Tests unitaires pour les fonctionalités réseau"
MODULE_VERSION=$(git describe --tags)
MODULE_VERSION_SHORT=$(git describe --tags | cut -d"-" -f1 )
CURDIR=$( cd "$( dirname "$0" )" && pwd )
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs/")

source "$DIR_LIBS/std.rc"

#-----------------------------------------------------------------------
# Greeting !
#-----------------------------------------------------------------------
printf "################################################################################\n"
printf "$MODULE_NAME\n"
printf "$MODULE_DESC\n"
printf "################################################################################\n"

#-----------------------------------------------------------------------
# TESTS
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Chargement de SHUNIT2 pour lancer les TU
#-----------------------------------------------------------------------
SHUNIT2=$(which shunit2)
source "$SHUNIT2"

### /!\ Ne pas mettre d'exit, sinon ça arrête les tests !
