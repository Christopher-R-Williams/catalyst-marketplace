---
name: deploy
description: PROACTIVELY use this skill immediately after architect creates a plan, or when users say "build it", "implement this", "let's code", "start development", "execute the plan", or show readiness to begin development. Automatically activate when a plan exists and user approves moving forward. Orchestrates multiple specialized agents working simultaneously on frontend, backend, database, and other components in parallel. DO NOT code components yourself - launch parallel agents to do it.
---

# Deploy - Build in Parallel

This skill orchestrates the parallel execution of enterprise application implementation plans. It launches multiple specialized agents that work simultaneously on different components, monitors their progress, and prepares components for integration.

## Purpose

Execute implementation plans efficiently by deploying multiple specialized agents in parallel. Instead of building components sequentially, multiple agents work simultaneously on independent parts (frontend, backend, database, etc.), dramatically reducing development time.

## IMPORTANT: Proactive Usage

**This skill should be activated AUTOMATICALLY and PROACTIVELY** when:

1. **After planning completes**: Automatically offer to execute with parallel agents after enterprise-app-planner finishes
2. **User approves the plan**: "Looks good", "Let's do it", "Build it", "Start development", "Execute the plan"
3. **User wants to begin coding**: "Let's code", "Start building", "Implement this", "Make it happen"
4. **Plan is ready**: When implementation plan exists and user is ready to proceed
5. **User asks to execute**: "Run the plan", "Deploy this", "Build the components"

**DO NOT wait for explicit request**. After plan is approved, AUTOMATICALLY say: "I'll launch parallel development agents to build the components simultaneously."

**CRITICAL**: DO NOT code components yourself. Your job is to LAUNCH multiple Task agents in parallel to do the coding.

