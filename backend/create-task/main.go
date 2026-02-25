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
			Body: `{"error": "There was an issue with handling your request."}`,
		}, nil	
	}

	if task.Name == "" || task.Status == "" || task.CreatedBy == "" {
		return Response{
			Body: `{"error": "There was an issue with handling your data. Make sure name, status and createdBy are not empty."}`,
		}, nil	
	}

	// Add the data to the DB
	// Check how to install aws dynamo db sdk https://github.com/aws/aws-sdk-go-v2
	
	// Return a response
	return Response{
		Body: `{"message": "Create API, hello from Go!"}`,
	}, nil
}

func main() {
	lambda.Start(handler)
}
