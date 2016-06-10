SHELL:=/bin/bash

test: ## Lance tous les tests sur inist-tools
	@./tests/run-tests.sh

install: ## Installe inist-tools (non-implémenté)

build: ## Crée le package .deb
	@./tools/prepare-deb.sh
	@./tools/package-deb.sh

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
