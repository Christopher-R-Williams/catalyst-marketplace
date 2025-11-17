# Frequently Asked Questions (FAQ)

Common questions about Catalyst and quick answers.

---

## General Questions

### What is Catalyst?

Catalyst is a Claude Code plugin that accelerates full-stack web development through parallel agent workflows. It provides 4 skills (Ignite, Architect, Deploy, Ship) that work together to help you build enterprise applications 10x faster.

### How does Catalyst work?

Catalyst uses a 4-phase workflow:
1. **Ignite** - Research tech stack options with parallel agents
2. **Architect** - Create detailed implementation plans
3. **Deploy** - Build components simultaneously with parallel agents
4. **Ship** - Integrate everything into a working application

### Is Catalyst free?

Yes! Catalyst is open-source and free to use under the MIT license.

### What technologies does Catalyst support?

Catalyst is stack-agnostic and works with any technology combination:
- **Frontend**: React, Vue, Angular, Svelte, Next.js
- **Backend**: Node.js, .NET, Python, Java, Go, Rust
- **Database**: PostgreSQL, MySQL, MongoDB, DynamoDB
- **Cloud**: AWS, Azure, GCP, Vercel, Railway

---

## Installation & Setup

### How do I install Catalyst?

```bash
# In Claude Code
/plugin install catalyst
```

Or manually:
```bash
git clone https://github.com/Christopher-R-Williams/catalyst-marketplace.git
/plugin add /path/to/catalyst-marketplace
```

### The plugin doesn't appear after installation. What do I do?

1. Restart Claude Code
2. Verify `.claude-plugin/plugin.json` exists in the repository
3. Run validation: `npm run validate`
4. Check Claude Code logs for errors

### Can I use Catalyst with an existing project?

Yes! Catalyst can help with:
- Adding new features to existing apps
- Refactoring components
- Improving architecture
- Creating deployment pipelines

However, it's most effective for new projects or greenfield features.

### Do I need to install anything besides Claude Code?

No external dependencies for the plugin itself. However:
- You'll need Node.js/npm to run validation scripts (optional)
- Your project will need its own dependencies based on chosen stack

---

## Using Skills

### Which skill should I use?

**Quick guide:**
- Starting new project → **Ignite**
- Have stack, need plan → **Architect**
- Have plan, ready to code → **Deploy**
- Components built, need integration → **Ship**

