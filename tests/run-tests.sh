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
  printf "### Lance le test $testFile\n"  
  /usr/bin/time --format "Test executé en %e sec." "$testFile"
}


#-----------------------------------------------------------------------
# Greeting !
#-----------------------------------------------------------------------
printf "$MODULE_NAME\n"
printf "$MODULE_DESC\n"
printf "\n"

#-----------------------------------------------------------------------
# Trouve tous les fichiers test_* du répertoire courant et les lance
# un-à-un en calculant leur temps d'execution
#-----------------------------------------------------------------------

for tFile in "$CURDIR/test_*"; do
  executeTest $tFile
done

