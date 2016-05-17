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
# Logging
# $1 : level/priorité (NOTICE, WARNING, ERROR, etc.)
# $2 : contenu du message ou de l'erreur
#-----------------------------------------------------------------------
function IT_MESSAGE {
  MESSAGE="[INIST-TOOLS] [$1] $2"
  # echo "$MESSAGE"
  logger -s -p "$1" "$MESSAGE"
}

#-----------------------------------------------------------------------
# Message d'accueil
#-----------------------------------------------------------------------
function IT_GREETING {
  cat "$DIR_LIBS/cnrs.ansi"
  echo "$MODULE_NAME [$MODULE_VERSION]"
}

#-----------------------------------------------------------------------
# Affichage de la version
#-----------------------------------------------------------------------
function IT_SHOW_VERSION {
  echo "$MODULE_NAME est en version $MODULE_VERSION"
}

#-----------------------------------------------------------------------
# Affichage de l'aide
#-----------------------------------------------------------------------
function IT_SHOW_HELP {
  echo "Options : "
  echo -e "\t-p,--proxy\t\tPositionne le proxy INIST pour la session en cours"
  echo -e "\t-v,--version\t\tAffiche la version"
}

#-----------------------------------------------------------------------
# Vérification de l'existance d'un binaire
# (retourne 0 si trouvé, 1 si non trouvé)
#-----------------------------------------------------------------------
function IT_CHECK_BINARY {
  if [ ! -z "$1" ]; then
    CHECK=$(which "$1")
    return $?
  fi
  # Argument $1 vide => ERREUR
  return 1
}

#-----------------------------------------------------------------------
# Vérification de la connectivite internet
# 0 -> connexion filaire INIST
# 1 -> connexion autre
#-----------------------------------------------------------------------
function IT_CHECK_CONNECTION {
  IS_INIST=$(ifconfig | grep -i "172.16")
  if [ "$IS_INIST" ]; then
    return 0
  else
    return 1
  fi
}

