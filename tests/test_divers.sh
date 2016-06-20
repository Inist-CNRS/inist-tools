#!/usr/bin/env bash
########################################################################
#
# INIST-TOOLS / T.U. Divers (inclassables)
# 
# @author : INIST-CNRS/DPI
#
########################################################################

#-----------------------------------------------------------------------
# Environnement
#-----------------------------------------------------------------------
MODULE_NAME="T.U. Divers"
MODULE_DESC="Tests unitaires sur les fonctionnalités inclassables :)"
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
  source "$DIR_LIBS/std.rc" >> /dev/null
  source "$DIR_LIBS/misc.rc" >> /dev/null
}

#-----------------------------------------------------------------------
# TESTS NPM
#-----------------------------------------------------------------------
test_npm_proxyOff () {
  _it_misc_npm_proxy "off" >> /dev/null
  out=$(npm config ls -l | grep -i "proxy" | grep -i "null" | wc -l)
  assertEquals "Les variables d'environnement proxy pour npm doivent être positionnées à null (on doit trouver 2 x 'null' dedans)." 2 "$out"
}

test_npm_proxyOn () {
  _it_misc_npm_proxy "on" >> /dev/null
  out=$(npm config ls -l | grep -i "proxy" | grep "8080" | wc -l)
  assertEquals "Les variables d'environnement proxy pour npm doivent être positionnées (on doit trouver 2 x '8080' dedans)." 2 "$out"
}

#-----------------------------------------------------------------------
# Chargement et lancement de SHUNIT2 pour executer les TU
#-----------------------------------------------------------------------
SHUNIT2=$(which shunit2)
source "$SHUNIT2"


#############################################################
### /!\ Ne pas mettre d'exit, sinon ça arrête les tests ! ###
#############################################################

