# Catalyst ⚡

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/Christopher-R-Williams/catalyst-marketplace/releases)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-purple.svg)](https://github.com/Christopher-R-Williams/catalyst-marketplace)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/Christopher-R-Williams/catalyst-marketplace/blob/main/CONTRIBUTING.md)

**Build enterprise web apps 10x faster.** A catalyst for rapid full-stack development using parallel agent workflows.

## What is Catalyst?

Catalyst is a comprehensive Claude Code plugin that transforms how you build web applications. Instead of building sequentially, Catalyst orchestrates **parallel agents** that research, plan, and build simultaneously - dramatically accelerating development from idea to production-ready application.

## The Catalyst Workflow

Seven powerful skills that work together seamlessly:

### Core Workflow
1. **🔥 Ignite** (`ignite`) - Research tech stacks with parallel agents, cost analysis, and security assessment
2. **🏗️ Architect** (`architect`) - Generate detailed plans with Mermaid diagrams and OpenAPI specs
3. **⚡ Deploy** (`deploy`) - Build multiple components simultaneously with quality checks
4. **🚀 Ship** (`ship`) - Integrate everything with comprehensive testing and security scanning

### Production Readiness
5. **📊 Monitor** (`monitor`) - Setup logging, error tracking, and observability infrastructure
6. **🔒 Secure** (`secure`) - Perform security audits, vulnerability scanning, and OWASP compliance
7. **✅ Test** (`test`) - Generate comprehensive tests with >80% coverage and automation

**The Result:** Production-ready applications in hours, not days. From idea to fully tested, secure, monitored deployment.

## Skills Included

### 1. 🔥 Ignite (Research & Discovery)

**Purpose**: Launch parallel research agents to brainstorm and explore technology options.

**Use when**:
- Starting a new project and need to evaluate tech stacks
- Comparing different architectural approaches
- Researching best practices for specific features
- Need to understand trade-offs between technologies

**Output**: Structured research findings with recommendations, pros/cons, and next steps.

**Example**:
```
User: "I need to build a customer portal with real-time notifications. Research my options."

Claude: Launches 5 parallel research agents:
- Frontend frameworks (React, Vue, Angular, Svelte)
- Backend frameworks (Node.js, .NET, Python, Java)
- Database options (PostgreSQL, MongoDB, etc.)
- Real-time solutions (WebSocket, SSE, push services)
- File storage (S3, Azure Blob, etc.)

Result: Comprehensive comparison with 2-3 recommended complete stack options
```

### 2. 🏗️ Architect (Plan & Design)

**Purpose**: Create detailed implementation plans optimized for parallel development.

**Use when**:
- Research is complete and tech stack is selected
- Have clear requirements and ready to start building
- Need to break down a complex feature into components
- Want to structure work for parallel execution

**Output**: Detailed plan with architecture, database schema, API contracts, and component breakdown.

**Example**:
```
User: "Create a plan for building a task management app with React, Node.js, and PostgreSQL."

Claude: Creates a comprehensive plan including:
- Architecture diagram
- Database schema (users, tasks, assignments tables)
- API contracts (10 REST endpoints with exact request/response formats)
- Component breakdown (4 parallel components)
- Integration strategy
- Testing approach

Result: Ready-to-execute plan for parallel deployment
```

### 3. ⚡ Deploy (Build in Parallel)

**Purpose**: Execute plans by launching multiple specialized agents working simultaneously.

**Use when**:
- Implementation plan is approved and ready to execute
- Want to build components in parallel to save time
- Have a plan with clearly defined component interfaces
- Ready for actual development work

**Output**: Complete, independently developed components ready for integration.

**Example**:
```
User: "Execute this plan with parallel agents."

Claude: Launches 4 agents in a SINGLE message:
- Agent 1: Build React frontend (uses mock APIs)
- Agent 2: Build Express backend API
- Agent 3: Setup PostgreSQL database (schema + migrations)
- Agent 4: Build authentication service

Result: 4 independently working components built simultaneously
```

### 4. 🚀 Ship (Integrate & Launch)

**Purpose**: Connect independently built components into a cohesive application and ship it.

**Use when**:
- Parallel deployment is complete
- Have multiple components that need connecting
- Ready to create the final integrated application
- Need to configure CORS, auth, environment variables

**Output**: Fully integrated, working application with end-to-end testing.

**Example**:
```
User: "Integrate the components."

Claude: Performs integration:
- Connects frontend to backend API
- Configures CORS
- Connects backend to database
- Sets up authentication flow
- Creates .env configuration
- Tests end-to-end
- Creates developer documentation

Result: Complete, working application ready to run
```

## Complete Workflow Example

Here's a full workflow from idea to working application:

### Step 1: Ignite (Research & Discovery)
```
You: "I want to build an e-commerce platform with product catalog, shopping cart,
     and checkout. Research the best tech stacks."

Claude: Launches parallel research agents to explore options
→ Result: 3 recommended stack combinations with detailed comparisons
```

### Step 2: Architect (Plan & Design)
```
You: "I'll go with React + Node.js + PostgreSQL. Create an implementation plan."

Claude: Creates detailed plan with:
- Database schema for products, users, carts, orders
- API contracts for all endpoints
- Component breakdown (Frontend, Backend API, Database, Payment Service, Auth)
- Parallel development phases

→ Result: Complete implementation plan
```

### Step 3: Deploy (Build in Parallel)
```
You: "Execute this plan with parallel agents."

Claude: Launches 5 agents in parallel:
- Frontend: React app with product browsing, cart, checkout UI
- Backend: Express API with all endpoints
- Database: PostgreSQL schema, migrations, seed data
- Payment: Stripe integration service
- Auth: JWT authentication service

→ Result: 5 independently working components
```

### Step 4: Ship (Integrate & Launch)
```
You: "Integrate all the components."

Claude: Integrates everything:
- Connects frontend to backend
- Connects backend to database
- Configures authentication across all components
- Sets up Stripe payment flow
- Tests complete checkout process
- Creates setup documentation

→ Result: Working e-commerce application
```

## Key Benefits

### Stack-Agnostic Design
All skills adapt to any technology combination:
- Frontend: React, Vue, Angular, Svelte, or any other
- Backend: Node.js, .NET, Python, Java, or any other
- Database: PostgreSQL, MySQL, MongoDB, or any other
- Cloud: AWS, Azure, GCP, or self-hosted

### Parallel Efficiency
Traditional approach: Build components sequentially (8-12 hours)
With parallel agents: Build simultaneously (2-3 hours)

### Comprehensive Coverage
- Research to deployment in one unified workflow
- Best practices built into each skill
- Security considerations included
- Testing strategies integrated

### Autonomous Execution
Once plans are approved, agents work independently with minimal supervision.

## Installation

### Quick Install (Recommended)

One command to install Catalyst:

```bash
# In Claude Code (VS Code):
/plugin install catalyst
```

That's it! Catalyst is now active and ready to accelerate your development. ⚡

### Alternative Installation Methods

**Via Marketplace:**

```bash
/plugin marketplace add Christopher-R-Williams/catalyst-marketplace
/plugin install catalyst
```

**Clone for Local Development:**

```bash
git clone https://github.com/Christopher-R-Williams/catalyst-marketplace.git
/plugin add /path/to/catalyst-marketplace
```

**VS Code Settings:**

Add to your `settings.json`:

```json
{
  "claude.plugins": [
    "catalyst"
  ]
}
```

### Getting Started

After installation, **Catalyst automatically activates** when you start a new Claude Code session. You'll see a welcome message with:

- Quick overview of the Catalyst workflow
- Example prompts to get started immediately
- Tips for using each phase of the workflow

**Just tell Claude what you want to build** and the Catalyst workflow begins automatically!

Examples:
- "I want to build a task management app with React and Node.js"
- "Help me create an e-commerce platform"
- "Build a customer portal with authentication"

### Verification

Verify Catalyst is installed:

```bash
/plugin list        # Should show "catalyst"
/skills list        # Should show: ignite, architect, deploy, ship
```

### Updating

Get the latest features:

```bash
/plugin update catalyst
```

## Usage Tips

### 1. Start with Research
Even if you know your stack, use the researcher to validate your choices and discover alternatives.

### 2. Approve Plans Before Deployment
Review the implementation plan carefully. Changes after parallel deployment begins are costly.

### 3. Trust the Parallel Process
Don't micromanage individual agents. Let them work independently - they follow the defined contracts.

### 4. Budget Integration Time
Integration always takes time. Plan for 20-30% of development time for connecting components.

### 5. Use the Full Workflow
These skills are designed to work together. Using them in sequence maximizes benefits.

## Common Use Cases

### Starting a New Enterprise Project
1. Research → Plan → Deploy → Integrate
2. Full workflow from idea to MVP in hours instead of days

### Adding a Major Feature
1. Research approaches → Plan feature → Deploy in parallel → Integrate with existing code
2. Use **deploy** to build new feature modules simultaneously

### Refactoring or Modernizing
1. Research modern alternatives → Plan migration → Deploy new architecture in parallel → Integrate gradually
2. Build new system alongside old one

### Prototyping and MVP Development
1. Quick research → Minimal plan → Fast parallel deployment → Basic integration
2. Validate ideas rapidly with working prototypes

## Advanced Patterns

### Microservices Development
Use **deploy** to build each microservice simultaneously:
- 1 agent per service
- 1 agent for API gateway
- 1 agent for shared infrastructure
- Deploy 10+ services in parallel

### Full-Stack Monorepo
Use **deploy** with organized workspace:
- Frontend agent → /frontend
- Backend agent → /backend
- Database agent → /database
- Shared types → /shared

### Multi-Platform Applications
Research and deploy web + mobile simultaneously:
- Web frontend agent
- Mobile app agent (React Native/Flutter)
- Shared backend API agent
- Single source of truth for business logic

## Troubleshooting

### "Agents aren't launching in parallel"
Make sure Claude launches all agents in a SINGLE message with multiple Task tool calls.

### "Components don't integrate properly"
Check that all agents followed the API contracts defined in the plan. Most issues are contract violations.

### "Integration failing with CORS errors"
The **ship** skill should handle this, but verify CORS is configured for your frontend origin.

### "Database connection issues"
Verify connection strings in .env file match your database configuration.

## Best Practices

1. **Clear Requirements**: More specific requirements = better research and planning
2. **Detailed Contracts**: API and schema definitions must be complete before deployment
3. **Parallel Limits**: 3-6 agents is optimal for most projects
4. **Version Control**: Use git from the start, commit after each phase
5. **Incremental Testing**: Test each integration point before moving to the next

## Stack-Specific Examples

### MERN Stack (MongoDB, Express, React, Node.js)
Research → Plan with MERN → Deploy (React + Express + MongoDB agents) → Integrate

### .NET + Angular + SQL Server
Research → Plan with .NET stack → Deploy (Angular + .NET API + SQL Server agents) → Integrate

### Python Django + Vue + PostgreSQL
Research → Plan with Python stack → Deploy (Vue + Django + PostgreSQL agents) → Integrate

### Serverless (Next.js + AWS Lambda + DynamoDB)
Research → Plan with serverless → Deploy (Next.js + Lambda functions + DynamoDB agents) → Integrate

## Support and Iteration

These skills are designed to be comprehensive on their own, but they can be enhanced:
- Add reference files for your company's tech stack preferences
- Add scripts for common deployment tasks
- Customize templates for your organization's standards

## License and Usage

These skills are created for enterprise web application development. Use them for:
- Personal projects
- Professional development
- Team projects
- Learning and education

---

## Quick Start

Ready to build something?

```
"I want to build a [type of application] with [key features].
 Help me research the best tech stack options."
```

Claude will activate the **Ignite** skill and start the Catalyst workflow - your parallel development journey! 🔥
