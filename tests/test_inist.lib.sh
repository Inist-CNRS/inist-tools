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
MODULE_DESC="Tests unitaires pour la librairie « std.rc »"
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
}

#-----------------------------------------------------------------------
# TESTS
#-----------------------------------------------------------------------
## IT_GREETING
test_it_std_greeting () {
  out=$(_it_std_greeting)
  assertNotNull "Devrait afficher un message de démarrage de l'application" "$out"
}

## IT_SHOW_VERSION
test_it_std_show_version () {
  out=$(_it_std_show_version)
  assertNotNull "Devrait afficher un message de version de l'application" "$out"
}

## IT_SHOW_HELP
test_it_std_show_help () {
  out=$(_it_std_show_help)
  assertNotNull "Devrait afficher l'aide de l'application" "$out"
}

## IT_CHECK_BINARY
test_it_std_check_command () {
  out=$(_it_std_check_command "ls")
  assertTrue "Devrait retourner TRUE ('ls' est trouvé dans le système)" "$?"
}

## IT_CHECK_CONNECTION
#test_IT_CHECK_CONNECTION () {
  #out=$(IT_CHECK_CONNECTION)
  #assertTrue "Devrait retourner TRUE (connecté à l'INIST)" "$?"
#}

## IT_CHECK_DOCKED
#test_IT_CHECK_DOCKED () {
  #out=$(IT_CHECK_DOCKED)
  #assertTrue "Devrait retourner TRUE (le PéCé est docké)" "$?"
#}

#-----------------------------------------------------------------------
# Chargement de SHUNIT2 pour lancer les TU
#-----------------------------------------------------------------------
SHUNIT2=$(which shunit2)
source "$SHUNIT2"

#############################################################
### /!\ Ne pas mettre d'exit, sinon ça arrête les tests ! ###
#############################################################
