SHELL:=/bin/bash

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

test: ## Lance tous les tests sur inist-tools
	@./tests/run-tests.sh

install: ## Installe inist-tools (non-implémenté)

build: ## Crée le package .deb
	@./tools/prepare-deb.sh
	@./tools/build-deb.sh

release: ## Build le .deb et le publie sur GitHub
	@./tools/clean-deb.sh
	@./tools/prepare-deb.sh
	@./tools/build-deb.sh
	@./tools/publish-deb.sh

clean: ## Nettoie les scories après la création du package
	@./tools/clean-deb.sh

.PHONY: help

