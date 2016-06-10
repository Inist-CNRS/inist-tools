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
# Chargement de la lib à tester
#-----------------------------------------------------------------------
oneTimeSetUp()
{
  source "$DIR_LIBS/inist-proxy.rc" >> /dev/null
}

#-----------------------------------------------------------------------
# TESTS
#-----------------------------------------------------------------------
test_inist_proxy_on () {
  _it_inistProxy "on" >> /dev/null
  out=$(env | grep "8080" | wc -l)
  assertEquals "Les variables d'environnement proxy doivent être positionnées pour le proxy INIST." 6 "$out"
}

test_inist_proxy_off () {
  _it_inistProxy "off" >> /dev/null
  out=$(env | grep "8080" | wc -l)
  assertEquals "Les variables d'environnement proxy doivent être vides." 0 "$out"
}

#-----------------------------------------------------------------------
# Chargement de SHUNIT2 pour lancer les TU
#-----------------------------------------------------------------------
SHUNIT2=$(which shunit2)
source "$SHUNIT2"

#############################################################
### /!\ Ne pas mettre d'exit, sinon ça arrête les tests ! ###
#############################################################

