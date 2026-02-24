# AWS SAM CLI

Serverless Application Model let's us invoke Lambda functions locally using Docker to simulate AWS runtime environment. All lambdas need to be covered by appropreate tests.

## Requirements

[Docker](https://www.docker.com/get-started/)
[SAM](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)

## Steps to create a test for a lambda

1. Each lambda should have it's own dir with tests
2. Each lambda must have a resource definition in `template.yaml`

## Command to test the lambda

```bash
sam local invoke <resource-name> --event <lambda-dir>/<test-name>.json
```
