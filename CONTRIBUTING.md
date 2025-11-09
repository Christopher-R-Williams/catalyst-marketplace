# Contributing to Catalyst

Thank you for your interest in contributing to **Catalyst**! This guide will help you understand the contribution process.

## Overview

This repository contains the **Catalyst** plugin with four interconnected Claude skills for rapid full-stack development:
- `ignite` 🔥 - Research & Discovery
- `architect` 🏗️ - Plan & Design
- `deploy` ⚡ - Build in Parallel
- `ship` 🚀 - Integrate & Launch

## Development Workflow

### 1. Fork and Clone
```bash
git clone https://github.com/[your-username]/catalyst-marketplace.git
cd catalyst-marketplace
```

### 2. Create a Feature Branch
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### 3. Make Your Changes

#### Modifying Existing Skills
- Edit the SKILL.md files in the skill directories
- Maintain the structure: YAML frontmatter + Markdown content
- Follow the existing writing style (imperative/infinitive form)
- Update proactive trigger descriptions if changing behavior

#### Adding New Skills
```bash
# Use the skill-creator init script
python ~/.claude/plugins/marketplaces/anthropic-agent-skills/skill-creator/scripts/init_skill.py your-skill-name --path .
```

#### Adding Resources
- Templates → `[skill-name]/assets/templates/`
- References → `[skill-name]/references/`
- Scripts → `[skill-name]/scripts/`

### 4. Test Your Changes

Before committing:
1. **Validate the skill**:
```bash
python ~/.claude/plugins/marketplaces/anthropic-agent-skills/skill-creator/scripts/package_skill.py ./your-skill-name
```

2. **Test the skill in Claude Code**:
- Package the skill
- Install it in your Claude environment
- Test with real use cases
- Verify proactive triggering works

### 5. Commit Your Changes

Follow conventional commit format:
```bash
git add .
git commit -m "feat: add template assets to architect skill"
# or
git commit -m "fix: correct API contract example in deploy"
# or
git commit -m "docs: improve integration troubleshooting guide"
```

Commit types:
- `feat:` New features or enhancements
- `fix:` Bug fixes
- `docs:` Documentation changes
- `refactor:` Code restructuring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

### 6. Push to Your Fork
```bash
git push origin feature/your-feature-name
```

### 7. Create a Pull Request

1. Go to the original repository on GitHub
2. Click "New Pull Request"
3. Select your branch
4. Fill out the PR template (see below)

## Pull Request Guidelines

### PR Title Format
```
[type]: Brief description

Examples:
feat: Add Docker templates to ship skill
fix: Correct CORS configuration in integration guide
docs: Update workflow diagram with new skill
```

### PR Description Template
```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Documentation update
- [ ] Refactoring
- [ ] Performance improvement

## Changes Made
- Bullet point list of changes
- Be specific and clear

## Testing Done
- How you tested these changes
- Example use cases verified

## Related Issues
Closes #[issue number]

## Checklist
- [ ] I have tested these changes
- [ ] Documentation is updated
- [ ] SKILL.md follows the style guide
- [ ] Skills pass validation
- [ ] Proactive triggers are updated if behavior changed
```

## Automated Claude Code Review

All pull requests are automatically reviewed by Claude Code using the `claude-pr-review` workflow. Claude will:

✅ **Review for**:
- Code quality and best practices
- Documentation completeness
- Consistency with existing skills
- Proper YAML frontmatter format
- Clear proactive trigger descriptions
- Workflow integration correctness
- Example accuracy and usefulness

🤖 **Claude's review will**:
- Appear as a comment on your PR
- Provide specific suggestions for improvement
- Highlight any issues or concerns
- Approve if everything looks good

📝 **Responding to Claude's review**:
- Address all concerns in the review
- Make requested changes
- Reply to Claude's comments if you disagree
- Request re-review when ready

## Coding Standards

### SKILL.md Structure
```markdown
---
name: skill-name
description: PROACTIVELY use when [triggers]. [What it does]. [Stack-agnostic note].
---

# Skill Name

Brief overview

## Purpose

2-3 sentences

## IMPORTANT: Proactive Usage

**Automatic triggers**
**Example triggers**
**Actions to take**

## When to Use This Skill

Detailed list

## How to Use This Skill

Step-by-step instructions

## Best Practices

Guidelines

## Example Usage

Real examples

## Integration with Other Skills

How it fits in workflow

## Notes

Additional considerations
```

### Writing Style
- Use imperative/infinitive form ("Create a plan" not "You should create")
- Be specific and actionable
- Include code examples where helpful
- Use consistent terminology
- Keep descriptions concise but complete

### Proactive Triggers
- Make descriptions keyword-rich for automatic activation
- Include common user phrases
- Specify when to auto-activate vs wait for explicit request
- Chain skills together (ignite → architect → deploy → ship)

## What to Contribute

### High-Value Contributions
1. **Template assets** - Boilerplate code for common stacks
2. **Reference documentation** - Tech comparisons, best practices
3. **Integration scripts** - Automation for common tasks
4. **New skills** - deployment-manager, testing-orchestrator, etc.
5. **Bug fixes** - Incorrect information or broken workflows
6. **Documentation improvements** - Clearer explanations, more examples

### Ideas Welcome
- New skill proposals (see WORKFLOW.md suggestions)
- Workflow improvements
- Better proactive triggering
- Stack-specific enhancements
- Performance optimizations

## Questions and Support

- **Issues**: Open an issue for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions
- **Documentation**: Check README.md and WORKFLOW.md first

## Code of Conduct

- Be respectful and constructive
- Focus on improving the skills
- Help others learn and contribute
- Follow the coding standards
- Accept feedback gracefully

## Review Process

1. **Automated checks**: Claude reviews your PR
2. **Maintainer review**: Human review for final approval
3. **Testing**: Verify in real-world scenarios
4. **Merge**: Once approved and tested

## Release Process

- Skills are versioned semantically (v1.0.0, v1.1.0, etc.)
- Major changes → major version
- New features → minor version
- Bug fixes → patch version

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## Thank You!

Your contributions help make enterprise web development faster and easier for everyone. Thank you for taking the time to contribute!