See [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for detailed flowchart.

### Do I have to use all 4 skills?

No! Use what you need:
- Skip Ignite if you already know your stack
- Skip Architect if you have an existing plan
- Use Ship alone for integration help

The full workflow is recommended for best results.

### Skills don't activate automatically. Why?

Check these:
1. YAML frontmatter is valid in SKILL.md files
2. Description includes "PROACTIVELY" keyword
3. You're using trigger phrases (e.g., "I want to build...")
4. Restart Claude Code session if needed

### Can I customize the skills?

Yes! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- Modifying skill prompts
- Adding new examples
- Creating custom templates
- Contributing improvements

---

## Technical Questions

### How many parallel agents can I run?

Typical deployments use 3-6 agents. More agents aren't always better - quality depends on:
- Clear API contracts
- Proper workspace separation
- Well-defined component boundaries

### How long does a full workflow take?

- **Ignite**: 5-10 minutes (research)
- **Architect**: 10-20 minutes (planning)
- **Deploy**: 15-30 minutes (parallel build)
- **Ship**: 10-20 minutes (integration)

**Total**: ~1-2 hours for a complete application

### Can parallel agents actually work simultaneously?

Yes! The Deploy skill launches all agents in a single message with multiple Task tool calls, ensuring true parallelism. Agents work independently using shared API contracts.

### What makes Catalyst different from just asking Claude to code?

**Catalyst provides:**
- Structured workflow preventing missed steps
- Parallel execution (vs sequential)
- Contract-driven development
- Proactive skill activation
- Battle-tested templates and examples
- Clear component boundaries

**vs. Regular prompts:**
- Sequential development
- No standardized approach
- Easy to miss integration details
- No systematic parallel execution

### Can I use Catalyst for production applications?

Yes! Catalyst-generated code is production-ready when you:
- Review and test all generated code
- Add proper error handling
- Implement security best practices
- Use environment variables for secrets
- Add monitoring and logging
- Follow deployment checklists in Ship phase

---

## Troubleshooting

### Agents aren't working in parallel

**Common causes:**
1. Agents launched in separate messages (must be ONE message)
2. API contracts not clearly defined
3. Workspace overlap causing conflicts

**Solution:**
- Ensure Deploy skill launches all agents together
- Review Architect output for clear contracts
- Verify distinct workspace directories

### Integration fails in Ship phase

**Common causes:**
1. API contract mismatches
2. Missing environment variables
3. CORS not configured
4. Database schema inconsistencies

**Solution:**
- Validate API responses match contracts
- Check `.env` files in both frontend/backend
- Configure CORS to allow frontend origin
- Run database migrations

### Skills produce inconsistent output

**Common causes:**
1. Vague requirements
2. Insufficient context
3. Unclear stack preferences

**Solution:**
- Be specific in initial prompt
- Provide clear requirements
- State tech stack preferences upfront
- Use examples from `/examples/` directory

### "Module not found" errors after deployment

**Common causes:**
1. Dependencies not installed
2. Wrong Node version
3. Build step missing

**Solution:**
```bash
# Install dependencies
npm install

# Check Node version
node --version  # Should match project requirements

# Run build if needed
npm run build
```

### Database connection fails

**Common causes:**
1. Wrong connection string
2. Database not running
3. Firewall blocking connection

**Solution:**
```bash
# Check environment variable
echo $DATABASE_URL

# Test connection
# PostgreSQL
psql $DATABASE_URL

# MongoDB
mongosh $MONGODB_URI
```

---

## Best Practices

### How should I structure my prompts?

**Good prompts:**
```
"I want to build a task management app with:
- Real-time collaboration
- Email notifications
- File attachments
- User authentication
Prefer: React, Node.js, PostgreSQL"
```

**Poor prompts:**
```
"Build me an app"
"Make a website"
```

**Key elements:**
- Specific feature list
- Tech stack preferences (if any)
- Key requirements
- Scale/complexity indicators

### Should I review generated code?

**Always review:**
- API endpoints for security vulnerabilities
- Database queries for SQL injection risks
- Authentication/authorization logic
- Environment variable usage
- Error handling

**Use security tools:**
- ESLint security rules
- npm audit
- Snyk
- SonarQube

### How do I handle API rate limits?

**During research (Ignite):**
- Research agents don't make external API calls
- No rate limit concerns

**During development:**
- Use test/sandbox API keys
- Implement rate limiting in your app
- Cache frequent requests

### What if I want a different technology than suggested?

Tell Claude explicitly:
```
"I want to use Vue instead of React"
"Use Django instead of Express"
"Prefer PostgreSQL over MongoDB"
```

Catalyst adapts to any stack - preferences override suggestions.

---

## Performance & Scaling

### Can Catalyst handle large applications?

Yes! Tips for large apps:
- Break into smaller feature sets
- Run Deploy phase multiple times
- Use monorepo structure
- Implement micro-frontends/microservices

### How do I scale beyond initial deployment?

**Horizontal scaling:**
- Use Docker containers (see `/templates/docker/`)
- Implement load balancing
- Use managed databases
- Add caching (Redis)

**Code organization:**
- Follow modular architecture
- Implement clear API boundaries
- Use shared type definitions
- Maintain comprehensive tests

### Does Catalyst work for microservices?

Yes! Architect skill can plan microservice architectures:
- Define service boundaries
- Specify inter-service communication
- Plan API gateways
- Design deployment strategy

Each microservice can be a parallel agent in Deploy phase.

---

## Community & Support

### How do I get help?

1. **Check FAQ** (you're here!)
2. **Read [SUPPORT.md](SUPPORT.md)**
3. **Search [existing issues](https://github.com/Christopher-R-Williams/catalyst-marketplace/issues)**
4. **Open a new issue** with issue template
5. **Join discussions** (coming soon)

### How can I contribute?

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Code contributions
- New examples
- Documentation improvements
- Bug reports
- Feature suggestions

### Where can I share my Catalyst-built projects?

We'd love to see what you build!
- Open a "Show and Tell" discussion
- Add to community examples
- Tweet with #CatalystPlugin

### How do I report security vulnerabilities?

See [SECURITY.md](SECURITY.md) for responsible disclosure process.

**Do not** report security issues in public issues.

---

## Advanced Usage

### Can I create custom skills?

Yes! See [Skill Development Guide](docs/skill-development.md):
1. Create new directory with SKILL.md
2. Define YAML frontmatter
3. Write skill documentation
4. Add to `plugin.json`
5. Test with validation scripts

### How do I add new templates?

1. Create template file in `templates/` directory
2. Follow existing template structure
3. Add documentation
4. Submit pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Can I integrate Catalyst with CI/CD?

Yes! See `/templates/ci-cd/` for:
- GitHub Actions workflows
- GitLab CI templates
- Deployment automation
- Testing pipelines

### How do I use Catalyst in a team?

**Best practices:**
- Share API contracts early
- Use same skill versions
- Maintain shared templates
- Document customizations
- Version control everything

**Team workflow:**
1. Team lead runs Ignite & Architect
2. Share implementation plan
3. Divide components among team
4. Each member runs Deploy for their components
5. Integrate with Ship phase together

---

## Comparison

### Catalyst vs. GitHub Copilot?

**Catalyst:**
- Workflow-oriented
- Multi-agent orchestration
- Architecture and planning
- End-to-end application building

**Copilot:**
- Code completion
- Single-file assistance
- IDE integration
- Line-by-line suggestions

They're complementary! Use both for best results.

### Catalyst vs. Cursor AI?

**Catalyst:**
- Claude Code plugin
- 4-phase structured workflow
- Parallel agent execution
- Complete application focus

**Cursor:**
- Full IDE replacement
- Chat-based coding assistant
- File editing focus
- General-purpose coding help

Different tools for different workflows.

### Catalyst vs. manual Claude prompts?

**Catalyst advantages:**
- Systematic approach
- Proactive skill activation
- Built-in best practices
- Templates and examples
- Parallel execution
- Contract-driven development

**Manual prompts:**
- More flexible
- No structure
- Easy to miss steps
- Sequential only

Catalyst = Structured, repeatable, faster
Manual = Flexible but slower

---

## Troubleshooting Common Errors

### "YAML frontmatter validation failed"

```bash
# Run validation
npm run validate

# Check SKILL.md files start with ---
head -1 ignite/SKILL.md

# Verify YAML syntax
python -c "import yaml; yaml.safe_load(open('ignite/SKILL.md').read().split('---')[1])"
```

### "Cannot find module 'anthropic'"

```bash
# Install dependencies for validation scripts
cd .github/scripts
pip install anthropic pyyaml
```

### "Permission denied" when running scripts

```bash
# Make scripts executable
chmod +x .github/hooks/validate-skills.sh
chmod +x .github/hooks/validate-skills.py
```

---

## Still Have Questions?

- 📖 [Full Documentation](README.md)
- 🆘 [Support Guide](SUPPORT.md)
- 💬 [Open an Issue](https://github.com/Christopher-R-Williams/catalyst-marketplace/issues/new/choose)
- 🚀 [Quick Reference](QUICK_REFERENCE.md)

---

**Can't find your question?** [Open a discussion](https://github.com/Christopher-R-Williams/catalyst-marketplace/discussions) or [create an issue](https://github.com/Christopher-R-Williams/catalyst-marketplace/issues/new/choose).
