build-lambda:
	cd $(path) && \
	GOOS=linux GOARCH=amd64 go build -o bootstrap main.go && \
	zip lambda.zip bootstrap && \
	rm bootstrap
