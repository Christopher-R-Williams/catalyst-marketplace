---
name: ship
description: PROACTIVELY use this skill immediately after deploy completes, or when users say "integrate", "connect components", "wire it together", "make it work", "ship it", or when parallel agents finish building. Automatically activate when components are ready to be connected. Integrates frontend to backend, backend to database, configures authentication, handles CORS, sets up environment variables, and performs end-to-end testing to create a working application ready to ship.
---

# Ship - Integrate & Launch

This skill integrates components built by parallel agents into a fully functional enterprise application. It connects the pieces, resolves integration issues, configures the environment, and validates that the complete system works end-to-end.

## Purpose

Transform independently developed components into a unified, working application. After parallel agents build separate pieces (frontend, backend, database, etc.), this skill connects them, handles cross-cutting concerns, and ensures the integrated system functions correctly.

## IMPORTANT: Proactive Usage

**This skill should be activated AUTOMATICALLY and PROACTIVELY** when:

1. **After parallel deployment completes**: Automatically offer to integrate when parallel-deployer finishes
2. **All components are built**: When agents have completed their work and components exist
3. **User wants to connect things**: "Integrate", "Connect components", "Wire it together", "Make it work"
4. **User wants to test**: "Does it work?", "Run the app", "Test it", "Start the application"
5. **Final step in workflow**: Last step after research -> plan -> deploy

**DO NOT wait for explicit request**. After components are built, AUTOMATICALLY say: "I'll now integrate all components into a working application."

**Example automatic triggers**:
- After deployment: "Components are built. I'll integrate them now." -> ACTIVATE IMMEDIATELY
- User: "Connect everything" -> ACTIVATE IMMEDIATELY
- User: "Make it work together" -> ACTIVATE IMMEDIATELY
- User: "Can I run it now?" -> ACTIVATE IMMEDIATELY

After activating, connect components, configure environment, test end-to-end, and create setup documentation.

## When to Use This Skill

Use this skill when:
- Parallel deployment agents have completed their work
- Have multiple independent components that need to be connected
- Ready to integrate frontend with backend, backend with database, etc.
- Need to configure cross-component concerns (CORS, auth, environment variables)
- Want to test the complete system end-to-end

Trigger phrases include:
- "Integrate the components"
- "Connect the frontend and backend"
- "Wire everything together"
- "Make the components work together"
- "Complete the integration"

## How to Use This Skill

### Step 1: Inventory Components

Gather information about what was built:
- **Component list**: What components exist (frontend, backend, database, etc.)
- **File locations**: Where each component's code lives
- **Technologies used**: Frameworks, libraries, tools for each component
- **Contracts defined**: API endpoints, database schemas, event formats
- **Current state**: What works in isolation, what's been tested

Create a checklist of all components and their status.

### Step 2: Identify Integration Points

Map out all connections needed:
- **Frontend to Backend**: API calls, authentication, CORS
- **Backend to Database**: Connection strings, ORM configuration, migrations
- **Authentication**: JWT/session configuration across components
- **File Storage**: S3/Azure Blob connections if applicable
- **Real-time**: WebSocket/SSE connections if applicable
- **External APIs**: Third-party service integrations

For each integration point, document:
- What needs to connect
- What configuration is required
- What files need to be modified
- What potential issues might arise

### Step 3: Setup Shared Configuration

Create centralized configuration:

**Environment Variables**:
- Database connection strings
- API URLs and ports
- Authentication secrets (JWT secret, session secret)
- Third-party API keys
- CORS allowed origins
- File storage credentials

**Configuration Files**:
- `.env.example` templates
- Development vs production configs
- Docker compose files if using containers
- Proxy configurations for development

Create both `.env.example` (template) and `.env` (actual values) files.

### Step 4: Connect Frontend to Backend

Integrate the UI with the API:

**Update API Client**:
- Configure base URL for API calls
- Set up authentication headers
- Add error handling for API responses
- Configure request/response interceptors

**Handle CORS**:
- Backend: Configure CORS to allow frontend origin
- Backend: Set allowed methods and headers
- Frontend: Ensure credentials are sent if needed

**Authentication Integration**:
- Store tokens (localStorage/sessionStorage/cookies)
- Add auth headers to requests
- Handle token refresh
- Redirect on auth failures

**Replace Mock Data**:
- Remove mock API calls
- Replace with real API integration
- Update data models if needed
- Test each API endpoint from frontend

### Step 5: Connect Backend to Database

Integrate the API with the database:

**Database Connection**:
- Configure connection string with host, port, username, password, database name
- Test connection before starting server
- Handle connection errors gracefully

**Run Migrations**:
- Execute database migrations to create schema
- Verify all tables and relationships are created
- Run seed data if needed

**ORM Configuration**:
- Configure Prisma/TypeORM/Mongoose/Entity Framework
- Verify models match database schema
- Test basic CRUD operations

**Connection Pooling**:
- Configure appropriate pool size
- Set connection timeouts
- Handle connection failures

### Step 6: Setup Authentication Flow

Integrate authentication across all components:

