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

type ListTasksRequest struct {
	UserId string   `json:"userId"`
	Email  string   `json:"email"`
}

type ListTasksResponse struct {
	Tasks []Task `json:"tasks,omitempty"`
	Error string `json:"error,omitempty"`
}

func handler(ctx context.Context, req ListTasksRequest) (ListTasksResponse, error) {
	userID := req.UserId

	tasks, err := getTasksForUser(ctx, userID)
	if err != nil {
		log.Printf("failed to list tasks: %v", err)
		return ListTasksResponse{Error: "Failed to list tasks"}, nil
	}

	return ListTasksResponse{Tasks: tasks}, nil
}

func getTasksForUser(ctx context.Context, userID string) ([]Task, error) {
	result, err := dynamoClient.Query(ctx, &dynamodb.QueryInput{
		TableName:              aws.String(os.Getenv("TASK_TABLE_NAME")),
		KeyConditionExpression: aws.String("PK = :pk AND begins_with(SK, :sk)"),
		ExpressionAttributeValues: map[string]types.AttributeValue{
			":pk": &types.AttributeValueMemberS{Value: "USER#" + userID},
			":sk": &types.AttributeValueMemberS{Value: "TASK#"},
		},
	})
	if err != nil {
		return nil, err
	}

	var items []TaskItem
	if err := attributevalue.UnmarshalListOfMaps(result.Items, &items); err != nil {
		return nil, err
	}

	return toTasks(items), nil
}

func toTasks(items []TaskItem) []Task {
	tasks := make([]Task, len(items))
	for i, item := range items {
		tasks[i] = Task{
			ID:        extractTaskID(item.SK),
			Name:      item.Name,
			Status:    item.Status,
			CreatedBy: item.CreatedBy,
			CreatedAt: item.CreatedAt,
		}
	}
	return tasks
}

func extractTaskID(sk string) string {
	// SK format: "TASK#<id>"
	if len(sk) > 5 {
		return sk[5:]
	}
	return sk
}

func main() {
	lambda.Start(handler)
}
