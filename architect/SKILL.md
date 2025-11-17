---
name: architect
description: PROACTIVELY use this skill when research is complete, when users have selected a tech stack, or when users say "create a plan", "let's build", "start development", or describe specific requirements. Automatically activate after ignite completes, or when users want to move from brainstorming to implementation. Creates detailed, parallelizable implementation plans with architecture, database schemas, API contracts, and component breakdowns for parallel deployment agents.
---

# Architect - Plan & Design

This skill creates comprehensive, structured implementation plans for enterprise web applications that can be executed by parallel deployment agents. Plans break down applications into independent, parallelizable components with clear interfaces and integration points.

## Purpose

Transform requirements and research findings into actionable, detailed implementation plans optimized for parallel development. Plans specify what to build, how components interact, and how parallel agents should coordinate their work.

## IMPORTANT: Proactive Usage

**This skill should be activated AUTOMATICALLY and PROACTIVELY** when:

1. **After research completes**: Automatically offer to create a plan after enterprise-app-researcher finishes
2. **User selects a tech stack**: "I'll go with React + Node.js", "Let's use .NET", "I want to use Python"
3. **User wants to move forward**: "Let's build it", "Create a plan", "Start development", "How do we implement this?"
4. **User has clear requirements**: When user describes specific features and technologies without needing research
5. **User asks about structure**: "How should I structure this?", "What's the architecture?", "Break this down"

**DO NOT wait for explicit request**. After research or when tech stack is clear, AUTOMATICALLY say: "I'll create a detailed implementation plan for parallel development."

**Example automatic triggers**:
- After research: "You selected React + Node.js. I'll create an implementation plan." -> ACTIVATE IMMEDIATELY
- User: "Let's build it with Python and PostgreSQL" -> ACTIVATE IMMEDIATELY
- User: "Create a plan for this" -> ACTIVATE IMMEDIATELY
- User: "I want to start development" -> ACTIVATE IMMEDIATELY

After activating, gather any missing requirements, then create the complete plan.

## When to Use This Skill

Use this skill when:
- Research is complete and a tech stack has been selected
- User has clear requirements for an enterprise application
- Need to plan a complex feature or refactoring
- Ready to transition from brainstorming to implementation
- Need to break down a monolithic task into parallel workstreams

Trigger phrases include:
- "Create a plan for building..."
- "How should I structure..."
- "Break down the implementation for..."
- "I want to build [feature], create a plan"
- "Plan out the development of..."

## How to Use This Skill

### Step 1: Gather Requirements

Ensure clarity on:
- **Functional requirements**: What features the application needs
- **Tech stack**: Which technologies to use (from research or user preference)
- **Architecture style**: Monolith, microservices, serverless, etc.
- **Key constraints**: Timeline, team size, budget, existing systems
- **Integration needs**: APIs, databases, third-party services
- **Non-functional requirements**: Performance, security, scalability

If any of these are unclear, ask the user for clarification before proceeding.

### Step 2: Define Application Architecture

Design the high-level architecture:
- **Component breakdown**: Frontend, backend, database, services, infrastructure
- **Data flow**: How information moves through the system
- **API contracts**: Endpoints, request/response formats, authentication
- **Database schema**: Tables, relationships, indexes
- **External integrations**: Third-party APIs, authentication providers, file storage
- **Security architecture**: Authentication flows, authorization patterns, data encryption
- **Scalability considerations**: Load balancing, caching, database optimization
- **Observability**: Logging, monitoring, tracing infrastructure

Document the architecture in a clear, visual format using **Mermaid diagrams** for:
- System architecture diagrams
- Data flow diagrams
- Authentication flow diagrams
- Database entity relationships

### Step 3: Break Down Into Parallel Components

Identify components that can be built in parallel. Each component should:
- Be independently developable
- Have clear, well-defined interfaces
- Minimize dependencies on other components
- Be testable in isolation
- Have clear integration points

Common parallel components:
- **Frontend UI**: Can be built with mock APIs
- **Backend API**: Can be built with schema-driven development
- **Database setup**: Schema, migrations, seed data
- **Authentication service**: User management, login, sessions
- **File upload service**: Storage integration, file handling
- **Real-time service**: WebSocket/SSE server
- **Infrastructure**: Docker, CI/CD, deployment scripts

