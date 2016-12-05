#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / proxypac.sh
#
# Installe le service http qui permet de gérer le proxy.pac
#
# @author : INIST-CNRS/DPI
#
################################################################################

# ------------------------------------------------------------------------------
# Ressources
# ------------------------------------------------------------------------------
source "/opt/inist-tools/libs/std.rc"
source "/opt/inist-tools/libs/ansicolors.rc"

#-------------------------------------------------------------------------------
# Environnement
#-------------------------------------------------------------------------------
MODULE_NAME="ProxyPac"
MODULE_DESC="Installe le service http qui permet de gérer le proxy.pac"
CURDIR=$( cd "$( dirname "$0" )" && pwd )
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_ROOT=$(readlink -f "$DIR_MODULE/../")
DIR_CONF=$(readlink -f "$DIR_MODULE/../conf")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs")
DIR_TOOLS=$(readlink -f "$DIR_MODULE/../tools")
DIR_PROXYPAC=$(readlink -f "$DIR_MODULE/../proxypac")
DIR_INSTALL=$(readlink -f "$DIR_MODULE/../install")
DIR_SYSINSTALL="$DIR_INSTALL/opt"
DIR_RELEASES=$(readlink -f "$DIR_MODULE/../releases")


#-------------------------------------------------------------------------------
# Vérifier que lighttpd est installé et l'installer le cas échéant
#-------------------------------------------------------------------------------
LIGHTTPD=$(which lighttpd)
if [ -z "$LIGHTTPD" ]; then
  _it_std_consoleMessage "ACTION" "Installation de lighttpd..."
  apt-get install -y lighttpd
  if [ $? == 0 ]; then
    _it_std_consoleMessage "OK" "lighttpd installé"
  else
    _it_std_consoleMessage "NOK" "impossible d'installer lighttpd. Installation interrompue."
    exit $FALSE
  fi
fi

#-------------------------------------------------------------------------------
# Configuration de lighttpd
#-------------------------------------------------------------------------------
service lighttpd stop
cp /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.bak
cp /opt/inist-tools/conf/lighttpd.conf /etc/lighttpd/
service lighttpd start

# ------------------------------------------------------------------------------
# FIN !
# ------------------------------------------------------------------------------
exit 0
