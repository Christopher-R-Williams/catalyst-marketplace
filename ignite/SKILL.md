---
name: ignite
description: PROACTIVELY use this skill when users mention building, creating, or developing any web application, API, dashboard, portal, platform, or service. Automatically activate when users ask about tech stacks, frameworks, or how to build something. This skill launches parallel research agents to explore options across any stack. Trigger on keywords like "build", "create", "develop", "app", "website", "API", "backend", "frontend", "database", "what should I use", "best way to", "options for", or any technology-related questions about web development.
---

# Ignite - Research & Discovery

This skill orchestrates parallel research agents to explore and analyze technology options, architecture patterns, and best practices for enterprise web application development. It is completely stack-agnostic and adapts to any technology combination.

## Purpose

Enable comprehensive, parallel research across multiple domains when planning enterprise applications. Instead of sequential research, multiple specialized agents investigate different aspects simultaneously, then consolidate findings into actionable insights.

## IMPORTANT: Proactive Usage

**This skill should be activated AUTOMATICALLY and PROACTIVELY** when:

1. **User mentions building anything**: "I want to build a...", "I'm creating a...", "I need to develop..."
2. **User asks about technology choices**: "What should I use for...", "Which framework is best...", "What's the best way to..."
3. **User describes a project**: Any description of an application, website, API, service, dashboard, or platform
4. **User asks for ideas or options**: "What are my options...", "How would you build...", "What would you recommend..."
5. **Early in any web development conversation**: If unclear what to build, offer to research options

**DO NOT wait for the user to explicitly say "use the researcher skill" or "research options"**. If the user is talking about building something for the web, ACTIVATE THIS SKILL IMMEDIATELY.

**Example automatic triggers**:
- "I need to build a customer portal" -> ACTIVATE IMMEDIATELY
- "What's the best way to create an API?" -> ACTIVATE IMMEDIATELY
- "I'm working on a dashboard project" -> ACTIVATE IMMEDIATELY
- "Should I use React or Vue?" -> ACTIVATE IMMEDIATELY
- "I want to add real-time features" -> ACTIVATE IMMEDIATELY

After activating, ask clarifying questions about requirements, then launch parallel research agents.

## When to Use This Skill

Use this skill when users need to:
- Brainstorm technology stack options for a new enterprise application
- Compare different architectural approaches (monolith vs microservices, REST vs GraphQL, etc.)
- Research best practices for specific enterprise features (authentication, real-time updates, reporting, etc.)
- Evaluate third-party services and integrations
- Understand trade-offs between different technology choices
- Gather information before creating an implementation plan

Trigger phrases include:
- "Help me research tech stacks for..."
- "What are my options for building..."
- "Compare different approaches for..."
- "I need ideas for implementing..."
- "What's the best way to build..."

## How to Use This Skill

### Step 1: Understand the Research Scope

Ask clarifying questions to understand what needs to be researched:
- What type of application? (customer portal, admin dashboard, e-commerce, etc.)
- What features are required? (auth, real-time updates, file uploads, reporting, etc.)
- Any existing constraints? (must use specific cloud provider, integrate with legacy systems, etc.)
- Any preferences? (prefer open-source, specific languages/frameworks, etc.)

### Step 2: Identify Research Domains

Break down the research into parallel domains. Common domains include:
- Frontend frameworks and libraries
- Backend frameworks and architectures
- Database options and data modeling approaches
- Authentication and authorization strategies
- Real-time communication solutions
- File storage and CDN options
- API design patterns
- Deployment and infrastructure options
- Third-party service integrations
- Security best practices
- Performance optimization strategies
- Testing strategies
- **Cost analysis and pricing models**
- **Security and compliance requirements**
- **Performance benchmarks and scalability**
- **Developer ecosystem and hiring availability**
- **Migration paths from existing systems**

### Step 3: Launch Parallel Research Agents

Use the Task tool to launch multiple research agents in parallel. Each agent should focus on a specific domain. Launch ALL agents in a SINGLE message using multiple Task tool calls.

Example:
```
Launching 4 parallel research agents:
1. Frontend research agent - exploring React, Vue, Angular, and Svelte options
2. Backend research agent - comparing Node.js, .NET, Python, and Java frameworks
3. Database research agent - evaluating PostgreSQL, MongoDB, and other options
4. Auth research agent - investigating authentication solutions
```

For each agent, provide a detailed prompt that includes:
- The specific domain to research
- The application context and requirements
- What information to gather (pros/cons, use cases, integration requirements, learning curve, etc.)
- What format to return findings in

### Step 4: Consolidate Findings

After all research agents complete, consolidate their findings into a structured report that includes:
- Summary of each technology option with pros/cons
- Recommendations based on the user's requirements
- Trade-offs between different approaches
- Links to documentation and resources
- Estimated complexity and learning curve
- Integration considerations
- **Cost analysis**: Infrastructure costs, licensing, third-party services
- **Security assessment**: Built-in security features, common vulnerabilities, compliance support
- **Performance benchmarks**: Request latency, throughput, resource usage
- **Developer ecosystem**: Community size, job market, learning resources
- **Migration considerations**: Effort required to migrate from existing systems
- **Scalability analysis**: Horizontal/vertical scaling capabilities, limitations

