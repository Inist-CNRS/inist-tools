#!/usr/bin/env bash
########################################################################
#
# INIST-TOOLS / INIST LIB
# 
# Bibliothèque de fonctions standards utilisées par le lanceur ou les
# outils « INIST-TOOLS ».
#
# @author : INIST-CNRS/DPI
#
########################################################################

#-----------------------------------------------------------------------
# Initialisation de variables globales
#-----------------------------------------------------------------------
IS_INIST=1
IS_DOCKED=1

#-----------------------------------------------------------------------
# Logging
# $1 : level/priorité (NOTICE, WARNING, ERROR, etc.)
# $2 : contenu du message ou de l'erreur
#-----------------------------------------------------------------------
function _it_std_message {
  MESSAGE="[INIST-TOOLS] [$1] $2"
  
  case "$1" in
  
    # INFORMATION
    info|INFO)
      logger -s -p "$1" "$MESSAGE"
      notify-send -i info "$MESSAGE"
    ;;
    
    # ALERTE !
    warning|WARNING)
      logger -s -p "$1" "$MESSAGE"
      notify-send -i warning "$MESSAGE"
    ;;
    
    # ERREUR !
    error|ERROR)
      logger -s -p "$1" "$MESSAGE"
      notify-send -i error "$MESSAGE"
    ;;
    
    # Autre cas
    *)
      logger -s -p "$1" "$MESSAGE"
      notify-send -i "$MESSAGE"
    ;;
    
  esac
}

#-----------------------------------------------------------------------
# Message d'accueil (générique, réutilisable)
#-----------------------------------------------------------------------
function _it_std_greeting {
  # printf "${FG_BR_BLUE}$MODULE_NAME [${FG_BR_WHITE}$MODULE_VERSION]${RESET_ALL}\n"
  if printf "$MODULE_NAME [$MODULE_VERSION_SHORT]\n" && printf "$MODULE_DESC\n" ; then
    return 0
  fi
}

#-----------------------------------------------------------------------
# Affichage de la version
#-----------------------------------------------------------------------
function _it_std_show_version {
  printf "$MODULE_NAME est en version $MODULE_VERSION\n"
}

#-----------------------------------------------------------------------
# Affichage de l'aide
#-----------------------------------------------------------------------
function _it_std_show_help {
  cat $DIR_LIBS/inist-tools-help.txt
}

#-----------------------------------------------------------------------
# Vérification de l'existance d'un binaire
# (retourne 0 si trouvé, 1 si non trouvé)
#-----------------------------------------------------------------------
function _it_std_check_command {
  if [ ! -z "$1" ]; then
    CHECK=$(which "$1")
    return $?
  fi
  # Argument $1 vide => ERREUR
  return 1
}

#-----------------------------------------------------------------------
# Vérification du dockage du portable...
# ...en comptant les hub USB dispo
# ...en comptant les écrans connectés
# /!\ Pss fiable à 100% (et il faut que xrandr soit installé)
#-----------------------------------------------------------------------
#function _it_std_check_docked {
  #USBHUBS_COUNT=$(lsusb | grep "hub" | wc -l)
  #DISPLAY_COUNT=$(xrandr | grep " connected" | wc -l)
  #if [ $USBHUBS_COUNT -eq 4 ] && [ $DISPLAY_COUNT -gt 1 ]; then
    #IS_DOCKED=0
    #return 0
  #else
    #IS_DOCKED=1
    #return 1
  #fi
#}