### Step 4: Define Integration Contracts

For each component interface, specify:
- **API endpoints**: Method, path, request body, response body, status codes
- **Database schema**: Table definitions, relationships, constraints
- **Event schemas**: If using event-driven architecture
- **Configuration**: Environment variables, secrets, feature flags

**Generate OpenAPI 3.0 specifications** for all REST APIs to ensure:
- Precise contract definitions
- Auto-generated documentation
- Client SDK generation capability
- API testing automation
- Contract validation

These contracts are critical because parallel agents need to agree on interfaces before implementation.

### Step 5: Create Implementation Plan

Structure the plan into phases:

**Phase 1: Foundation** (Parallel)
- Database schema and migrations
- Project setup and configuration
- API contract definitions
- Mock data and fixtures

**Phase 2: Core Development** (Parallel)
- Frontend UI components
- Backend API endpoints
- Authentication implementation
- Database queries and models

**Phase 3: Integration** (Sequential or Limited Parallel)
- Connect frontend to real APIs
- End-to-end testing
- Error handling and validation
- Security hardening

**Phase 4: Polish** (Parallel)
- UI/UX refinements
- Performance optimization
- Documentation
- Deployment setup

### Step 6: Format the Plan

Present the plan in a structured format that the parallel-deployer skill can execute. Use the following template:

```markdown
# Implementation Plan: [Project Name]

## Overview
- **Project**: [Name and description]
- **Tech Stack**: [Frontend, Backend, Database, Infrastructure]
- **Architecture**: [Monolith/Microservices/etc.]
- **Timeline Estimate**: [e.g., 2-3 weeks with 2 developers]
- **Estimated Cost**: $X/month infrastructure, $Y development

## Architecture Diagram

Use **Mermaid** diagrams for clear visualization:

\`\`\`mermaid
graph TB
    Client[Web Client]
    API[API Server]
    DB[(Database)]
    Cache[(Redis Cache)]
    Storage[Object Storage]

    Client -->|HTTPS| API
    API -->|Query| DB
    API -->|Cache| Cache
    API -->|Upload/Download| Storage
\`\`\`

### Data Flow Diagram

\`\`\`mermaid
sequenceDiagram
    participant User
    participant Frontend
    participant API
    participant DB

    User->>Frontend: Login
    Frontend->>API: POST /auth/login
    API->>DB: Verify credentials
    DB-->>API: User data
    API-->>Frontend: JWT token
    Frontend-->>User: Dashboard
\`\`\`

## Database Schema

[Define all tables, fields, relationships]

## API Contracts

### OpenAPI 3.0 Specification

Generate a complete OpenAPI spec (see `/templates/api-contracts/openapi-template.yaml`):

\`\`\`yaml
openapi: 3.0.0
info:
  title: [Project Name] API
  version: 1.0.0
paths:
  /api/users:
    get:
      summary: Get all users
      security:
        - bearerAuth: []
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/User'
\`\`\`

### Endpoint: [Name]
- **Method**: GET/POST/PUT/DELETE
- **Path**: /api/...
- **Auth**: Required/Optional
- **Request**: {...}
- **Response**: {...}
- **Validation**: Input rules
- **Rate Limit**: X requests per minute

[Repeat for all endpoints]

### Security Architecture

\`\`\`mermaid
sequenceDiagram
    participant User
    participant Frontend
    participant API
    participant AuthService
    participant DB

    User->>Frontend: Login request
    Frontend->>API: POST /auth/login
    API->>AuthService: Validate credentials
    AuthService->>DB: Query user
    DB-->>AuthService: User data
    AuthService->>AuthService: Generate JWT
    AuthService-->>API: JWT + Refresh token
    API-->>Frontend: Tokens
    Frontend->>Frontend: Store tokens
\`\`\`

## Component Breakdown

### Component 1: [Name]
- **Purpose**: [What it does]
- **Stack**: [Technologies]
- **Dependencies**: [What it needs from other components]
- **Provides**: [What other components need from it]
- **Implementation Steps**: [Detailed checklist]

[Repeat for all components]

## Parallel Development Plan

### Phase 1: Foundation (All agents in parallel)
- **Agent 1**: Database setup
  - Create schema
  - Write migrations
  - Add seed data
- **Agent 2**: API contracts
  - Define OpenAPI spec
  - Create mock server
- **Agent 3**: Frontend setup
  - Initialize project
  - Setup routing
  - Create component structure

### Phase 2: Core Development (All agents in parallel)
- **Agent 1**: Frontend features
  - [Specific tasks]
- **Agent 2**: Backend API
  - [Specific tasks]
- **Agent 3**: Auth service
  - [Specific tasks]

### Phase 3: Integration (Sequential)
- Connect components
- End-to-end testing
- Bug fixes

## Integration Points

[Document how components connect and what files/configs need updating during integration]

## Testing Strategy

- Unit tests: [What to test in each component]
- Integration tests: [What to test when components connect]
- E2E tests: [Critical user flows]

## Deployment Plan

- Development environment setup
- CI/CD pipeline
- Production deployment steps
```

