<?php
################################################################################
#
# inist-tools/proxypac/index.php
#
# Génère un fichier proxy.pac en fonction de la situation réseau de la machine
#
# @author : INIST-CNRS/DPI
#
################################################################################

header("Content-type: application/x-ns-proxy-autoconfig");
header('Content-Disposition: inline; filename="proxy.pac"');
header("Cache-Control: no-cache, must-revalidate");
// header("Expires: Sat, 26 Jul 1997 05:00:00 GMT");

exit(0);
?>
