# inist-tools #
Ensemble d'outils permettant de faire fonctionner un poste GNU/Linux (Debian, Ubuntu) dans l'environnement INIST.

## DEV ##
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

