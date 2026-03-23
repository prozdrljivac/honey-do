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
}

type DetailTaskResponse struct {
	Task Task `json:"task,omitempty"`
	Error string `json:"error,omitempty"`
}

func handler(ctx context.Context, req DetailTaskRequest) (Response, error) {
	userId := req.userId
	// From the query pull taskId an get task by it, if no task return 404
	return Response{
		Body: `{"messsage": "Hello from task details and Go!"}`,
	}, nil
}

func main() {
	lambda.Start(handler)
}
