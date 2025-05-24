# Visitor Book API Documentation

## Overview

The Visitor Book API is a RESTful service that provides endpoints for managing visitor records, authentication, and system administration. This documentation details all available endpoints, their request/response formats, and authentication requirements.

## Base URL

```
https://api.visitorbook.com/v1
```

## Authentication

All API requests require authentication using JWT (JSON Web Tokens).

### Authentication Header

```
Authorization: Bearer <your_jwt_token>
```

## API Endpoints

### Authentication

#### Login

```http
POST /auth/login
```

**Request Body:**

```json
{
  "email": "user@example.com",
  "password": "your_password"
}
```

**Response:**

```json
{
  "token": "jwt_token",
  "user": {
    "id": "user_id",
    "email": "user@example.com",
    "role": "admin"
  }
}
```

### Visitors

#### Create Visitor Entry

```http
POST /visitors
```

**Request Body:**

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "purpose": "Meeting",
  "host": "host_id",
  "expectedArrival": "2024-03-20T10:00:00Z"
}
```

**Response:**

```json
{
  "id": "visitor_id",
  "name": "John Doe",
  "status": "expected",
  "createdAt": "2024-03-19T15:00:00Z"
}
```

#### Get Visitor List

```http
GET /visitors
```

**Query Parameters:**

- `page` (optional): Page number for pagination
- `limit` (optional): Number of items per page
- `status` (optional): Filter by visitor status
- `date` (optional): Filter by date

**Response:**

```json
{
  "visitors": [
    {
      "id": "visitor_id",
      "name": "John Doe",
      "status": "checked_in",
      "arrivalTime": "2024-03-20T10:05:00Z"
    }
  ],
  "pagination": {
    "total": 100,
    "page": 1,
    "limit": 10
  }
}
```

#### Get Visitor Details

```http
GET /visitors/{visitor_id}
```

**Response:**

```json
{
  "id": "visitor_id",
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "purpose": "Meeting",
  "host": {
    "id": "host_id",
    "name": "Host Name"
  },
  "status": "checked_in",
  "arrivalTime": "2024-03-20T10:05:00Z",
  "departureTime": null
}
```

### Hosts

#### Create Host

```http
POST /hosts
```

**Request Body:**

```json
{
  "name": "Host Name",
  "email": "host@example.com",
  "department": "IT",
  "phone": "+1234567890"
}
```

**Response:**

```json
{
  "id": "host_id",
  "name": "Host Name",
  "email": "host@example.com",
  "department": "IT"
}
```

#### Get Host List

```http
GET /hosts
```

**Query Parameters:**

- `page` (optional): Page number for pagination
- `limit` (optional): Number of items per page
- `department` (optional): Filter by department

**Response:**

```json
{
  "hosts": [
    {
      "id": "host_id",
      "name": "Host Name",
      "department": "IT",
      "email": "host@example.com"
    }
  ],
  "pagination": {
    "total": 50,
    "page": 1,
    "limit": 10
  }
}
```

### Reports

#### Generate Visitor Report

```http
GET /reports/visitors
```

**Query Parameters:**

- `startDate`: Start date for report period
- `endDate`: End date for report period
- `format` (optional): Report format (pdf/csv)

**Response:**

```json
{
  "reportId": "report_id",
  "downloadUrl": "https://api.visitorbook.com/reports/download/report_id",
  "generatedAt": "2024-03-20T15:00:00Z"
}
```

## Error Responses

All error responses follow this format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": {} // Optional additional error details
  }
}
```

### Common Error Codes

- `AUTH_REQUIRED`: Authentication required
- `INVALID_CREDENTIALS`: Invalid login credentials
- `RESOURCE_NOT_FOUND`: Requested resource not found
- `VALIDATION_ERROR`: Invalid request data
- `SERVER_ERROR`: Internal server error

## Rate Limiting

API requests are limited to:

- 100 requests per minute for authenticated users
- 20 requests per minute for unauthenticated users

Rate limit headers are included in all responses:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1616248800
```

## Webhooks

The API supports webhooks for real-time notifications of visitor events.

### Available Events

- `visitor.created`
- `visitor.checked_in`
- `visitor.checked_out`
- `visitor.cancelled`

### Webhook Configuration

```http
POST /webhooks
```

**Request Body:**

```json
{
  "url": "https://your-server.com/webhook",
  "events": ["visitor.created", "visitor.checked_in"],
  "secret": "your_webhook_secret"
}
```

## SDKs and Examples

### Node.js Example

```javascript
const VisitorBookAPI = require('visitor-book-sdk');

const api = new VisitorBookAPI({
  baseUrl: 'https://api.visitorbook.com/v1',
  token: 'your_jwt_token',
});

// Create a visitor
const visitor = await api.visitors.create({
  name: 'John Doe',
  email: 'john@example.com',
  purpose: 'Meeting',
});
```

### Python Example

```python
from visitor_book import VisitorBookAPI

api = VisitorBookAPI(
    base_url='https://api.visitorbook.com/v1',
    token='your_jwt_token'
)

# Get visitor list
visitors = api.visitors.list(
    page=1,
    limit=10,
    status='checked_in'
)
```

## Support

For API support, please contact:

- Email: api-support@visitorbook.com
- Documentation: https://docs.visitorbook.com
- Status Page: https://status.visitorbook.com
