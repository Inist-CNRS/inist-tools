#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / postfix-relay-on.sh
# 
# Configure postfix comme relay pour smtpout.intra.inist.fr
#
# /!\ S'execute en ROOT
#
# @author : INIST-CNRS/DPI
#
################################################################################

source "/opt/inist-tools/libs/std.rc"
source "/opt/inist-tools/libs/ansicolors.rc"

# ------------------------------------------------------------------------------
# Variables globales
# ------------------------------------------------------------------------------
# rien pour l'instant...

# ------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------
$SUDO postconf -e "relayhost=smtpout.intra.inist.fr"
$SUDO /opt/inist-tools/tools/service-restart.sh "postfix" &

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
