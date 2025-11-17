# Support

Need help with Catalyst? Here's how to get support.

## Documentation

Before opening an issue, please check our documentation:

- **README:** [README.md](README.md) - Installation and quick start
- **Workflow Guide:** [WORKFLOW.md](WORKFLOW.md) - Detailed workflow architecture
- **Contributing:** [CONTRIBUTING.md](CONTRIBUTING.md) - Development guidelines
- **Examples:** [examples/](examples/) - Real-world usage examples
- **Skills Documentation:**
  - [Ignite](ignite/SKILL.md) - Research & discovery
  - [Architect](architect/SKILL.md) - Planning & design
  - [Deploy](deploy/SKILL.md) - Parallel deployment
  - [Ship](ship/SKILL.md) - Integration & launch

## Getting Help

### 1. Check Existing Issues

Search [existing issues](https://github.com/Christopher-R-Williams/catalyst-marketplace/issues) to see if your question has been answered.

### 2. GitHub Discussions (Coming Soon)

For questions, ideas, and community discussion.

### 3. Create an Issue

If you've found a bug or have a feature request:

**[Open an Issue](https://github.com/Christopher-R-Williams/catalyst-marketplace/issues/new)**

Please include:
- **Clear title** describing the problem
- **Steps to reproduce** (for bugs)
- **Expected behavior**
- **Actual behavior**
- **Environment details:**
  - Claude Code version
  - Operating system
  - Plugin version
- **Screenshots** (if applicable)

## Response Times

This is a community-maintained project:

- **Bug reports:** We aim to respond within 3-5 business days
- **Feature requests:** We'll review and prioritize based on community needs
- **Pull requests:** We try to review within 1 week

## Common Issues

### Installation Problems

**Issue:** Plugin doesn't appear after installation

**Solution:**
1. Restart Claude Code
2. Check plugin is in correct directory
3. Verify `.claude-plugin/plugin.json` exists
4. Run validation: `npm run validate`

---

**Issue:** Skills don't activate automatically

**Solution:**
1. Check YAML frontmatter in SKILL.md files
2. Verify `description` includes "PROACTIVELY"
3. Restart Claude Code session

### Usage Questions

**Issue:** "Which skill should I use?"

**Answer:**
- **Ignite:** Start of new project, exploring options
- **Architect:** After choosing stack, need implementation plan
- **Deploy:** Have a plan, ready to build
- **Ship:** Components built, need integration

---

**Issue:** "How do I customize the skills?"

**Answer:** See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on modifying skills.

### Performance Issues

**Issue:** Parallel agents taking too long

**Solution:**
1. Check agent prompts are specific
2. Verify API contracts are clear
3. Ensure agents have proper workspace separation
4. Review API rate limits

## Feature Requests

We welcome feature requests! Please:

1. Search [existing issues](https://github.com/Christopher-R-Williams/catalyst-marketplace/issues) first
2. Describe the use case clearly
3. Explain why it's valuable
4. Consider contributing a PR

## Security Issues

**Do not report security vulnerabilities in public issues.**

See [SECURITY.md](SECURITY.md) for responsible disclosure process.

## Contributing

Want to help improve Catalyst? See [CONTRIBUTING.md](CONTRIBUTING.md).

## Community Guidelines

- Be respectful and constructive
- Provide enough context in issues
- Follow the code of conduct
- Help others when you can

## Contact

- **GitHub Issues:** https://github.com/Christopher-R-Williams/catalyst-marketplace/issues
- **Repository:** https://github.com/Christopher-R-Williams/catalyst-marketplace

---

**Thank you for using Catalyst!** Your feedback helps make it better for everyone.
