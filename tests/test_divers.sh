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
  source "$DIR_LIBS/ansicolors.rc" >> /dev/null
  source "$DIR_LIBS/misc.rc" >> /dev/null
  echo "Contenu du fichier à backuper puis restaurer" > "/run/shm/inist-tools-backup-test"
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
# TESTS BACKUP / RESTORE
#-----------------------------------------------------------------------
test_file_backup () {
  _it_std_backup "/run/shm/inist-tools-backup-test"
  out=$(ls -l "/run/shm/inist-tools-backup-test_itb" | wc -l)
  assertEquals "On doit trouver un fichier de backup." 1 "$out"
}

test_file_restore () {
  _it_std_restore "/run/shm/"
  out1=$(find "/run/shm/" -type f -name "inist-tools-backup-test_itb" | wc -l)
  out2=$(find "/run/shm/" -type f -name "inist-tools-backup-test" | wc -l)
  assertEquals "Le fichier de backup doit avoir été supprimé" 0 "$out1"
  assertEquals "Le fichier original doit avoir été restauré" 1 "$out2"
}


#-----------------------------------------------------------------------
# Chargement et lancement de SHUNIT2 pour executer les TU
#-----------------------------------------------------------------------
SHUNIT2=$(which shunit2)
source "$SHUNIT2"


#############################################################
### /!\ Ne pas mettre d'exit, sinon ça arrête les tests ! ###
#############################################################

