# Quick Start - Your First App in 5 Minutes

Get from zero to a working application in 5 minutes with Catalyst.

---

## Prerequisites

✓ Claude Code installed
✓ That's it!

---

## Step 1: Install Catalyst (30 seconds)

```bash
# In Claude Code
/plugin install catalyst
```

**Restart Claude Code** to activate the plugin.

---

## Step 2: Start Building (1 minute)

Tell Claude what you want to build:

```
I want to build a simple todo list app with:
- Add/edit/delete tasks
- Mark tasks as complete
- Local storage persistence

Use React and keep it simple.
```

**What happens:**
- 🔥 Ignite activates → researches options (or skips if you specified stack)
- 🏗️ Architect activates → creates implementation plan
- ⚡ Deploy activates → builds the app in parallel
- 🚀 Ship activates → integrates everything

---

## Step 3: Review the Plan (30 seconds)

Catalyst will show you an implementation plan:

```markdown
## Implementation Plan

**Frontend:** React + Vite
**State:** useState + localStorage
**Components:** 3 parallel agents
- TaskList component
- TaskForm component
- App integration

Approve to proceed?
```

**Say:** "Looks good, build it!"

---

## Step 4: Wait for Build (2-3 minutes)

Catalyst launches parallel agents to build your app:

```
🔄 Agent 1: Building TaskList component...
🔄 Agent 2: Building TaskForm component...
🔄 Agent 3: Setting up App integration...

✅ All components built!
```

---

## Step 5: Run Your App (30 seconds)

```bash
# Navigate to your project
cd todo-app

# Install dependencies
npm install

# Start development server
npm run dev
```

**Open:** http://localhost:5173

**You now have a working todo app!** 🎉

---

## What You Built

```
todo-app/
├── src/
│   ├── components/
│   │   ├── TaskList.jsx
│   │   └── TaskForm.jsx
│   ├── App.jsx
│   └── main.jsx
├── package.json
└── vite.config.js
```

**Features:**
- ✅ Add tasks
- ✅ Edit tasks
- ✅ Delete tasks
- ✅ Mark complete
- ✅ Persistent storage
- ✅ Responsive design

---

## Next Steps

### Enhance Your App

```
Add these features:
- Due dates for tasks
- Categories/tags
- Search and filter
- Dark mode
```

Catalyst will help you add features incrementally!

### Try a More Complex App

```
Build an e-commerce store with:
- Product catalog
- Shopping cart
- Stripe checkout
- User authentication

Use MERN stack.
```

### Explore Examples

Check out `/examples/` for complete workflows:
- E-commerce platform
- Task management (coming soon)
- Blog/CMS (coming soon)

### Learn the Workflow

Read [WORKFLOW.md](WORKFLOW.md) to understand:
- How Ignite researches options
- How Architect creates plans
- How Deploy orchestrates parallel agents
- How Ship integrates components

---

## Troubleshooting

### Plugin doesn't activate
```bash
# Restart Claude Code
# Check installation
/plugin list
```

### Skills don't trigger automatically
```
# Be explicit
"Use the Ignite skill to research tech stacks"
```

### Build errors
```bash
# Check Node version
node --version  # Should be 18+

# Clean install
rm -rf node_modules package-lock.json
npm install
```

### Can't find my app
```bash
# Check current directory
pwd

# List files
ls -la
```

---

## Tips for Success

### 1. Be Specific
```
❌ "Build me an app"
✅ "Build a todo app with React, local storage, and dark mode"
```

### 2. State Your Stack (if you have preferences)
```
"Use Next.js and PostgreSQL"
"Prefer Vue over React"
"I want to use MongoDB"
```

### 3. Review Plans Before Building
```
# Always check the Architect output
# Confirm:
- Database schema makes sense
- API endpoints are complete
- Component breakdown is logical
```

### 4. Test Incrementally
```
# After Ship phase
1. Run the app
2. Test each feature
3. Check console for errors
4. Fix any issues before adding more
```

---

## Common First-Time Questions

**Q: Do I need to know how to code?**
A: Basic understanding helps, but Catalyst handles the heavy lifting.

**Q: Can I use my own tech stack?**
A: Absolutely! Just specify your preferences.

**Q: How long does it really take?**
A: Simple apps: 5-10 minutes. Complex apps: 1-2 hours.

**Q: What if I want to change something after it's built?**
A: Just ask! "Change the color scheme to blue" or "Add a search feature"

**Q: Is the code production-ready?**
A: It's a solid starting point. Review, test, and add production concerns (monitoring, error handling, security).

---

## Real Example: Todo App

### Your Prompt (10 seconds)
```
Build a todo list app with React.
Features: add, edit, delete, mark complete.
Use local storage.
```

### Catalyst Responds (2 minutes)

**Ignite** (skipped - you specified React)

**Architect** creates plan:
```markdown
## Components
1. TaskList - displays todos
2. TaskForm - add/edit form
3. TaskItem - individual task
4. App - state management

## Data Structure
{
  id: string,
  text: string,
  completed: boolean,
  createdAt: timestamp
}

## localStorage API
- getTasks()
- saveTasks(tasks)
- addTask(task)
- updateTask(id, updates)
- deleteTask(id)
```

**Deploy** builds (2 minutes):
- 3 agents work in parallel
- Each builds assigned components
- Follow the plan exactly

**Ship** integrates (1 minute):
- Connects components
- Tests localStorage
- Verifies all features work

### Result (3 minutes total)
Working app with 200 lines of code!

---

## Success! What's Next?

### Share Your Creation
- Show us what you built!
- Open a discussion
- Contribute examples

### Level Up
- Try more complex projects
- Explore different stacks
- Read full documentation

### Get Help
- [FAQ](FAQ.md) - Common questions
- [SUPPORT](SUPPORT.md) - Get help
- [Issues](https://github.com/Christopher-R-Williams/catalyst-marketplace/issues) - Report bugs

---

## Summary: 5-Minute Checklist

- [ ] Install Catalyst (`/plugin install catalyst`)
- [ ] Restart Claude Code
- [ ] Tell Claude what to build
- [ ] Approve the plan
- [ ] Wait 2-3 minutes
- [ ] Run `npm install && npm run dev`
- [ ] Enjoy your app! 🎉

---

**Ready?** [Install Catalyst](README.md#installation) and start building!

**Questions?** Check the [FAQ](FAQ.md) or [open an issue](https://github.com/Christopher-R-Williams/catalyst-marketplace/issues).
