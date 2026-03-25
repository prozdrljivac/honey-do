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

type UserBody struct {
	Id string `json:"id"`
	Email string `json:"email"`
}

type PathParamsBody struct {
	Id string `json:"id"`
}

type DetailTaskRequest struct {
	User UserBody `json:"user"`
	PathParams PathParamsBody `json:"pathParams"`
}

type DetailTaskResponse struct {
	Task Task `json:"task,omitempty"`
	Error string `json:"error,omitempty"`
}

func handler(ctx context.Context, req DetailTaskRequest) (DetailTaskResponse, error) {
	// Pull id from params
	// Check if there is a task with the id provided in the param, if not return 404
	// Is there a need of mapping from domain to dto obj?
	// Return the response with a correct type
	return DetailTaskResponse {
		Task: Task{
			ID: "test",
			Name: "test",
			Status: "test",
			CreatedBy: "test",
			CreatedAt: "test",
		},
	}, nil
}

func main() {
	lambda.Start(handler)
}