**Example automatic triggers**:
- After planning: "Plan looks good? I'll launch parallel agents to build it." -> ACTIVATE IMMEDIATELY
- User: "Let's build it" -> ACTIVATE IMMEDIATELY
- User: "Execute the plan" -> ACTIVATE IMMEDIATELY
- User: "Start coding" -> ACTIVATE IMMEDIATELY (launch agents, don't code yourself)

After activating, prepare workspace, then launch ALL agents in a SINGLE message with multiple Task tool calls.

## When to Use This Skill

Use this skill when:
- An implementation plan has been created and approved
- Ready to begin actual development work
- Have a plan that specifies parallel components and their interfaces
- Need to build multiple independent components simultaneously
- Want to maximize development efficiency through parallelization

Trigger phrases include:
- "Execute this plan with parallel agents"
- "Deploy this using parallel development"
- "Build this with multiple agents working in parallel"
- "Implement this plan"
- "Start parallel development"

## How to Use This Skill

### Step 1: Validate the Plan

Before launching agents, ensure the plan includes:
- **Clear component breakdown**: Each component is well-defined and independent
- **Defined interfaces**: API contracts, database schemas, event schemas are specified
- **Parallel phases**: Plan explicitly identifies which components can be built in parallel
- **Integration strategy**: Clear steps for combining components later

If the plan lacks these elements, request the user to refine it using the enterprise-app-planner skill.

### Step 2: Prepare the Workspace

Set up the development environment:
- **Create project directories**: One for each major component or a monorepo structure
- **Initialize version control**: Git repository with proper .gitignore
- **Create shared contracts**: API schemas, TypeScript interfaces, database migrations in shared location
- **Setup configuration**: Environment variable templates, config files

This foundation ensures all parallel agents work in a coordinated environment.

### Step 3: Launch Parallel Agents

Launch ALL parallel agents in a SINGLE message using multiple Task tool calls. Each agent receives:
- **Component specification**: What to build
- **Tech stack**: Specific frameworks and libraries
- **Interface contracts**: APIs, schemas, event formats they must adhere to
- **File paths**: Where to create files
- **Success criteria**: How to know when the component is complete

Example structure for agent prompts:

```
Agent 1 - Frontend Development:
- Build React frontend for [app name]
- Create components: [list]
- Implement routing for: [routes]
- Use mock API at: [endpoints]
- Tech stack: React 18, TypeScript, Tailwind CSS, React Router
- Output directory: /frontend
- API contract (must match exactly): [OpenAPI spec or endpoint list]
- Mark complete when: All components built, routing works, mock API integrated

Agent 2 - Backend API Development:
- Build Express.js API for [app name]
- Implement endpoints: [list with specs]
- Tech stack: Node.js, Express, TypeScript, Prisma
- Output directory: /backend
- Database schema: [schema definition]
- API contract (must implement): [OpenAPI spec]
- Mark complete when: All endpoints working, input validation added, unit tests pass

Agent 3 - Database Setup:
- Setup PostgreSQL database for [app name]
- Create schema: [tables and relationships]
- Write migrations using: [migration tool]
- Create seed data for: [entities]
- Output directory: /database
- Mark complete when: Migrations run successfully, seed data loads, schema documented
```

### Step 4: Monitor Agent Progress

While agents work:
- **Track completion**: Monitor which agents have finished
- **Identify blockers**: Watch for agents that get stuck or encounter errors
- **Check contract adherence**: Ensure agents are following the defined interfaces
- **Prepare for integration**: Collect outputs from completed agents

Do NOT intervene unless an agent is clearly blocked or violating contracts.

### Step 5: Collect Agent Outputs

When agents complete, gather their work:
- **Code files**: Collect all source code from each agent
- **Documentation**: Gather README files, API docs, schema docs
- **Configuration**: Collect environment templates, config files
- **Tests**: Gather all test files and test reports
- **Dependencies**: Collect package.json, requirements.txt, etc.

Organize outputs by component for the integration phase.

### Step 6: Validate Contract Compliance

Before integration, verify each component follows the contracts:
- **API endpoints**: Do they match the defined specification?
- **Database schema**: Does it match the plan?
- **Data formats**: Do request/response bodies match?
- **Configuration**: Are environment variables consistent?

If contracts are violated, identify the discrepancies and either fix them or update dependent components.

### Step 7: Prepare for Integration

Set up for the component-integrator skill:
- **Create integration checklist**: List all connection points between components
- **Document component locations**: Where each agent's code lives
- **List integration tasks**: What needs to be connected (frontend to API, API to DB, etc.)
- **Identify potential issues**: CORS, authentication, database connections, etc.

Hand off to the component-integrator skill with this integration package.

## Best Practices

### Launch ALL Agents in Parallel

Critical for efficiency:
- Launch ALL agents in ONE message with multiple Task tool calls
- Do not wait for one agent to finish before starting others
- Typical deployment: 3-6 agents for most applications
- Maximum parallelism: 8-10 agents for complex systems

Example:
```
Launching 4 parallel development agents in a single message:
[Task tool call 1: Frontend agent]
[Task tool call 2: Backend agent]
[Task tool call 3: Database agent]
[Task tool call 4: Auth agent]
```

### Provide Complete Context to Each Agent

Each agent should be fully autonomous:
- Include the full tech stack specification
- Provide complete API/schema contracts
- Specify exact file paths and directory structure
- Include code examples for complex patterns
- List all dependencies to install
- Define clear completion criteria

Agents should not need to ask clarifying questions - the prompt should be comprehensive.

### Use Strict Interface Contracts

The key to successful parallel development:
- Define API contracts BEFORE launching agents (use OpenAPI, GraphQL schemas, etc.)
- Specify exact database schemas with all fields and types
- Document event formats for real-time features
- Create TypeScript interfaces or similar for type safety

Agents must adhere strictly to these contracts for integration to succeed.

### Organize Code by Component

Choose an organization strategy:
- **Monorepo**: All components in one repo with `/frontend`, `/backend`, `/database` directories
- **Multi-repo**: Separate repos per component (more complex but better separation)
- **Hybrid**: Monorepo with clear component boundaries

Ensure agents know where to create files and don't conflict.

### Handle Shared Dependencies

For shared code (types, utilities, constants):
- Create a `/shared` or `/common` directory
- Define shared contracts there first
- Have agents import from shared location
- Consider using workspace features (npm/yarn workspaces, Lerna)

### Plan for Different Completion Times

Agents finish at different rates:
- Frontend might finish before backend
- Database setup is usually fastest
- Complex business logic takes longer

Don't wait for all agents - collect and validate outputs as they complete.

## Common Parallel Configurations

### Small Application (3 agents)
- Agent 1: Frontend UI
- Agent 2: Backend API + Database
- Agent 3: Infrastructure + Deployment

### Medium Application (5 agents)
- Agent 1: Frontend UI
- Agent 2: Backend API
- Agent 3: Database schema + migrations
- Agent 4: Authentication service
- Agent 5: Infrastructure + CI/CD

### Large Application (7-8 agents)
- Agent 1: Frontend UI components
- Agent 2: Frontend state management + routing
- Agent 3: Backend API endpoints
- Agent 4: Backend business logic + services
- Agent 5: Database schema + migrations
- Agent 6: Authentication + authorization
- Agent 7: Real-time features (WebSocket/SSE)
- Agent 8: Infrastructure + deployment + monitoring

### Microservices Application (10+ agents)
- 1 agent per microservice
- 1 agent for shared infrastructure
- 1 agent for API gateway
- 1 agent for frontend

## Handling Agent Failures

If an agent fails or gets stuck:
1. **Analyze the error**: What went wrong?
2. **Check contract compliance**: Did the agent misunderstand the interface?
3. **Provide clarification**: Re-launch with more specific instructions
4. **Update other agents if needed**: If contract needs to change
5. **Document the issue**: Prevent similar failures

## Stack-Specific Considerations

### Frontend Frameworks

**React**:
- Agent needs: React, TypeScript, state management library, UI library
- Common tasks: Component creation, routing, API integration, state management
- Mock API: Use MSW (Mock Service Worker) or simple fetch mocks

**Vue**:
- Agent needs: Vue, TypeScript, Vuex/Pinia, Vue Router
- Common tasks: Component creation, Vuex stores, routing, API integration

**Angular**:
- Agent needs: Angular CLI, TypeScript, RxJS
- Common tasks: Module creation, services, components, routing

### Backend Frameworks

**Node.js/Express**:
- Agent needs: Express, TypeScript, ORM (Prisma/TypeORM), validation library
- Common tasks: Route creation, middleware, controllers, database integration

**.NET**:
- Agent needs: ASP.NET Core, Entity Framework, C#
- Common tasks: Controllers, services, repositories, dependency injection

**Python/Django**:
- Agent needs: Django, Django REST Framework, database library
- Common tasks: Apps, models, views, serializers, URLs

### Database

**PostgreSQL/MySQL**:
- Agent needs: Migration tool (Prisma, Knex, Alembic), schema definition
- Tasks: Create migrations, seed data, indexes

**MongoDB**:
- Agent needs: Mongoose or native driver, schema definition
- Tasks: Define schemas, create indexes, seed data

## Example Usage

**User**: "Execute this plan with parallel agents" [provides implementation plan]

**Deployment Process**:
1. Review plan and extract:
   - 4 parallel components: Frontend, Backend API, Database, Auth service
   - API contracts defined
   - Database schema specified
   - Tech stack: React + Express + PostgreSQL

2. Prepare workspace:
   - Create monorepo structure
   - Initialize Git
   - Create `/shared` directory with TypeScript interfaces
   - Setup root package.json

3. Launch 4 agents in parallel (SINGLE message):
   - **Frontend Agent**: Build React app using API contract, output to `/frontend`
   - **Backend Agent**: Build Express API implementing contract, output to `/backend`
   - **Database Agent**: Create PostgreSQL schema + migrations, output to `/database`
   - **Auth Agent**: Build JWT authentication service, output to `/auth`

4. Monitor and collect outputs as agents complete

5. Validate contract compliance:
   - Check API endpoints match specification
   - Verify database schema correctness
   - Test authentication flow

6. Prepare integration package with checklist:
   - Connect frontend to backend API
   - Connect backend to database
   - Integrate auth service
   - Setup environment variables
   - Test end-to-end flows

7. Hand off to component-integrator skill

## Integration with Other Skills

Workflow sequence:
1. **enterprise-app-researcher**: Research technology options
2. **enterprise-app-planner**: Create detailed implementation plan
3. **parallel-deployer**: Execute plan with parallel agents (this skill)
4. **component-integrator**: Combine components into working application

## Notes

- Parallel development is most effective with clear contracts
- Always launch agents in ONE message for true parallelism
- Monitor for contract violations early
- Don't over-parallelize - 3-6 agents is usually optimal
- Reserve integration time - parallel components need connection work
- Document what each agent built for easier integration
