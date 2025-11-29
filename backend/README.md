# Backend - Honey-Do Server

Backend API for the Honey-Do task management application, built with AWS Lambda functions and Python.

## Overview

The backend is a serverless API built using AWS Lambda functions. It provides endpoints for task management, user authentication, and other core functionality of the Honey-Do application.

## Prerequisites

Before setting up the backend, ensure you have the following installed:

- **Python 3.13+**: The project requires Python 3.13 or higher
- **uv**: Fast Python package manager and project manager ([installation guide](https://docs.astral.sh/uv/getting-started/installation/))

## Setup

1. **Navigate to the backend directory**:

   ```bash
   cd backend
   ```

2. **Install dependencies**:

   ```bash
   uv sync
   ```

   This will create a virtual environment and install all required dependencies from `pyproject.toml`.

## Development

### Running Locally

To run the backend locally:

```bash
uv run python main.py
```

### Running Tests

Run the test suite using pytest:

```bash
uv run pytest
```

Run tests with coverage:

```bash
uv run pytest --cov
```

### Code Quality

This project uses [Ruff](https://docs.astral.sh/ruff/) for linting and formatting.

**Check for linting issues**:

```bash
uv run ruff check
```

**Auto-fix linting issues**:

```bash
uv run ruff check --fix
```

**Format code**:

```bash
uv run ruff format
```

## Project Structure

```markdown
backend/
├── src/
│   └── tasks/
│       └── list.py          # Lambda handler for listing tasks
├── tests/
│   └── tasks/
│       └── test_list.py     # Tests for task listing
├── main.py                  # Entry point for local development
├── pyproject.toml           # Project configuration and dependencies
├── uv.lock                  # Locked dependencies
└── README.md                # This file
```

## Lambda Functions

The backend consists of the following Lambda functions:

### Task Management

- **`src/tasks/list.py`**: Returns a list of tasks
  - Handler: `list(event, context)`
  - Returns: JSON array of task objects
  - Response includes CORS headers for cross-origin requests

## Adding Dependencies

To add a new dependency:

```bash
uv add <package-name>
```

To add a development dependency:

```bash
uv add --dev <package-name>
```

## Deployment

Lambda functions are deployed to AWS using Terraform. See the `/terraform` directory for infrastructure configuration and deployment instructions.
