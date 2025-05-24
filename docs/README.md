# Visitor Book Project Documentation

## Overview

Visitor Book is a modern web application designed to manage visitor records and enhance security in buildings and facilities. This documentation provides comprehensive information about the project's architecture, deployment, and API.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Technology Stack](#technology-stack)
4. [Getting Started](#getting-started)
5. [Documentation Structure](#documentation-structure)

## Project Overview

Visitor Book is a full-stack application that helps organizations:

- Track and manage visitor entries
- Enhance building security
- Maintain digital visitor logs
- Generate visitor reports
- Manage visitor notifications

## Architecture

The project follows a modern microservices architecture with the following components:

```
                    Client (Browser)
                           │
                           ▼
                    Load Balancer
                           │
         ┌──────────────┴──────────────┐
         ▼                             ▼
    Frontend (Next.js)           Backend (Node.js)
         │                             │
         └──────────────┬──────────────┘
                        ▼
                    Database (PostgreSQL)
```

### Key Components:

1. **Frontend** (`visitor-book-frontend/`)

   - Next.js with TypeScript
   - Tailwind CSS for styling
   - Radix UI components
   - shadcn for UI components

2. **Backend** (`visitor-book-backend/`)

   - Node.js with Express
   - TypeScript
   - PostgreSQL database
   - RESTful API

3. **Infrastructure** (`terraform/`)
   - AWS cloud infrastructure
   - Terraform for IaC
   - VPC, EC2, RDS setup

## Technology Stack

### Frontend

- Next.js 14
- TypeScript
- Tailwind CSS
- Radix UI
- shadcn/ui
- Jest for testing

### Backend

- Node.js
- Express.js
- TypeScript
- PostgreSQL
- Prisma ORM
- Jest for testing

### Infrastructure

- AWS
- Terraform
- Docker
- GitHub Actions

## Getting Started

1. **Prerequisites**

   - Node.js 18+
   - Docker
   - AWS CLI
   - Terraform

2. **Local Development Setup**

   ```bash
   # Clone the repository
   git clone https://github.com/your-username/visitor-book.git
   cd visitor-book

   # Install dependencies
   cd visitor-book-frontend
   npm install
   cd ../visitor-book-backend
   npm install

   # Start development servers
   # Terminal 1 (Frontend)
   cd visitor-book-frontend
   npm run dev

   # Terminal 2 (Backend)
   cd visitor-book-backend
   npm run dev
   ```

3. **Infrastructure Setup**
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

## Documentation Structure

- [`/docs/README.md`](./README.md) - This file, project overview
- [`/docs/API.md`](./API.md) - API documentation
- [`/docs/DEPLOYMENT.md`](./DEPLOYMENT.md) - Deployment guide
- [`/docs/terraform-guide.md`](./terraform-guide.md) - Infrastructure setup guide
- [`/docs/architecture/`](./architecture/) - Detailed architecture documentation
- [`/docs/deployment/`](./deployment/) - Deployment-specific documentation
- [`/docs/api/`](./api/) - API-specific documentation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.
