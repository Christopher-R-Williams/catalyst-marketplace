# Catalyst Workflow Examples

This directory contains real-world examples demonstrating the complete Catalyst workflow for building an e-commerce platform.

---

## 📚 What's Included

### 🔥 Ignite Examples
**Location:** `/examples/ignite/`

Sample research outputs showing parallel agent exploration of technology stacks.

- **e-commerce-research.md** - Comprehensive tech stack research for an e-commerce platform
  - 3 recommended stack options (MERN, Next.js, Enterprise)
  - Detailed comparison of frameworks, databases, and services
  - Pros/cons analysis
  - Next steps for architecture phase

**Use Cases:**
- See what quality research output looks like
- Understand how to present multiple options
- Learn how to structure findings for decision-making

---

### 🏗️ Architect Examples
**Location:** `/examples/architect/`

Detailed implementation plans ready for parallel deployment.

- **e-commerce-plan.md** - Complete implementation plan including:
  - High-level architecture diagram
  - Complete database schemas (5 collections)
  - Full API contracts (20+ endpoints)
  - Component breakdown (5 parallel tracks)
  - Integration points and strategy
  - Development phases
  - Security considerations
  - Success criteria

**Use Cases:**
- Reference for creating your own implementation plans
- See level of detail needed for parallel development
- Understand API contract specifications
- Learn database schema design patterns

---

### ⚡ Deploy Examples
**Location:** `/examples/deploy/`

Parallel agent orchestration prompts and strategies.

- **parallel-agent-prompts.md** - Complete deployment strategy showing:
  - 5 parallel agent prompts
  - Workspace assignments
  - API contracts each agent must follow
  - Success criteria for each component
  - Mock API strategies
  - Validation requirements

**Use Cases:**
- Understand how to structure parallel agent prompts
- See how to assign workspaces and responsibilities
  - Learn contract-driven development approach
- Copy prompt structures for your own projects

---

### 🚀 Ship Examples
**Location:** `/examples/ship/`

Integration checklists and configuration examples.

- **integration-checklist.md** - Complete integration guide including:
  - Component inventory
  - Environment configuration (frontend + backend)
  - CORS setup
  - API client configuration
  - Authentication flow integration
  - Database connection
  - Stripe payment integration
  - Cart integration
  - Order flow
  - Admin dashboard
  - Error handling
  - E2E testing checklist
  - Performance optimization
  - Security checklist
  - Documentation requirements

**Use Cases:**
- Step-by-step integration guide
- Reference for connecting components
- Security and performance checklists
- Testing workflow examples

---

## 🎯 How to Use These Examples

### For Learning
1. **Read in sequence:** Ignite → Architect → Deploy → Ship
2. **Study the progression:** See how research becomes plans, plans become code, code becomes integration
3. **Note the details:** Level of specificity at each phase

### For Your Own Projects
1. **Copy the structure:** Use these as templates
2. **Adapt to your stack:** Replace MERN with your chosen technologies
3. **Adjust scope:** Scale up or down based on project size
4. **Follow the contracts:** Maintain clear API and database contracts

### For Reference
1. **API design:** See REST API patterns
2. **Database schemas:** MongoDB document structure examples
3. **Integration patterns:** Frontend ↔ Backend ↔ Database ↔ External Services
4. **Testing strategies:** E2E flow examples

---

## 🏗️ Example Project: E-Commerce Platform

All examples in this directory follow a **single cohesive project**: A modern e-commerce platform.

### Features
- Product catalog with search and filters
- Shopping cart (guest and registered users)
- Stripe payment processing
- User authentication
- Order management
- Admin dashboard
- Real-time inventory

### Tech Stack (MERN)
- **Frontend:** React + Vite + TailwindCSS + Redux Toolkit
- **Backend:** Node.js + Express + JWT
- **Database:** MongoDB + Mongoose
- **Payments:** Stripe
- **Hosting:** Docker-ready

### Why E-Commerce?
- Complex enough to show parallel development
- Common enough to be relatable
- Demonstrates all Catalyst phases
- Shows integration of multiple services

---

## 📊 Workflow Progression

