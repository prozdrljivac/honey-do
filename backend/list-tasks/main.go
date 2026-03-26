package main

import (
	"context"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

var (
	dynamoClient *dynamodb.Client
	tableName    string
)

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("unable to load SDK config: %v", err)
	}
	dynamoClient = dynamodb.NewFromConfig(cfg)

	tableName = os.Getenv("TASK_TABLE_NAME")
	if tableName == "" {
		log.Fatal("TASK_TABLE_NAME env var is required")
	}
}

type TaskItem struct {
	PK        string `dynamodbav:"PK"`
	SK        string `dynamodbav:"SK"`
	Name      string `dynamodbav:"name"`
	Status    string `dynamodbav:"status"`
	CreatedBy string `dynamodbav:"createdBy"`
	CreatedAt string `dynamodbav:"createdAt"`
}

type Task struct {
	ID        string `json:"taskId"`
	Name      string `json:"name"`
	Status    string `json:"status"`
	CreatedBy string `json:"createdBy"`
	CreatedAt string `json:"createdAt"`
}

type UserBody struct {
	Id    string `json:"id"`
	Email string `json:"email"`
}

type PathParamsBody struct {
	Id string `json:"id"`
}

type DetailTaskRequest struct {
	User       UserBody       `json:"user"`
	PathParams PathParamsBody `json:"pathParams"`
}

type DetailTaskResponse struct {
	Task  *Task  `json:"task,omitempty"`
	Error string `json:"error,omitempty"`
}

func handler(ctx context.Context, req DetailTaskRequest) (DetailTaskResponse, error) {
	if req.PathParams.Id == "" {
		return DetailTaskResponse{Error: "task id is required"}, nil
	}

	task, err := getTask(ctx, req.User.Id, req.PathParams.Id)
	if err != nil {
		return DetailTaskResponse{Error: "internal error"}, nil
	}
	if task == nil {
		return DetailTaskResponse{Error: "task not found"}, nil
	}

	return DetailTaskResponse{Task: task}, nil
}

func getTask(ctx context.Context, userId, taskId string) (*Task, error) {
	result, err := dynamoClient.GetItem(ctx, &dynamodb.GetItemInput{
		Key: map[string]types.AttributeValue{
			"PK": &types.AttributeValueMemberS{Value: "USER#" + userId},
			"SK": &types.AttributeValueMemberS{Value: "TASK#" + taskId},
		},
		TableName: aws.String(tableName),
	})
	if err != nil {
		return nil, err
	}
	if result.Item == nil {
		return nil, nil
	}

	var taskItem TaskItem
	if err := attributevalue.UnmarshalMap(result.Item, &taskItem); err != nil {
		return nil, err
	}

	t := toTask(taskItem)
	return &t, nil
}

func toTask(taskItem TaskItem) Task {
	return Task{
		ID:        taskItem.PK,
		Name:      taskItem.Name,
		Status:    taskItem.Status,
		CreatedBy: taskItem.CreatedBy,
		CreatedAt: taskItem.CreatedAt,
	}
}

func main() {
	lambda.Start(handler)
}
