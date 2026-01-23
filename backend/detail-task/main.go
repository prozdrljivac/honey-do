package main

import (
	"context"
	"github.com/aws/aws-lambda-go/lambda"
)

type Response struct {
	Body string `json:"body"`
}

func handler(ctx context.Context) (Response, error) {
	return Response{
		Body: `{"messsage": "Hello from task details and Go!"}`,
	}, nil
}

func main() {
	lambda.Start(handler)
}
