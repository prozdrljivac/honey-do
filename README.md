# Honey-Do

A serverless task management application built with AWS services and Infrastructure as Code (Terraform).

## Overview

Honey-Do is a simple yet practical task management application designed for couples (like husbands and wives) to create and manage tasks for each other. The project serves as a hands-on learning platform for practicing AWS serverless services and Infrastructure as Code with Terraform.

## Features

- **User Authentication**: Register, login, and logout functionality
- **Task Management**: Create, view, and manage tasks for each other
- **Serverless Architecture**: Built entirely on AWS serverless services
- **Infrastructure as Code**: Complete Terraform configuration for easy deployment

## Project Purpose

This project was created as a practical learning experience for:

1. **AWS Serverless Services**: Hands-on practice with AWS Lambda, API Gateway, DynamoDB, Cognito, and other serverless offerings
2. **Infrastructure as Code**: Converting a manually deployed AWS application to Terraform-managed infrastructure
3. **Full-Stack Development**: Building a complete application from frontend to backend to infrastructure

The application has been successfully deployed on AWS manually, and is now being converted to Terraform to enable anyone to deploy their own instance with minimal effort.

## Architecture

The application uses a serverless architecture consisting of:

- **Frontend**: React + TypeScript + Vite (located in `/client`)
- **Backend**: AWS Lambda functions (coming soon)
- **Database**: AWS DynamoDB
- **Authentication**: AWS Cognito
- **API**: AWS API Gateway
- **Infrastructure**: Terraform for IaC

## Project Structure

```markdown
honey-do/
├── client/          # React frontend application
├── terraform/       # Infrastructure as Code (coming soon)
└── README.md        # This file
```

## Getting Started

This project consists of multiple components, each with its own setup instructions:

### Frontend Application

The React frontend application is located in the `/client` directory.

For detailed setup instructions, see [client/README.md](./client/README.md)

### Infrastructure Deployment (Coming Soon)

The Terraform infrastructure configuration will be located in the `/terraform` directory.

For detailed deployment instructions, see `terraform/README.md` (coming soon)

### Backend Services (Coming Soon)

AWS Lambda functions and backend services documentation will be added as the Terraform migration progresses.

For backend setup instructions, see `backend/README.md` (coming soon)

## License

This project is open source and available for learning purposes.