```
USER REQUEST
"I want to build an e-commerce platform"
           ↓
┌──────────────────────────────────────┐
│  IGNITE: Research & Discovery        │
│  Output: e-commerce-research.md      │
│  • 3 stack options analyzed          │
│  • Pros/cons documented              │
│  • User chooses MERN stack           │
└──────────────────────────────────────┘
           ↓
┌──────────────────────────────────────┐
│  ARCHITECT: Plan & Design            │
│  Output: e-commerce-plan.md          │
│  • Architecture diagram              │
│  • 5 MongoDB collections designed    │
│  • 20+ API endpoints specified       │
│  • 5 parallel components defined     │
│  • Success criteria established      │
└──────────────────────────────────────┘
           ↓
┌──────────────────────────────────────┐
│  DEPLOY: Build in Parallel           │
│  Output: parallel-agent-prompts.md   │
│  • 5 agents launched simultaneously  │
│  • Each builds assigned component    │
│  • All follow shared contracts       │
│  • ~15-30 mins total (in parallel)   │
└──────────────────────────────────────┘
           ↓
┌──────────────────────────────────────┐
│  SHIP: Integrate & Launch            │
│  Output: integration-checklist.md    │
│  • Components connected              │
│  • APIs integrated                   │
│  • Payments tested                   │
│  • E2E flows validated               │
│  • Ready for production              │
└──────────────────────────────────────┘
           ↓
    WORKING APPLICATION
```

---

## 💡 Learning Outcomes

After studying these examples, you'll understand:

1. **Research Quality**
   - How to explore multiple options
   - When to recommend specific technologies
   - How to present findings clearly

2. **Planning Depth**
   - Level of detail needed for parallel work
   - How to design API contracts
   - Database schema best practices
   - Component boundary definition

3. **Parallel Orchestration**
   - How to structure agent prompts
   - Contract-driven development
   - Workspace organization
   - Validation strategies

4. **Integration Process**
   - Environment configuration
   - API client setup
   - Authentication flows
   - Payment integration
   - Testing strategies

---

## 🔗 Related Documentation

- **Main README:** `/README.md` - Plugin overview and installation
- **Workflow Guide:** `/WORKFLOW.md` - Detailed workflow architecture
- **Contributing:** `/CONTRIBUTING.md` - How to add examples
- **Skill Definitions:**
  - `/ignite/SKILL.md`
  - `/architect/SKILL.md`
  - `/deploy/SKILL.md`
  - `/ship/SKILL.md`

---

## 🤝 Contributing Examples

Want to add more examples? Great!

### Example Ideas
- **Blog Platform:** Content management, markdown, comments
- **Dashboard App:** Analytics, charts, real-time data
- **SaaS Application:** Multi-tenant, subscriptions, billing
- **Social Network:** Posts, likes, comments, followers
- **Task Manager:** Teams, projects, boards, tasks

### Guidelines
1. **Follow the 4-phase structure:** Ignite → Architect → Deploy → Ship
2. **Be specific:** Include actual code snippets, schemas, endpoints
3. **Show progression:** Each phase builds on the previous
4. **Include context:** Explain decisions and trade-offs
5. **Use different stacks:** Vary tech choices (Vue, .NET, PostgreSQL, etc.)

### How to Contribute
1. Create directory: `/examples/<your-project>/`
2. Add phase files:
   - `ignite/<project>-research.md`
   - `architect/<project>-plan.md`
   - `deploy/<project>-deployment.md`
   - `ship/<project>-integration.md`
3. Submit pull request
4. See `/CONTRIBUTING.md` for full guidelines

---

## 📖 Additional Resources

### Templates (Coming Soon)
- API contract templates
- Database schema templates
- Docker Compose templates
- Environment variable templates

### Video Walkthroughs (Planned)
- Complete workflow demonstration
- Deep dive into each phase
- Common pitfalls and solutions

### Stack-Specific Examples (Planned)
- Next.js + PostgreSQL + Prisma
- Vue + Django + PostgreSQL
- Angular + .NET + SQL Server
- Svelte + Go + PostgreSQL

---

## 🎓 Quick Start

**New to Catalyst?** Start here:

1. **Read:** `/README.md` - Understand what Catalyst does
2. **Study:** `/WORKFLOW.md` - Learn the 4-phase workflow
3. **Explore:** `/examples/ignite/e-commerce-research.md` - See research output
4. **Dive Deep:** `/examples/architect/e-commerce-plan.md` - Study detailed planning
5. **Understand Deploy:** `/examples/deploy/parallel-agent-prompts.md` - See parallel execution
6. **Learn Integration:** `/examples/ship/integration-checklist.md` - Connect everything

**Ready to build?** Try Catalyst with your own project!

```bash
# Install Catalyst
/plugin install catalyst

# Start building
"I want to build a [your project description]"
```

---

**Need help?** Open an issue at https://github.com/Christopher-R-Williams/catalyst-marketplace/issues
