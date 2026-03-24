package main

import (
	"context"
	"github.com/aws/aws-lambda-go/lambda"
)

type Task struct {
	ID        string `json:"taskId"`
	Name      string `json:"name"`
	Status    string `json:"status"`
	CreatedBy string `json:"createdBy"`
	CreatedAt string `json:"createdAt"`
}

type DetailTaskRequest struct {
	UserId string `json:userId`
	Email string `json:email`
	PathParams map[string]string `json:pathParams`
}

type DetailTaskResponse struct {
	Task Task `json:"task,omitempty"`
	Error string `json:"error,omitempty"`
}

func handler(ctx context.Context, req DetailTaskRequest) (Response, error) {
	params := req.PathParams
	// Check if there is a task with the id provided in the param, if not return 404
	// Is there a need of mapping from domain to dto obj?
	// Return the response with a correct type
	return Response{
		Body: `{"messsage": "Hello from task details and Go with path params!"}`,
	}, nil
}

func main() {
	lambda.Start(handler)
}
