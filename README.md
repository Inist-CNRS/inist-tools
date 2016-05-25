# inist-tools #
Ensemble d'outils permettant de faire fonctionner un poste GNU/Linux (Debian,
Ubuntu) dans l'environnement INIST.

## INSTALLATION ##

Pour l'heure, l'installation n'est pas automatisée.

Pour que la commande « inist » puisse agir sur l'environnement courant de
l'utilisateur, le fichier inist-proxy.rc doit "sourcé" directement
depuis ~/.bashrc

Ajouter dans .bashrc

### /opt ###

En tant que root, créer un lien symbolique vers le répertoire où a été pullé
inist-tools :

```bash
/opt # ln -s /chemin/vers/le/pull/de/inist-tools .
```


### .bashrc ###

```bash
# INIST-TOOLS
. /opt/inist-tools/libs/inist-proxy.rc
```

### /etc/profile.d/ ###

En tant que root, créer un fichier executable dans /etc/profile.d/, nommé
« inist-tools.sh » et contenant

```bash
export PATH="$PATH:/opt/inist-tools"
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
$ apt-get install -y shunit2 build-essential
```

#### Lancer les tests ####

Depuis la racine du projet :

```bash
$ make test
```