### Step 7: Validate with User

Before passing to the parallel-deployer:
- Review the plan with the user
- Confirm tech stack choices
- Adjust component breakdown if needed
- Get approval to proceed with implementation

## Best Practices

### Clear Contracts First

The quality of parallel development depends on clear contracts:
- Define ALL API endpoints upfront with exact request/response formats
- Specify database schema completely before any agent starts
- Document environment variables and configuration
- Create TypeScript interfaces or OpenAPI specs

### Minimize Dependencies

Design components to minimize interdependencies:
- Frontend should work with mock data/APIs
- Backend should work with in-memory or test databases
- Each service should have its own configuration
- Use dependency injection for easier testing

### Plan for Integration

Reserve time for integration because parallel components will need to be connected:
- Identify integration files (API client configs, database connections, etc.)
- Plan testing strategy for integrated system
- Anticipate common integration issues (CORS, auth, data format mismatches)

### Right-Size Components

Balance granularity:
- Too large: Defeats purpose of parallelization
- Too small: Creates integration complexity
- Sweet spot: 3-6 major components for most applications

### Include Non-Functional Requirements

Don't forget:
- Error handling strategy
- Logging and monitoring
- Security measures (input validation, SQL injection prevention, XSS protection)
- Performance targets
- Accessibility requirements

## Stack-Agnostic Approach

Adapt the plan format to the chosen stack:

**Frontend Frameworks**:
- React: Plan component hierarchy, state management (Redux/Context), routing
- Vue: Plan components, Vuex stores, router configuration
- Angular: Plan modules, services, routing, state management

**Backend Frameworks**:
- Node.js/Express: Plan routes, middleware, controllers, services
- .NET: Plan controllers, services, data access layer, dependency injection
- Python/Django: Plan apps, models, views, serializers
- Java/Spring: Plan controllers, services, repositories, configurations

**Database**:
- SQL: Plan normalized schema, indexes, migrations
- NoSQL: Plan collections/documents, indexes, data denormalization

## Example Usage

**User**: "I researched options and want to build a task management app with React, Node.js, and PostgreSQL. Create a plan."

**Planning Process**:
1. Confirm requirements: User auth, create/edit/delete tasks, real-time updates?
2. Define architecture: React SPA + Express API + PostgreSQL + WebSocket server
3. Design database schema: users, tasks, task_assignments tables
4. Define API contracts: 10 REST endpoints + WebSocket events
5. Break into components:
   - Frontend React app
   - Backend Express API
   - Database schema + migrations
   - WebSocket server
   - Auth service
6. Create parallel plan:
   - Agent 1: React UI (uses mock API)
   - Agent 2: Express API (uses test DB)
   - Agent 3: Database setup (schema + migrations)
   - Agent 4: WebSocket server
7. Define integration phase: Connect components, add real database, test end-to-end
8. Present plan to user for approval

## Integration with Other Skills

This skill fits into the workflow:
1. **enterprise-app-researcher**: Research tech options
2. **enterprise-app-planner**: Create implementation plan (this skill)
3. **parallel-deployer**: Execute the plan with parallel agents
4. **component-integrator**: Combine components into working application

## Notes

- Plans should be detailed enough for autonomous agent execution
- Always include specific file paths and code structure
- Specify which npm packages/dependencies to install
- Include example code snippets for complex patterns
- Document assumptions clearly
- Plan for failure: What if an agent gets stuck?
