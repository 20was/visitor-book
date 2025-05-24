# Visitor Book

A modern visitor management system built with React, Node.js, and PostgreSQL.

## Features

- Visitor registration and check-in/out
- Real-time visitor tracking
- Admin dashboard
- Secure authentication
- Responsive design

## Tech Stack

### Frontend

- React with TypeScript
- Tailwind CSS for styling
- React Query for data fetching
- Axios for HTTP requests

### Backend

- Node.js with Express
- TypeScript
- PostgreSQL database
- JWT authentication

### Infrastructure

- Docker for containerization
- AWS for cloud hosting
- Terraform for infrastructure as code

## Getting Started

### Prerequisites

- Node.js (v20 or higher)
- Docker and Docker Compose
- PostgreSQL (if running locally)

### Installation

1. Clone the repository:

```bash
git clone git@github.com:20was/visitor-book.git
cd visitor-book
```

2. Start the development environment:

```bash
docker-compose up --build
```

3. Access the applications:

- Frontend: http://localhost:3000
- Backend API: http://localhost:3001

## Development

### Project Structure

```
visitor-book/
├── visitor-book-frontend/    # React frontend application
├── visitor-book-backend/     # Node.js backend API
├── terraform/               # Infrastructure as code
└── docs/                    # Project documentation
```

### Available Scripts

#### Frontend

```bash
cd visitor-book-frontend
npm install
npm start
```

#### Backend

```bash
cd visitor-book-backend
npm install
npm run dev
```

## Documentation

- [API Documentation](docs/API.md)
- [Deployment Guide](docs/DEPLOYMENT.md)
- [Terraform Guide](docs/terraform-guide.md)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
