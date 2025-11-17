# REST API Contract Template

Use this template to define clear API contracts for parallel agent development.

---

## Base URL

```
Development: http://localhost:3001/api
Production: https://api.yourapp.com/api
```

---

## Authentication

All authenticated endpoints require a JWT token in the Authorization header:

```http
Authorization: Bearer <your_jwt_token>
```

---

## Standard Response Format

### Success Response
```json
{
  "success": true,
  "data": {
    // Response data here
  }
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "message": "Human-readable error message",
    "code": "ERROR_CODE",
    "details": {} // Optional: Additional error details
  }
}
```

### HTTP Status Codes
- `200 OK` - Successful GET, PATCH, DELETE
- `201 Created` - Successful POST (resource created)
- `400 Bad Request` - Validation error
- `401 Unauthorized` - Authentication required or failed
- `403 Forbidden` - Authenticated but not authorized
- `404 Not Found` - Resource doesn't exist
- `409 Conflict` - Resource conflict (e.g., duplicate)
- `422 Unprocessable Entity` - Semantic errors
- `429 Too Many Requests` - Rate limit exceeded
- `500 Internal Server Error` - Server error

---

## Pagination

For list endpoints that support pagination:

### Query Parameters
- `page` (integer, default: 1) - Page number
- `limit` (integer, default: 20, max: 100) - Items per page
- `sort` (string) - Sort field and direction (e.g., "createdAt:desc")

### Response Format
```json
{
  "success": true,
  "data": {
    "items": [...],
    "pagination": {
      "currentPage": 1,
      "totalPages": 10,
      "totalItems": 200,
      "limit": 20,
      "hasNextPage": true,
      "hasPreviousPage": false
    }
  }
}
```

---

## Resource: [ResourceName]

### Endpoints

#### List [Resources]
```
GET /api/resources
```

**Query Parameters:**
- `page` (integer, optional) - Page number
- `limit` (integer, optional) - Items per page
- `search` (string, optional) - Search query
- `filter[field]` (string, optional) - Filter by field
- `sort` (string, optional) - Sort order

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "507f1f77bcf86cd799439011",
        "name": "Resource Name",
        "description": "Resource description",
        "createdAt": "2025-11-17T10:00:00Z",
        "updatedAt": "2025-11-17T10:00:00Z"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 5,
      "totalItems": 96,
      "limit": 20
    }
  }
}
```

**Errors:**
- `400 Bad Request` - Invalid query parameters
- `401 Unauthorized` - Authentication required

---

#### Get Single [Resource]
```
GET /api/resources/:id
```

**Path Parameters:**
- `id` (string, required) - Resource ID

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "507f1f77bcf86cd799439011",
    "name": "Resource Name",
    "description": "Resource description",
    "metadata": {
      // Additional fields
    },
    "createdAt": "2025-11-17T10:00:00Z",
    "updatedAt": "2025-11-17T10:00:00Z"
  }
}
```

**Errors:**
- `404 Not Found` - Resource doesn't exist
- `401 Unauthorized` - Authentication required

---

#### Create [Resource]
```
POST /api/resources
```

**Headers:**
- `Authorization: Bearer <token>` (required)
- `Content-Type: application/json`

**Request Body:**
```json
{
  "name": "Resource Name",
  "description": "Resource description",
  "metadata": {
    // Additional fields
  }
}
```

**Validation Rules:**
- `name`: required, string, min 3 chars, max 100 chars
- `description`: optional, string, max 500 chars
- `metadata`: optional, object

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "id": "507f1f77bcf86cd799439011",
    "name": "Resource Name",
    "description": "Resource description",
    "metadata": {},
    "createdAt": "2025-11-17T10:00:00Z",
    "updatedAt": "2025-11-17T10:00:00Z"
  }
}
```

**Errors:**
- `400 Bad Request` - Validation error
- `401 Unauthorized` - Authentication required
- `409 Conflict` - Resource already exists

---

#### Update [Resource]
```
PATCH /api/resources/:id
```

**Headers:**
- `Authorization: Bearer <token>` (required)
- `Content-Type: application/json`

**Path Parameters:**
- `id` (string, required) - Resource ID

**Request Body:**
```json
{
  "name": "Updated Name",
  "description": "Updated description"
}
```

**Note:** Only include fields you want to update (partial update).

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "507f1f77bcf86cd799439011",
    "name": "Updated Name",
    "description": "Updated description",
    "metadata": {},
    "createdAt": "2025-11-17T10:00:00Z",
    "updatedAt": "2025-11-17T11:30:00Z"
  }
}
```

**Errors:**
- `400 Bad Request` - Validation error
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Not authorized to update
- `404 Not Found` - Resource doesn't exist

---

