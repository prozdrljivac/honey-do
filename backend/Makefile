.PHONY: prep-all build-all clean-all zip-all test-all build clean zip test

LAMBDAS := create-task list-tasks detail-task

# Prep everything for deployment
prep-all: build-all zip-all

build-all:
	@for lambda in $(LAMBDAS); do \
		echo "Building $$lambda..."; \
		$(MAKE) build path=$$lambda || exit 1; \
	done

build:
	@if [ -z "$(path)" ]; then echo "Error: path required"; exit 1; fi
	cd $(path) && GOOS=linux GOARCH=amd64 go build -o bootstrap main.go

clean-all:
	@for lambda in $(LAMBDAS); do \
		echo "Cleaning $$lambda..."; \
		$(MAKE) clean path=$$lambda 2>/dev/null || true; \
	done

clean:
	@if [ -z "$(path)" ]; then echo "Error: path required"; exit 1; fi
	@cd $(path) && rm -f bootstrap lambda.zip

zip-all:
	@for lambda in $(LAMBDAS); do \
		echo "Zipping $$lambda..."; \
		$(MAKE) zip path=$$lambda || exit 1; \
	done

zip:
	@if [ -z "$(path)" ]; then echo "Error: path required"; exit 1; fi
	@if [ ! -f $(path)/bootstrap ]; then echo "Error: bootstrap not found in $(path)"; exit 1; fi
	cd $(path) && zip -q lambda.zip bootstrap

