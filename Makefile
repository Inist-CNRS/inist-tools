SHELL:=/bin/bash

# Lance le fichier de test qui execute tous les TU
test:
	./tests/run-tests.sh

install:

package:
	./tools/prepare-deb.sh
	./tools/package-deb.sh
