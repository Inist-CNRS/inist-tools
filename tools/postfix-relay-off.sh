#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / postfix-relay-off.sh
# 
# Configure postfix pour ne plus utiliser le relay vers smtpout.intra.inist.fr
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
$SUDO postconf -X "relayhost"
$SUDO /opt/inist-tools/tools/service-restart.sh "postfix" &


# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
