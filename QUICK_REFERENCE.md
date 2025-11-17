# Catalyst Quick Reference

One-page reference for the Catalyst workflow.

---

## 🚀 The 4-Phase Workflow

```
Research → Plan → Build → Integrate
 Ignite   Architect  Deploy    Ship
```

---

## 🔥 Ignite (Research & Discovery)

**When to Use:** Start of new project, exploring options

**Triggers:**
- "I want to build..."
- "What should I use for..."
- "Help me research..."

**Output:**
- 2-3 tech stack options
- Pros/cons for each
- Recommended choice

**Example Prompts:**
- "I want to build an e-commerce platform"
- "What's the best stack for a real-time dashboard?"
- "Research options for authentication"

---

## 🏗️ Architect (Plan & Design)

**When to Use:** After choosing stack, ready to plan

**Triggers:**
- "Create a plan..."
- "Let's build..."
- After Ignite completes

**Output:**
- Architecture diagram
- Complete database schema
- Full API contracts (all endpoints)
- Component breakdown (3-6 parallel tracks)
- Integration strategy

**What Gets Planned:**
- All database tables/collections
- Every API endpoint (request/response)
- Frontend component breakdown
- Backend service breakdown
- External service integrations

---

## ⚡ Deploy (Build in Parallel)

**When to Use:** Have a plan, ready to code

**Triggers:**
- "Build it..."
- "Implement this..."
- After plan approval

**How it Works:**
- Launches 3-6 agents simultaneously
- Each agent builds assigned component
- All agents follow shared API contracts
- Work completes in parallel (~15-30 mins)

**Common Agent Assignments:**
- Frontend UI Agent
- Backend API Agent
- Database Agent
- Authentication Agent
- Payments/Integration Agent

**Critical:** All agents launched in ONE message for true parallelism

---

## 🚀 Ship (Integrate & Launch)

**When to Use:** Components built, need integration

**Triggers:**
- "Integrate..."
- "Connect everything..."
- After Deploy completes

**Integration Checklist:**
- ✅ Environment configuration (.env files)
- ✅ CORS setup
- ✅ API client configuration
- ✅ Authentication flow
- ✅ Database connection
- ✅ External services (Stripe, etc.)
- ✅ End-to-end testing
- ✅ Error handling

**Output:** Working application ready to deploy

---

## 📊 Tech Stack Support

**Stack-Agnostic:** Works with ANY combination

| Category | Supported |
|----------|-----------|
| **Frontend** | React, Vue, Angular, Svelte, Next.js, Nuxt |
| **Backend** | Node.js, .NET, Python, Java, Go, Rust |
| **Database** | PostgreSQL, MySQL, MongoDB, DynamoDB |
| **Cloud** | AWS, Azure, GCP, Vercel, Railway |

---

## 🎯 Key Principles

### 1. Parallel Development
Multiple agents work simultaneously on different components

### 2. Contract-Driven
Clear API and database contracts defined upfront

### 3. Stack-Agnostic
Works with any technology combination

### 4. Proactive Activation
Skills trigger automatically based on your intent

---

## 💬 Example Conversation Flow

```
You: "I want to build a task management app"

Claude (Ignite): Researches tech stacks...
        Presents 3 options (MERN, Next.js, Django)

You: "Let's use MERN"

Claude (Architect): Creates implementation plan...
         - MongoDB schemas
         - Express API contracts
         - React component breakdown
         - 4 parallel development tracks

You: "Looks good, build it"

Claude (Deploy): Launches 4 agents in parallel...
        - Frontend Agent
        - Backend API Agent
        - Database Agent
        - Auth Agent
        (All complete in ~20 mins)

Claude (Ship): Integrates all components...
       - Connects frontend to backend
       - Sets up database
       - Configures auth
       - Tests E2E flows

Result: Working task management app ✅
```

---

## 📁 Project Structure Created

```
your-app/
├── frontend/          # React/Vue/Angular
│   ├── src/
│   ├── public/
│   └── package.json
├── backend/           # Express/.NET/Django
│   ├── src/
│   ├── tests/
│   └── package.json
├── shared/            # API contracts, types
│   ├── types/
│   └── contracts/
└── docs/
    ├── api/
    └── setup/
```

---

## ⚡ Quick Commands

```bash
# Validate skills
npm run validate

# Install Catalyst
/plugin install catalyst

# Check examples
cd examples/
```

---

## 🆘 Common Issues

**Skill doesn't activate?**
- Check YAML frontmatter
- Verify "PROACTIVELY" in description
- Restart Claude Code session

**Agents not working in parallel?**
- Ensure all agents launched in ONE message
- Check API contracts are clear
- Verify workspace separation

**Integration failing?**
- Check environment variables
- Verify CORS configuration
- Test API endpoints individually

---

## 📚 More Resources

- **Full Docs:** [README.md](README.md)
- **Workflow Guide:** [WORKFLOW.md](WORKFLOW.md)
- **Examples:** [examples/](examples/)
- **Templates:** [templates/](templates/)
- **Support:** [SUPPORT.md](SUPPORT.md)

---

## 💡 Pro Tips

1. **Be specific** in research phase - saves time later
2. **Review the plan** before deploying - changes are easier now
3. **Test contracts** independently before integration
4. **Use examples** as templates for your own projects
5. **Check environment variables** first when debugging

---

**Ready to build?** Just say what you want to create!

```
"I want to build a [your project description]"
```

Catalyst will handle the rest. ⚡
