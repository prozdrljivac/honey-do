package main

import (
	"context"
	"github.com/aws/aws-lambda-go/lambda"
)

type Response struct {
	Body string `json:"body"`
}

func handler(ctx context.Context) (Response, error) {
	// Pull data from the request body
	// At this point we did check if request body is valid via API Gateway
	// If there is a need, do a domain logic check
	// Add the data to the DB
	// Return a response
	return Response{
		Body: `{"message": "Create API, hello from Go!"}`,
	}, nil
}

func main() {
	lambda.Start(handler)
}
