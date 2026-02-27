package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/google/uuid"
)

var dynamoClient *dynamodb.Client

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("unable to load SDK config: %v", err)
	}
	dynamoClient = dynamodb.NewFromConfig(cfg)
}

type CreateTaskRequest struct {
	Name      string `json:"name"`
	Status    string `json:"status"`
	CreatedBy string `json:"createdBy"`
}

type CreateTaskResponse struct {
	Message string `json:"message,omitempty"`
	TaskID  string `json:"taskId,omitempty"`
	Error   string `json:"error,omitempty"`
}

func handler(ctx context.Context, req CreateTaskRequest) (CreateTaskResponse, error) {
	if err := validateRequest(req); err != nil {
		return CreateTaskResponse{Error: err.Error()}, nil
	}

	// TODO: Replace with Cognito sub
	userID := uuid.New().String()
	taskID := uuid.New().String()

	if err := createTask(ctx, userID, taskID, req); err != nil {
		log.Printf("failed to create task: %v", err)
		return CreateTaskResponse{Error: "Failed to create task"}, nil
	}

	return CreateTaskResponse{
		Message: "Task created successfully",
		TaskID:  taskID,
	}, nil
}

func validateRequest(req CreateTaskRequest) error {
	if req.Name == "" {
		return fmt.Errorf("name is required")
	}
	if req.Status == "" {
		return fmt.Errorf("status is required")
	}
	if req.CreatedBy == "" {
		return fmt.Errorf("createdBy is required")
	}
	return nil
}

func createTask(ctx context.Context, userID, taskID string, req CreateTaskRequest) error {
	_, err := dynamoClient.PutItem(ctx, &dynamodb.PutItemInput{
		TableName: aws.String("honey-do-dev-table"), // I need to figure out how this is dynamically pulled
		Item: map[string]types.AttributeValue{
			"PK":        &types.AttributeValueMemberS{Value: "USER#" + userID},
			"SK":        &types.AttributeValueMemberS{Value: "TASK#" + taskID},
			"name":      &types.AttributeValueMemberS{Value: req.Name},
			"status":    &types.AttributeValueMemberS{Value: req.Status},
			"createdBy": &types.AttributeValueMemberS{Value: req.CreatedBy},
			"createdAt": &types.AttributeValueMemberS{Value: time.Now().UTC().Format(time.RFC3339)},
		},
	})
	return err
}

func main() {
	lambda.Start(handler)
}
