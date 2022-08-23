.PHONY: help
.DEFAULT_GOAL := help

help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-46s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: build test clean
build: ## Build both source and test targets
	swift build --target InfluxDBSwift
	swift build --target InfluxDBSwiftApis
	swift build --build-tests

lint: ## Format code
	swiftlint --fix

check-lint: ## Check that all files are formatted properly
	swiftlint lint --strict

test: ## Run tests
	$(MAKE) build
	swift test

generate-sources: ## Generate Models and APIs from swagger
	docker run --rm -it \
	    -v "${PWD}":/code \
	    -v "${PWD}/Scripts/.m2":/root/.m2 \
	    -w /code \
	    maven:3-openjdk-8 /code/Scripts/generate-sources.sh
	$(MAKE) build

generate-test: ## Generate LinuxMain.swift entries for the package
	swift test --generate-linuxmain

generate-doc: ## Generate documentation
	$(MAKE) build
	sourcekitten doc --spm --module-name InfluxDBSwift > doc_swift.json
	sourcekitten doc --spm --module-name InfluxDBSwiftApis > doc_swift_apis.json
	jazzy --clean --hide-documentation-coverage --sourcekitten-sourcefile doc_swift.json,doc_swift_apis.json --config .jazzy.yml

publish-doc: ## Publish documentation as GH-Pages
	$(MAKE) generate-doc
	docker run --rm -it \
	    -v "${PWD}/docs":/code/docs \
	    -v "${PWD}/Scripts":/code/Scripts \
	    -v "${PWD}/.circleci":/code/.circleci \
	    -v ~/.ssh:/root/.ssh \
	    -v ~/.gitconfig:/root/.gitconfig \
	    -w /code \
	    ubuntu /code/Scripts/publish-site.sh

docker-cli: ## Start and connect into swift:5.3 container
	docker run --rm --privileged --interactive --tty --network influx_network --env INFLUXDB_URL=http://influxdb_v2:8086 -v "${PWD}":/project -w /project -it swift:5.3 /bin/bash

clean: ## Clean builds, generated docs, resolved dependencies, ...
	rm -rf Packages || true
	rm -rf .build || true
	rm -rf build || true
	rm -rf docs || true
	rm -rf doc*.json || true
	rm Package.resolved || true
