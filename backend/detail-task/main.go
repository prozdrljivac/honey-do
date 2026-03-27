package main

import (
	"context"
	"log"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

var dynamoClient *dynamodb.Client

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("unable to load SDK config: %v", err)
	}
	dynamoClient = dynamodb.NewFromConfig(cfg)
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
	taskId := req.PathParams.Id
	task, err := getTask(ctx, req.User.Id, taskId)
	if err != nil {
		return DetailTaskResponse{Error: "internal error"}, nil
	}
	if task == nil {
		return DetailTaskResponse{Error: "Task does not exist"}, nil
	}

	return DetailTaskResponse{Task: *task}, nil
}

func getTask(ctx context.Context, userId string, id string) (*Task, error) {
	result, err := dynamoClient.GetItem(ctx, &dynamodb.GetItemInput{
		Key: map[string]types.AttributeValue{
			"PK": &types.AttributeValueMemberS{Value: "USER#" + userId},
			"SK": &types.AttributeValueMemberS{Value: "TASK#" + id},
		},
		TableName: aws.String(os.Getenv("TASK_TABLE_NAME")),
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

	return toTask(taskItem), nil
}

func toTask(taskItem TaskItem) *Task {
	return &Task {
		ID: strings.TrimPrefix(taskItem.SK, "TASK#"),
		Name: taskItem.Name,
		Status: taskItem.Status,
		CreatedBy: taskItem.CreatedBy,
		CreatedAt: taskItem.CreatedAt,
	}
}

func main() {
	lambda.Start(handler)
}
