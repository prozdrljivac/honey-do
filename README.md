# Honey-Do

A serverless task management application built with AWS services and Infrastructure as Code (Terraform).

## Overview

Honey-Do is a simple yet practical task management application designed for couples to create and manage tasks for each other. The project serves as a hands-on learning platform for practicing AWS serverless services and Infrastructure as Code with Terraform.

## Project Purpose

This project was created as a practical learning experience for:

1. **AWS Serverless Services**: Hands-on practice with AWS Lambda, API Gateway, DynamoDB, Cognito, and other serverless offerings
2. **Infrastructure as Code**: Building reusable Terraform modules and multi-environment infrastructure
3. **Full-Stack Development**: Building a complete application from frontend to backend to infrastructure

## Architecture

The application uses a modern serverless architecture:

```markdown
User Browser → S3 (Static Website) → API Gateway → Lambda Functions → DynamoDB (planned)
                                                          ↓
                                                   CloudWatch Logs
```

**Current AWS Services:**

- **S3**: Static website hosting for the React frontend
- **API Gateway**: REST API endpoints with CORS support
- **Lambda**: Serverless compute for backend logic
- **CloudWatch**: Centralized logging and monitoring
- **IAM**: Fine-grained access control

**Planned Services:**

- **DynamoDB**: NoSQL database for task persistence
- **Cognito**: User authentication and authorization

## Features

### Currently Implemented

- Static website hosting on S3
- REST API with API Gateway integration
- Lambda function for listing tasks
- Modular Terraform infrastructure
- Multi-environment support (dev/stg/prod)
- CORS-enabled API endpoints

### Planned Features

- User authentication with AWS Cognito
- Task persistence with DynamoDB
- Full CRUD operations for tasks
- Real-time updates
- Task assignment and notifications

## Project Structure

```markdown
honey-do/
├── client/              # React frontend application
│   ├── src/            # Source code (pages, components, assets)
│   └── dist/           # Built files for deployment
├── backend/            # Python Lambda functions
│   ├── src/           # Lambda handlers
│   └── tests/         # Unit tests
├── infrastructure/     # Terraform configuration
│   ├── modules/       # Reusable Terraform modules
│   │   ├── s3-static-website/
│   │   └── api-gateway-lambda/
│   └── environments/  # Environment-specific configs (dev, stg, prod)
└── README.md          # This file
```

## Getting Started

Each component has detailed setup instructions in its respective README:

### Frontend Setup

See [client/README.md](./client/README.md) for instructions on:

### Backend Setup

See [backend/README.md](./backend/README.md) for instructions on:

### Infrastructure Deployment

See [infrastructure/README.md](./infrastructure/README.md) for instructions on:

## License

This project is open source and available for learning purposes.