### Step 5: Present Options to User

Present the consolidated findings in a clear, structured format. Use tables, bullet points, and sections to make the information scannable. Always include:
- Top recommendations with justification
- Alternative options with their trade-offs
- Next steps (usually creating an implementation plan)

## Best Practices

### Research Agent Prompts

When creating research agent prompts, be specific about:
- What to research (technologies, patterns, best practices)
- What criteria to evaluate (performance, scalability, developer experience, community support, cost)
- What format to return (structured comparison, ranked list, pros/cons table)
- Application context (enterprise vs startup, team size, timeline)

### Parallel Efficiency

Launch as many research agents as reasonable in parallel:
- For simple projects: 3-5 agents (frontend, backend, database, auth, deployment)
- For complex projects: 6-10 agents (add domains like real-time, file storage, monitoring, CI/CD)
- Always launch in a SINGLE message with multiple Task tool calls

### Stack-Agnostic Approach

Never assume a specific tech stack. Always:
- Ask about preferences if not stated
- Present multiple options across different paradigms
- Explain trade-offs objectively
- Consider the user's team expertise and timeline
- Research both popular and emerging solutions

### Research Depth

Calibrate research depth based on user needs:
- Quick exploration: High-level comparison of 3-5 options
- Medium depth: Detailed pros/cons, use cases, and integration examples
- Deep dive: Architecture patterns, performance benchmarks, security considerations, code examples

## Example Usage

**User**: "I need to build a customer portal with real-time notifications and file uploads. What are my options?"

**Research Process**:
1. Launch 5 parallel agents:
   - Frontend agent: Research SPA frameworks with real-time capabilities
   - Backend agent: Compare frameworks with WebSocket/SSE support
   - Database agent: Evaluate options for user data and file metadata
   - Real-time agent: Research WebSocket, SSE, and push notification services
   - Storage agent: Compare file storage solutions (S3, Azure Blob, etc.)

2. Consolidate findings into recommendations:
   - Present 2-3 complete stack options (e.g., React + Node.js + PostgreSQL + Socket.io + S3)
   - Explain trade-offs
   - Provide cost estimates
   - Suggest MVP approach

3. Ask user which approach they prefer before creating implementation plan

## Integration with Other Skills

This skill works best when combined with:
- **enterprise-app-planner**: After research, use the planner to create detailed implementation plans
- **parallel-deployer**: The planner creates plans that the deployer executes with parallel agents
- Research findings inform the planning and deployment process

## Output Format

Structure research findings as:

```markdown
# Research Findings: [Project Name]

## Executive Summary
- Top recommendation with key justification
- Estimated timeline and complexity
- Critical considerations
- Total cost estimate (monthly infrastructure + development)

## Technology Stack Options

### Option 1: [Stack Name] (Recommended)
**Stack**: Frontend + Backend + Database + Infrastructure
**Pros**: ...
**Cons**: ...
**Best for**: ...
**Estimated development cost**: ...
**Monthly infrastructure cost**: $X-Y (scales to $Z at 100k users)
**Security rating**: ⭐⭐⭐⭐⭐
**Performance**: X req/sec, Y ms latency
**Learning curve**: Low/Medium/High
**Developer availability**: High/Medium/Low

### Option 2: [Stack Name] (Alternative)
[Same structure]

## Detailed Analysis

### Cost Breakdown
| Component | Option 1 | Option 2 | Option 3 |
|-----------|----------|----------|----------|
| Hosting | $X/mo | $Y/mo | $Z/mo |
| Database | $X/mo | $Y/mo | $Z/mo |
| Services | $X/mo | $Y/mo | $Z/mo |
| **Total** | **$X/mo** | **$Y/mo** | **$Z/mo** |

### Security Assessment
- Built-in security features
- Common vulnerabilities and mitigations
- Compliance support (GDPR, SOC2, HIPAA)
- Authentication/authorization options
- Data encryption capabilities

### Performance Benchmarks
- Request throughput (req/sec)
- Average response latency
- Resource usage (CPU, memory)
- Concurrent user capacity
- Database query performance

### Developer Ecosystem
- Community size and activity
- Available jobs/hiring difficulty
- Learning resources and documentation
- Third-party packages/plugins
- Long-term maintenance outlook

## Domain-Specific Findings

### Frontend
- Comparison of frameworks
- Recommendations

### Backend
- Comparison of frameworks
- Recommendations

[Continue for each domain]

## Migration Considerations
- Effort to migrate from existing system (if applicable)
- Data migration complexity
- Downtime requirements
- Rollback strategy

## Next Steps
1. Review options and select preferred approach
2. Create detailed implementation plan
3. Begin development with parallel deployment
```

## Notes

- Always prioritize user requirements over popular trends
- Consider total cost of ownership (development time, hosting costs, maintenance)
- Factor in team expertise and hiring availability
- Research should be actionable, not just informational
- When uncertain about requirements, ask before researching
