# inist-tools #
Ensemble d'outils permettant de faire fonctionner un poste GNU/Linux (Debian,
Ubuntu) dans l'environnement INIST.

## INSTALLATION ##

Pour l'heure, l'installation n'est pas automatisée.

Pour faire fonctionner la commande « inist » dans l'environnement courant, il
faut configurer les éléments suivants :


### /opt ###

En tant que root, créer un lien symbolique vers le répertoire où a été pullé
inist-tools :

```bash
/opt # ln -s /chemin/vers/le/pull/de/inist-tools .
```

### .bashrc ###
*C'est le seul endroit qui permet de mettre à disposition la commande « inist »
dans les shells interactifs sans login (Konsole, Xterm, Terminator, etc.).*

Dans le .bashrc, ajouter :

```bash
# INIST-TOOLS
. /opt/inist-tools/inistrc
```

### /etc/profile.d/ ###
*Ce répertoire contient les scripts executés au lancement d'un shell interactif
avec login (tty, ssh, etc.).*

En tant que root, créer un fichier executable dans /etc/profile.d/, nommé
« inist-tools.sh » et contenant

```bash
# INIST-TOOLS
. /opt/inist-tools/inistrc
```


----

## Commandes ##

Une fois "sourcé", les commandes suivent le schéma suivant :

```bash
$ inist commande [-option|--option-longue]
$ inist [-option|--option-longue]
```

##### proxy #####
```bash
$ inist proxy [on|off] [--firefox|--iceweasel|--chrome|--chromium]
```
Active/désactive les variables d'environnement qui prennent en charge le proxy
INIST<br>
Avec [--firefox|--iceweasel|--chrome|--chromium], prend en charge la
configuration spécifique des navigateurs.

#### Options ####

```bash
$ inist -h | --help
```
Fournit l'aide des commandes « inist-tools ».

```bash
$ inist -v | --version
```

Renseigne sur la version actuelle de « inist-tools »

---

## DEV ##

*__Note__ : <br> La commande « inist » devient disponible dans la console parce 
que le fichier "inistrc" est sourcé au lancement de celle-ci. Toute modification
du fichier inistrc ou des sous-commande nécessite à nouveau que le fichier
inistrc soit sourcé pour être prise en compte.*

## Construire le package .deb ##

Depuis le répertoire du projet, executer :

```bash
$ sudo make package
```

### Tests Unitaires ###

#### Prérequis ####

Les TU utilisent :

  * shunit2
  * make 

Ces dépendances s'installent via le gestionnaire de paquet Ubuntu/Debian :

```bash
$ apt-get install -y --force-yes shunit2 build-essential
```

#### Lancer les tests ####

Depuis la racine du projet :

```bash
$ make test
```