#### Delete [Resource]
```
DELETE /api/resources/:id
```

**Headers:**
- `Authorization: Bearer <token>` (required)

**Path Parameters:**
- `id` (string, required) - Resource ID

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "message": "Resource deleted successfully",
    "id": "507f1f77bcf86cd799439011"
  }
}
```

**Errors:**
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Not authorized to delete
- `404 Not Found` - Resource doesn't exist
- `409 Conflict` - Cannot delete (has dependencies)

---

## TypeScript Interfaces

### Request/Response Types
```typescript
// Resource type
export interface Resource {
  id: string;
  name: string;
  description?: string;
  metadata?: Record<string, any>;
  createdAt: string; // ISO 8601 date
  updatedAt: string; // ISO 8601 date
}

// Create resource request
export interface CreateResourceRequest {
  name: string;
  description?: string;
  metadata?: Record<string, any>;
}

// Update resource request
export interface UpdateResourceRequest {
  name?: string;
  description?: string;
  metadata?: Record<string, any>;
}

// List response
export interface ListResourcesResponse {
  success: true;
  data: {
    items: Resource[];
    pagination: {
      currentPage: number;
      totalPages: number;
      totalItems: number;
      limit: number;
      hasNextPage: boolean;
      hasPreviousPage: boolean;
    };
  };
}

// Single resource response
export interface GetResourceResponse {
  success: true;
  data: Resource;
}

// Error response
export interface ErrorResponse {
  success: false;
  error: {
    message: string;
    code: string;
    details?: Record<string, any>;
  };
}
```

---

## Rate Limiting

All endpoints are rate limited to prevent abuse:

- **Authenticated Users:** 1000 requests per hour
- **Unauthenticated:** 100 requests per hour

**Rate Limit Headers:**
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1700222400
```

**Rate Limit Exceeded (429):**
```json
{
  "success": false,
  "error": {
    "message": "Too many requests. Please try again later.",
    "code": "RATE_LIMIT_EXCEEDED",
    "details": {
      "retryAfter": 3600
    }
  }
}
```

---

## CORS Configuration

**Allowed Origins:**
- Development: `http://localhost:5173`, `http://localhost:3000`
- Production: `https://yourapp.com`

**Allowed Methods:**
- `GET`, `POST`, `PATCH`, `DELETE`, `OPTIONS`

**Allowed Headers:**
- `Content-Type`, `Authorization`

**Credentials:** Allowed

---

## Security

### Input Validation
- All inputs are validated before processing
- SQL injection prevention via ORM
- XSS prevention via input sanitization

### Authentication
- JWT tokens with HS256 algorithm
- Token expiration: 24 hours
- Refresh token: 7 days (optional)

### HTTPS
- All production endpoints require HTTPS
- HTTP requests redirect to HTTPS

---

## Testing

### Mock Data
For frontend development, use this mock response:

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "mock-id-1",
        "name": "Mock Resource 1",
        "description": "This is a mock resource",
        "createdAt": "2025-11-17T10:00:00Z",
        "updatedAt": "2025-11-17T10:00:00Z"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 1,
      "totalItems": 1,
      "limit": 20
    }
  }
}
```

### Test Endpoints
```bash
# List resources
curl -X GET http://localhost:3001/api/resources

# Get single resource
curl -X GET http://localhost:3001/api/resources/507f1f77bcf86cd799439011

# Create resource
curl -X POST http://localhost:3001/api/resources \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"name":"Test Resource","description":"Test"}'

# Update resource
curl -X PATCH http://localhost:3001/api/resources/507f1f77bcf86cd799439011 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"name":"Updated Name"}'

# Delete resource
curl -X DELETE http://localhost:3001/api/resources/507f1f77bcf86cd799439011 \
  -H "Authorization: Bearer <token>"
```

---

## Notes for Parallel Development

### Frontend Agent
- Use mock data matching this contract during development
- Handle all error responses gracefully
- Show loading states during API calls
- Implement retry logic for failed requests

### Backend Agent
- Implement exactly as specified
- Validate all inputs per validation rules
- Return responses in exact format
- Add appropriate error handling

### Integration
- Frontend base URL from environment variable
- Backend CORS allows frontend origin
- JWT token passed in Authorization header
- Error codes match between frontend and backend

---

## Checklist

Before marking API contract complete:

- [ ] All endpoint paths defined
- [ ] Request/response formats specified
- [ ] Validation rules documented
- [ ] Error responses listed
- [ ] TypeScript interfaces provided
- [ ] HTTP status codes documented
- [ ] Authentication requirements clear
- [ ] Pagination format standardized
- [ ] Rate limiting defined
- [ ] CORS configuration specified
- [ ] Test examples provided
- [ ] Mock data available

---

**This contract is ready for parallel agent development!**
