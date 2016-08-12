#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / prepare-deb.sh
#
# Prépare l'arborescence en vue de créer le .deb pour inist-tools
#
# @author : INIST-CNRS/DPI
#
################################################################################

#-------------------------------------------------------------------------------
# Environnement
#-------------------------------------------------------------------------------
MODULE_NAME="PREPARE-DEB"
MODULE_DESC="Prépare l'arborescence et les fichiers en vue de créer le .deb"
MODULE_VERSION=$(git describe --tags)
MODULE_VERSION_SHORT=$(git describe --tags | cut -d"-" -f1)
MODULE_VERSION_FOR_CONTROL=$(git describe --tags | cut -d"-" -f1 | cut -d "v" -f 2)
CURDIR=$( cd "$( dirname "$0" )" && pwd )
DIR_MODULE=$(readlink -f "$CURDIR")
DIR_ROOT=$(readlink -f "$DIR_MODULE/..")
DIR_CONF=$(readlink -f "$DIR_MODULE/../conf")
DIR_LIBS=$(readlink -f "$DIR_MODULE/../libs")
DIR_TOOLS=$(readlink -f "$DIR_MODULE/../tools")
DIR_INSTALL=$(readlink -f "$DIR_MODULE/../install")
DIR_SYSINSTALL="$DIR_INSTALL/opt"

# ------------------------------------------------------------------------------
# Nettoyage 
# ------------------------------------------------------------------------------
DEB_QUI_TRAINE=$(find "$DIR_ROOT" -type f -name "inist-tools_*.deb")
if [ -f "$DEB_QUI_TRAINE" ]; then
  rm "$DEB_QUI_TRAINE"
fi

if [ -d "$DIR_INSTALL/opt" ]; then
  rm -Rf "$DIR_INSTALL/opt"
fi


# ------------------------------------------------------------------------------
# Création de l'arbo
# ------------------------------------------------------------------------------
mkdir -p "$DIR_INSTALL/opt/inist-tools"

# ------------------------------------------------------------------------------
# Copie des fichiers utiles (et seulements ceux-là)
# ------------------------------------------------------------------------------
cp "$DIR_ROOT/inistrc" "$DIR_SYSINSTALL/inist-tools/"
cp "$DIR_ROOT/README.md" "$DIR_SYSINSTALL/inist-tools/"
cp -R "$DIR_CONF" "$DIR_SYSINSTALL/inist-tools/"
cp -R "$DIR_LIBS" "$DIR_SYSINSTALL/inist-tools/"
cp -R "$DIR_TOOLS" "$DIR_SYSINSTALL/inist-tools/"

# ------------------------------------------------------------------------------
# On écrit la version dans un fichier
# ------------------------------------------------------------------------------
if echo "$MODULE_VERSION_SHORT" >> "$DIR_SYSINSTALL/inist-tools/.version"; then
  chmod 555 "$DIR_SYSINSTALL/inist-tools/.version"
else
  source "../libs/std.rc"
  _it_std_consoleMessage "ERROR" "Impossible de créer le fichier '.version'. Fin."
  exit 1
fi


# ------------------------------------------------------------------------------
# Création du fichier CONTROL
# ------------------------------------------------------------------------------
FILE_CONTROL="$DIR_INSTALL/debian/control"
if [ -f "$FILE_CONTROL" ]; then
  rm "$FILE_CONTROL"
  touch "$FILE_CONTROL"
fi

echo "Package      : inist-tools"                   >> "$FILE_CONTROL"
echo "Version      : $MODULE_VERSION_FOR_CONTROL"   >> "$FILE_CONTROL"
echo "Section      : base"                          >> "$FILE_CONTROL"
echo "Priority     : optional"                      >> "$FILE_CONTROL"
echo "Architecture : all"                           >> "$FILE_CONTROL"
echo "Depends      : bash, make, ntpdate, parallel, jq" >> "$FILE_CONTROL"
echo "Maintainer   : Stanislas PERRIN <stanislas.perrin@inist.fr> / INIST-CNRS/DPI" >> "$FILE_CONTROL"
echo "Description  : Outils de gestion du poste GNU/Linux dans l'environnement INIST. [$MODULE_VERSION] " >> "$FILE_CONTROL"
echo "Homepage     : http://www.inist.fr/"          >> "$FILE_CONTROL"

# ------------------------------------------------------------------------------
# FIN !
# ------------------------------------------------------------------------------
exit 0
