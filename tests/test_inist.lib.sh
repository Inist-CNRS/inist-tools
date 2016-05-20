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

source "$DIR_LIBS/inist.lib.sh"

#-----------------------------------------------------------------------
# Greeting !
#-----------------------------------------------------------------------
printf "$MODULE_NAME\n"
printf "$MODULE_DESC\n"
printf "\n"

#-----------------------------------------------------------------------
# Chargement de la lib à tester
#-----------------------------------------------------------------------
oneTimeSetUp()
{
  source "$DIR_LIBS/inist.lib.sh" >> /dev/null
}

#-----------------------------------------------------------------------
# TESTS
#-----------------------------------------------------------------------
## IT_GREETING
test_IT_GREETING () {
  out=$(IT_GREETING)
  assertNotNull "Devrait afficher un message de démarrage de l'application" "$out"
}

## IT_SHOW_VERSION
test_IT_SHOW_VERSION () {
  out=$(IT_SHOW_VERSION)
  assertNotNull "Devrait afficher un message de version de l'application" "$out"
}

## IT_SHOW_HELP
test_IT_SHOW_HELP () {
  out=$(IT_SHOW_HELP)
  assertNotNull "Devrait afficher l'aide de l'application" "$out"
}

## IT_CHECK_BINARY
test_IT_CHECK_BINARY () {
  out=$(IT_CHECK_BINARY "ls")
  assertTrue "Devrait retourner TRUE ('ls' est trouvé dans le système)" "$?"
}

## IT_CHECK_CONNECTION
test_IT_CHECK_CONNECTION () {
  out=$(IT_CHECK_CONNECTION)
  assertTrue "Devrait retourner TRUE (connecté à l'INIST)" "$?"
}

## IT_CHECK_DOCKED
test_IT_CHECK_DOCKED () {
  out=$(IT_CHECK_DOCKED)
  assertTrue "Devrait retourner TRUE (le PéCé est docké)" "$?"
}

#-----------------------------------------------------------------------
# Chargement de SHUNIT2 pour lancer les TU
#-----------------------------------------------------------------------
time source "$DIR_LIBS/shunit2/source/2.1/src/shunit2"

#-----------------------------------------------------------------------
# Fin propre
#-----------------------------------------------------------------------
exit 0
