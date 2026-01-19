build-all-lambdas:
	@for lambda in $$(ls -d */); do \
		lambda=$${lambda%/}; \
		echo "Building $$lambda"; \
		make build-lambda path=$$lambda; \
	done


build-lambda:
	cd $(path) && \
	GOOS=linux GOARCH=amd64 go build -o bootstrap main.go && \
	zip lambda.zip bootstrap && \
	rm bootstrap
