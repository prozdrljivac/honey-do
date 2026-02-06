package main

import (
	"context"
	"encoding/json"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Response struct {
	Body string `json:"body"`
}

type Task struct {
	Name string `json:"name"`
	Status string `json:"status"`
	CreatedBy string `json:"createdBy"`
}

func handler(ctx context.Context, request events.APIGatewayProxyRequest) (Response, error) {
	var task Task
	err := json.Unmarshal([]byte(request.Body), &task)

	if err != nil {
		return Response{
			Body: `{"error": "Invalid request"}`,
		}, nil	
	}
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
