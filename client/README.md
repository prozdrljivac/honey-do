# Client - Honey-Do Frontend

Frontend application for the Honey-Do task management system, built with React and TypeScript.

## Overview

The client is a modern single-page application (SPA) built using React 19, TypeScript, and Vite. It provides the user interface for task management, authentication, and other core functionality of the Honey-Do application.

## Prerequisites

Before setting up the frontend, ensure you have the following installed:

- **Node.js 18+**: JavaScript runtime
- **pnpm**: Fast, disk space efficient package manager ([installation guide](https://pnpm.io/installation))

## Setup

1. **Navigate to the client directory**:

   ```bash
   cd client
   ```

2. **Install dependencies**:

   ```bash
   pnpm install
   ```

   This will install all required dependencies from `package.json`.

## Development

### Running the Development Server

To start the development server with hot module replacement:

```bash
pnpm dev
```

The application will be available at `http://localhost:5173` (default Vite port).

### Building for Production

To build the application for production:

```bash
pnpm build
```

This command:

1. Runs TypeScript compiler (`tsc -b`) to check for type errors
2. Builds optimized production bundle with Vite
3. Outputs files to the `dist/` directory

### Preview Production Build

To preview the production build locally:

```bash
pnpm preview
```

### Code Quality

This project uses ESLint and Prettier for code quality and formatting.

**Check for linting issues**:

```bash
pnpm lint
```

**Format code with Prettier**:

```bash
pnpm exec prettier --write .
```

## Project Structure

```markdown
client/
├── src/
│   ├── pages/              # Route pages (Home, SignIn, SignUp)
│   ├── components/         # React components
│   ├── assets/            # Static assets (images, styles)
│   ├── App.tsx            # Main app component with routing
│   └── main.tsx           # Application entry point
├── dist/                  # Built files (generated)
├── public/                # Public static assets
├── package.json           # Dependencies and scripts
├── tsconfig.app.json      # TypeScript configuration
├── vite.config.ts         # Vite configuration
├── eslint.config.js       # ESLint configuration
└── README.md              # This file
```

## Technology Stack

- **React 19.2.0** - UI framework
- **TypeScript 5.9.3** - Type safety and better DX
- **Vite 7.2.4** - Build tool and dev server
- **React Router 7.9.6** - Client-side routing
- **Tailwind CSS 4.1.17** - Utility-first CSS framework
- **ESLint & Prettier** - Code quality and formatting

## Current Pages

- **Home** (`/`) - Landing page
- **Sign In** (`/sign-in`) - User login (UI only, auth pending)
- **Sign Up** (`/sign-up`) - User registration (UI only, auth pending)

## Environment Variables

Environment variables can be configured using `.env` files. Vite exposes variables prefixed with `VITE_`:

```bash
# .env.local
VITE_API_URL=https://your-api-gateway-url.amazonaws.com
```

Access in code:

```typescript
const apiUrl = import.meta.env.VITE_API_URL
```

## Deployment

The frontend is deployed as a static website on AWS S3. The infrastructure is managed by Terraform.

To deploy:

1. Build the production bundle:

   ```bash
   pnpm build
   ```

2. Deploy using Terraform (from the `/infrastructure` directory):

   ```bash
   cd ../infrastructure/environments/dev
   terraform apply
   ```

See [infrastructure/README.md](../infrastructure/README.md) for detailed deployment instructions.

## Adding Dependencies

To add a new dependency:

```bash
pnpm add <package-name>
```

To add a development dependency:

```bash
pnpm add -D <package-name>
```

## Path Aliases

The project uses TypeScript path aliases for cleaner imports:

```typescript
import { Component } from '@/components/Component'
import { helper } from '@/utils/helper'
```

Configuration is in `tsconfig.app.json` and `vite.config.ts`.
