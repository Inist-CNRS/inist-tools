#!/usr/bin/env bash
########################################################################
#
# INIST-TOOLS / T.U. pour inist.lib.sh
# 
# @author : INIST-CNRS/DPI
#
########################################################################

#-----------------------------------------------------------------------
# Environnement
#-----------------------------------------------------------------------
MODULE_NAME="T.U. INIST LIB"
MODULE_DESC="Tests unitaires pour la librairie « inist.lib.sh »"
MODULE_VERSION=$(git describe --tags)
MODULE_VERSION_SHORT=$(git describe --tags | cut -d"-" -f1 )
CURDIR=$( cd "$( dirname "$0" )" && pwd )
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs/")

#-----------------------------------------------------------------------
# Chargement de SHUNIT2
#-----------------------------------------------------------------------
source $DIR_LIBS/shunit2/source/2.1/bin/shunit2

