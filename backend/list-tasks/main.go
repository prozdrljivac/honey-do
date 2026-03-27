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

type ListTasksRequest struct {
	User UserBody `json:"user"`
}

type ListTasksResponse struct {
	Tasks []Task `json:"tasks,omitempty"`
	Error string `json:"error,omitempty"`
}

func handler(ctx context.Context, req ListTasksRequest) (ListTasksResponse, error) {
	tasks, err := getTasks(ctx, req.User.Id)
	if err != nil {
		return ListTasksResponse{Error: "internal error"}, nil
	}

	return ListTasksResponse{Tasks: tasks}, nil
}

func getTasks(ctx context.Context, userId string) ([]Task, error) {
	result, err := dynamoClient.Query(ctx, &dynamodb.QueryInput{
		TableName:              aws.String(tableName),
		KeyConditionExpression: aws.String("PK = :pk AND begins_with(SK, :sk)"),
		ExpressionAttributeValues: map[string]types.AttributeValue{
			":pk": &types.AttributeValueMemberS{Value: "USER#" + userId},
			":sk": &types.AttributeValueMemberS{Value: "TASK#"},
		},
	})
	if err != nil {
		return nil, err
	}

	var tasks []Task
	for _, item := range result.Items {
		var taskItem TaskItem
		if err := attributevalue.UnmarshalMap(item, &taskItem); err != nil {
			return nil, err
		}
		tasks = append(tasks, toTask(taskItem))
	}

	return tasks, nil
}

func toTask(taskItem TaskItem) Task {
	return Task{
		ID:        strings.TrimPrefix(taskItem.SK, "TASK#"),
		Name:      taskItem.Name,
		Status:    taskItem.Status,
		CreatedBy: taskItem.CreatedBy,
		CreatedAt: taskItem.CreatedAt,
	}
}

func main() {
	lambda.Start(handler)
}