**Backend**:
- Configure JWT secret or session secret
- Setup password hashing (bcrypt)
- Implement login/logout/register endpoints
- Add authentication middleware
- Protect routes that require auth

**Frontend**:
- Create login/register pages
- Store auth tokens
- Add authentication context/state
- Protect routes that require auth
- Handle token expiration

**Database**:
- Ensure users table exists
- Add necessary indexes
- Store password hashes securely

### Step 7: Handle Cross-Cutting Concerns

Address system-wide concerns:

**Error Handling**:
- Consistent error format across API
- Error boundaries in frontend
- User-friendly error messages
- Logging for debugging

**Validation**:
- Frontend: Input validation before submission
- Backend: Request validation (Joi, Yup, class-validator)
- Database: Schema constraints

**Security**:
- SQL injection prevention (use parameterized queries)
- XSS prevention (sanitize inputs, escape outputs)
- CSRF protection if using sessions
- Rate limiting on API endpoints
- Secure headers (helmet.js)
- **Run automated security scanning**:
  - npm audit / yarn audit for dependency vulnerabilities
  - OWASP dependency checker
  - CodeQL or Snyk for code analysis
  - Check for exposed secrets (.env files, API keys)

**Logging**:
- Structured logging in backend (Winston, Pino, Log4j)
- Console logging for frontend development
- Error tracking (Sentry, Rollbar, LogRocket)
- Performance monitoring (optional)

### Step 8: Development Environment Setup

Make it easy to run the complete system:

**Monorepo Scripts** (package.json):
```json
{
  "scripts": {
    "dev": "concurrently \"npm run dev:frontend\" \"npm run dev:backend\"",
    "dev:frontend": "cd frontend && npm run dev",
    "dev:backend": "cd backend && npm run dev",
    "setup": "npm run install:all && npm run db:migrate",
    "install:all": "npm install && cd frontend && npm install && cd ../backend && npm install",
    "db:migrate": "cd backend && npm run migrate"
  }
}
```

**Docker Compose** (if using containers):
```yaml
version: '3.8'
services:
  frontend:
    ...
  backend:
    ...
  database:
    ...
```

**README Instructions**:
- Prerequisites (Node.js version, database, etc.)
- Installation steps
- Environment variable setup
- How to run development server
- How to run tests

### Step 9: Comprehensive Testing

Validate the integrated system with automated and manual testing:

**Automated E2E Testing** (Recommended):
- Setup Playwright or Cypress for frontend E2E tests
- Test critical user flows:
  - User registration and login
  - Create/Read/Update/Delete operations
  - Authentication-protected routes
  - Form validation and error states
- Generate test coverage reports
- Setup CI/CD to run tests automatically

**API Integration Testing**:
- Test all API endpoints with real database
- Verify request/response formats match OpenAPI spec
- Test authentication and authorization
- Test error handling (4xx, 5xx responses)
- Test data validation and sanitization
- Use tools: Supertest, REST Client, Postman/Newman

**Unit Testing**:
- Frontend: Component tests (React Testing Library, Vue Test Utils)
- Backend: Service and controller tests (Jest, Mocha)
- Database: Model and migration tests
- Aim for >80% code coverage

**Performance Testing**:
- Load testing with k6, Artillery, or Apache JMeter
- Test API response times under load
- Verify frontend load times (Lighthouse, WebPageTest)
- Test with realistic data volumes
- Database query performance analysis

**Security Testing**:
- OWASP Top 10 vulnerability checks
- SQL injection testing
- XSS testing
- CSRF testing
- Authentication/authorization bypass attempts
- Dependency vulnerability scanning

**Accessibility Testing**:
- WCAG 2.1 compliance checks
- Screen reader testing
- Keyboard navigation testing
- Color contrast validation
- Use tools: axe-core, Pa11y, Lighthouse

**Cross-Browser Testing**:
- Test on Chrome, Firefox, Safari, Edge
- Mobile responsive testing
- Different screen sizes and resolutions

### Step 10: Fix Integration Issues

Common issues and solutions:

**CORS Errors**:
- Backend not configured for frontend origin
- Missing credentials in frontend requests
- Wrong HTTP methods allowed

**Authentication Issues**:
- Token not being sent with requests
- Backend not validating tokens correctly
- Token expiration not handled

**Database Connection Issues**:
- Wrong connection string
- Database not running
- Firewall blocking connection
- Missing migrations

**API Contract Mismatches**:
- Request/response formats don't match
- Endpoint URLs different than expected
- Missing required fields

**Environment Variables**:
- Variables not loaded
- Wrong variable names
- Missing values in .env

For each issue:
1. Identify the root cause
2. Fix the issue
3. Test the fix
4. Document the solution

### Step 11: Documentation and Handoff

Document the integrated system:

**Technical Documentation**:
- Architecture overview
- How components interact
- API documentation
- Database schema
- Environment variables

**Developer Guide**:
- How to set up development environment
- How to run the application
- How to run tests
- Common troubleshooting

**Deployment Guide** (if applicable):
- Production environment setup
- Deployment steps
- Environment variable configuration
- Database migration process

## Best Practices

### Integration Order

