#!/usr/bin/env bash
########################################################################
#
# INIST-TOOLS / RUN-TESTS
# 
# @author : INIST-CNRS/DPI
#
########################################################################

#-----------------------------------------------------------------------
# Environnement
#-----------------------------------------------------------------------
MODULE_NAME="RUN-TESTS"
MODULE_DESC="Lance tous les Tests Unitaires de INIST-TOOLS"
MODULE_VERSION=$(git describe --tags)
MODULE_VERSION_SHORT=$(git describe --tags | cut -d"-" -f1 )
CURDIR=$( cd "$( dirname "$0" )" && pwd )
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs/")

source "$DIR_LIBS/inist.lib.sh"

#-----------------------------------------------------------------------
# Fonctions
#-----------------------------------------------------------------------
function executeTest {
  testFile="$1"
  printf "### Lance le test \e[1m$testFile\e[0m\n"  
  /usr/bin/time --format "Test executé en %e sec. (%P CPU)" "$testFile"
  wait  $!
  # $testFile
  # return $?
}

#-----------------------------------------------------------------------
# Greeting !
#-----------------------------------------------------------------------
printf "$MODULE_NAME\n"
printf "$MODULE_DESC\n"
printf "\n"

#-----------------------------------------------------------------------
# Vérification de la présence de SHUNIT2
#-----------------------------------------------------------------------
if ! IT_CHECK_COMMAND "shunit2"; then
  IT_MESSAGE "ERROR" "shunit2 n'est pas installé sur votre système. « sudo apt-get install -y shunit2 » devrait régler le problème..."
  exit 1
fi

#-----------------------------------------------------------------------
# Trouve tous les fichiers test_* du répertoire courant et les lance
# un-à-un en calculant leur temps d'execution
#-----------------------------------------------------------------------
find "$CURDIR" -type f -name "test_*" | parallel --gnu --keep-order {}

#-----------------------------------------------------------------------
# Fin propre
#-----------------------------------------------------------------------
exit 0
