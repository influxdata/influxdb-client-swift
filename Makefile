.PHONY: help
.DEFAULT_GOAL := help

help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-46s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: build
build: ## Build both source and test targets
	swift build --build-tests

lint: ## Format code
	swiftlint autocorrect

check-lint: ## Check that all files are formatted properly
	swiftlint lint

test: ## Run tests
	swift build
	swift test --enable-code-coverage 2>&1 | xcpretty --report junit

generate-test: ## Generate LinuxMain.swift entries for the package
	swift test --generate-linuxmain

doc: ## Generate documentation
	swift build
	sourcekitten doc --spm --module-name InfluxDBSwift > doc_swift.json
	sourcekitten doc --spm --module-name InfluxDBSwiftApis > doc_swift_apis.json
	jazzy --clean --sourcekitten-sourcefile doc_swift.json,doc_swift_apis.json --config .jazzy.yml