Follow this sequence for smoother integration:
1. Database setup (migrations, seed data)
2. Backend to database connection
3. Backend API testing (Postman/curl)
4. Frontend to backend connection (start with simple GET requests)
5. Authentication integration
6. Complex features integration
7. Error handling and edge cases

### Test Incrementally

Don't integrate everything at once:
- Connect and test one integration point at a time
- Verify each connection before moving to the next
- Keep previous integrations working
- Use git commits to save working states

### Use Environment-Specific Configs

Separate development and production:
- Development: localhost URLs, verbose logging, hot reload
- Production: Production URLs, minimal logging, optimizations
- Use environment variables to switch between them

### Handle Async Operations

Common in modern apps:
- API calls are async (use async/await)
- Database queries are async
- File uploads are async
- Use proper error handling for async operations

### Maintain Type Safety

If using TypeScript:
- Share types between frontend and backend
- Use shared directory for common types
- Validate runtime data matches types
- Use code generation from OpenAPI specs if possible

## Stack-Specific Integration Steps

### React + Node.js + PostgreSQL

**Frontend (React)**:
- Create API client using fetch or axios
- Configure base URL from environment variable
- Add authentication interceptor
- Handle loading and error states

**Backend (Express)**:
- Install and configure CORS
- Setup Prisma or TypeORM with PostgreSQL
- Run migrations
- Configure environment variables
- Add authentication middleware

**Database (PostgreSQL)**:
- Run PostgreSQL locally or use Docker
- Create database
- Run migrations
- Verify schema

**Integration**:
- Test backend API with Postman
- Connect frontend to backend
- Test authentication flow
- Deploy or run locally with concurrently

### Vue + .NET + SQL Server

**Frontend (Vue)**:
- Create API service using axios
- Configure API base URL
- Setup Vuex for state management
- Add authentication guards

**Backend (.NET)**:
- Configure CORS in Startup.cs
- Setup Entity Framework with SQL Server
- Run migrations
- Configure appsettings.json
- Add JWT authentication

**Database (SQL Server)**:
- Run SQL Server locally or use Docker
- Create database
- Run EF migrations
- Verify schema

**Integration**:
- Test backend API with Swagger
- Connect frontend to backend
- Configure authentication
- Run with dotnet run + npm run serve

### Angular + Python/Django + PostgreSQL

**Frontend (Angular)**:
- Create services for API calls
- Configure environment files
- Setup HttpInterceptor for auth
- Add route guards

**Backend (Django)**:
- Install django-cors-headers
- Configure CORS settings
- Setup Django REST Framework
- Run migrations
- Configure settings.py

**Database (PostgreSQL)**:
- Configure database in settings.py
- Run migrations
- Create superuser
- Verify schema

**Integration**:
- Test API with Django REST browsable API
- Connect Angular to Django API
- Setup token authentication
- Run with ng serve + python manage.py runserver

## Common Integration Patterns

### Proxy Setup for Development

Avoid CORS during development:

**React** (package.json):
```json
"proxy": "http://localhost:3001"
```

**Vue** (vue.config.js):
```javascript
module.exports = {
  devServer: {
    proxy: 'http://localhost:3001'
  }
}
```

**Angular** (proxy.conf.json):
```json
{
  "/api": {
    "target": "http://localhost:3001",
    "secure": false
  }
}
```

### Authentication Token Storage

**localStorage**:
```javascript
localStorage.setItem('token', token);
const token = localStorage.getItem('token');
```

**Request Interceptor**:
```javascript
axios.interceptors.request.use(config => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

### Database Connection Check

**Node.js/Prisma**:
```javascript
await prisma.$connect();
console.log('Database connected');
```

**.NET/Entity Framework**:
```csharp
await context.Database.CanConnectAsync();
Console.WriteLine("Database connected");
```

## Example Usage

**User**: "The parallel agents finished building the components. Integrate them."

**Integration Process**:
1. Inventory: Frontend (React), Backend (Express), Database (PostgreSQL)
2. Identify integration points: Frontend->Backend API, Backend->Database
3. Setup .env files with database connection and JWT secret
4. Connect backend to database:
   - Configure Prisma connection string
   - Run migrations
   - Test connection
5. Connect frontend to backend:
   - Configure API base URL
   - Add CORS to backend
   - Create API client in frontend
   - Test simple GET request
6. Setup authentication:
   - Configure JWT in backend
   - Create login/register endpoints
   - Add auth to frontend
   - Test login flow
7. Run development environment:
   - Start database
   - Start backend
   - Start frontend
   - Test end-to-end
8. Fix any issues:
   - CORS configuration
   - API contract mismatches
   - Environment variables
9. Document setup process in README

## Integration with Other Skills

Complete workflow:
1. **enterprise-app-researcher**: Research technology options
2. **enterprise-app-planner**: Create implementation plan
3. **parallel-deployer**: Build components in parallel
4. **component-integrator**: Integrate components (this skill)

## Notes

- Integration always takes longer than expected - plan accordingly
- Test each integration point before moving to the next
- Keep parallel components working independently during integration
- Use git branches for integration work
- Document issues and solutions for future reference
- Most issues are configuration-related (CORS, environment variables, connection strings)
