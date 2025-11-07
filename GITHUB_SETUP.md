# Catalyst - Plugin Marketplace Setup Guide

This guide will help you publish **Catalyst** as a Claude Code plugin marketplace on GitHub.

## Overview

**Catalyst** is configured as a **Claude Code plugin marketplace**, providing seamless installation for users:

**For Users:**
- ✅ One-command installation: `/plugin install catalyst`
- ✅ Automatic welcome message via start-session hook
- ✅ All 4 skills in one plugin package
- ✅ Automatic updates via `/plugin update`
- ✅ No manual configuration needed

**For Developers:**
- ✅ Version control for skill development
- ✅ Accept contributions via pull requests
- ✅ Track issues and feature requests
- ✅ Automated PR reviews with Claude (optional)
- ✅ Plugin versioning and release management

**Plugin Structure:**
- `.claude-plugin/plugin.json` - Plugin manifest (named "catalyst")
- `.claude-plugin/marketplace.json` - Marketplace configuration
- `hooks/start-session.md` - Welcome message when users start a session
- `enterprise-app-researcher/` - Research skill
- `enterprise-app-planner/` - Planning skill
- `parallel-deployer/` - Parallel deployment skill
- `component-integrator/` - Integration skill

Each skill directory contains a `SKILL.md` file that Claude Code automatically discovers.

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `skills` (or `catalyst-skills`)
3. Description: "Catalyst - Build enterprise web apps 10x faster with parallel agent workflows"
4. Visibility: **Public** (recommended for easy installation) or Private
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. Click "Create repository"

## Step 2: Add Anthropic API Key to GitHub Secrets

For the automated Claude PR review to work, you need to add your Anthropic API key:

1. Go to your repository on GitHub
2. Click "Settings" tab
3. In the left sidebar, click "Secrets and variables" → "Actions"
4. Click "New repository secret"
5. Name: `ANTHROPIC_API_KEY`
6. Value: Your Anthropic API key (get it from https://console.anthropic.com/)
7. Click "Add secret"

## Step 3: Push to GitHub

Run these commands in your terminal:

```bash
cd "C:\Users\Christopher Williams\DevWorkspace\claude-skills\skills"

# Add remote
git remote add origin https://github.com/Christopher-R-Williams/skills.git

# Check status
git status

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Enterprise web app development skills with Claude PR reviews"

# Push to GitHub
git push -u origin main
```

If you get an error about branch name, use:
```bash
git branch -M main
git push -u origin main
```

## Step 4: Verify Setup

1. Go to your GitHub repository
2. You should see all the files
3. Go to "Actions" tab (if you set up PR reviews)
4. Repository is now ready for distribution

## Step 5: Share Installation Instructions

Users can now install your plugin in Claude Code (VS Code). Share these simple instructions:

### Recommended: Plugin Marketplace Installation

The easiest method for users:

```bash
# In Claude Code (VS Code):
/plugin marketplace add Christopher-R-Williams/skills
/plugin install catalyst
```

### Alternative: Direct Plugin Installation

Install without adding marketplace first:

```bash
# In Claude Code (VS Code):
/plugin install Christopher-R-Williams/skills
```

**After installation**, Catalyst automatically greets users with the start-session hook, explaining the workflow and how to get started.

### For Developers: Clone for Contribution

Contributors can clone for local development:

```bash
# Clone the repository
git clone https://github.com/Christopher-R-Williams/skills.git

# Add as local plugin in Claude Code
/plugin add /path/to/skills
```

### Verification

Users can verify installation:

```bash
# List all installed plugins
/plugin list

# List all available skills
/skills list
```

They should see all 4 skills:
- `enterprise-app-researcher`
- `enterprise-app-planner`
- `parallel-deployer`
- `component-integrator`

## Publishing Updates

When you make improvements to skills:

1. **Make Changes**
   - Edit skill files locally
   - Test thoroughly in Claude Code

2. **Update Version** (in `.claude-plugin/plugin.json`)
   ```json
   {
     "version": "1.1.0"  // Increment version
   }
   ```

3. **Commit and Push**
   ```bash
   git add .
   git commit -m "feat: describe your improvement"
   git push origin main
   ```

4. **Create GitHub Release** (Optional but recommended)
   - Go to GitHub repository → Releases → Draft new release
   - Tag: `v1.1.0` (matching plugin.json version)
   - Title: Release version number
   - Description: Changelog of improvements

5. **Users Update Automatically**
   ```bash
   # Users can update with one command:
   /plugin update catalyst
   ```

### Version Numbering

Follow semantic versioning (semver):
- **Major** (1.0.0 → 2.0.0): Breaking changes
- **Minor** (1.0.0 → 1.1.0): New features, backward compatible
- **Patch** (1.0.0 → 1.0.1): Bug fixes

## Step 6: Test the PR Review Workflow (Optional)

If you set up automated PR reviews, create a test PR to verify Claude reviews work:

```bash
# Create a test branch
git checkout -b test/claude-review

# Make a small change
echo "\n## Test Change" >> README.md

# Commit and push
git add README.md
git commit -m "test: verify Claude PR review workflow"
git push origin test/claude-review
```

Then:
1. Go to your GitHub repository
2. You'll see a prompt to create a pull request
3. Click "Compare & pull request"
4. Fill out the PR template
5. Click "Create pull request"
6. Wait a few moments
7. Claude should post a review comment automatically

## What the Automated Review Does

When you create or update a pull request, the workflow:

1. ✅ Checks out the PR code
2. ✅ Identifies changed files
3. ✅ Validates SKILL.md files
4. ✅ Sends files to Claude for review
5. ✅ Posts comprehensive review as a comment

Claude reviews for:
- YAML frontmatter validity
- Proactive trigger descriptions
- Code quality and best practices
- Documentation completeness
- Integration with other skills
- Stack-agnostic design
- Consistency with project style

## Workflow File Location

The workflow is defined in:
```
.github/workflows/claude-pr-review.yml
```

The review script is:
```
.github/scripts/claude_review.py
```

## Customizing the Workflow

### Change when reviews run

Edit `.github/workflows/claude-pr-review.yml`:

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened]
    paths:
      - '**/*.md'      # Review markdown files
      - '**/*.py'      # Review Python files
      # Add more patterns as needed
```

### Change Claude model

Edit `.github/scripts/claude_review.py`:

```python
message = client.messages.create(
    model="claude-sonnet-4-20250514",  # Change this
    max_tokens=4096,
    messages=[{
        "role": "user",
        "content": prompt
    }]
)
```

### Modify review criteria

Edit the review guidelines in `.github/scripts/claude_review.py`:

```python
prompt = """You are reviewing a pull request...

# Review Guidelines:
- Add your custom criteria here
"""
```

## Troubleshooting

### Workflow doesn't run
- Check that ANTHROPIC_API_KEY secret is set
- Verify the workflow file is in `.github/workflows/`
- Check Actions tab for error messages

### Claude review fails
- Check workflow logs in GitHub Actions
- Verify API key is valid and has credits
- Ensure changed files are accessible

### Review comment doesn't post
- Check GitHub token permissions
- Verify the workflow has `pull-requests: write` permission

## Repository Settings Recommendations

### Branch Protection Rules

1. Go to Settings → Branches
2. Add rule for `main` branch:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass (optional)
   - ✅ Require conversation resolution before merging
   - ✅ Do not allow bypassing the above settings

### GitHub Actions Permissions

1. Go to Settings → Actions → General
2. Workflow permissions:
   - Select "Read and write permissions"
   - ✅ Allow GitHub Actions to create and approve pull requests

## Cost Considerations

Each PR review costs a small amount based on:
- Number of changed files
- Size of files
- Claude API pricing

Estimated cost per review:
- Small PR (1-3 files, <1000 lines): ~$0.01-0.05
- Medium PR (4-10 files, 1000-3000 lines): ~$0.05-0.15
- Large PR (10+ files, 3000+ lines): ~$0.15-0.30

To minimize costs:
- Review locally before creating PR
- Keep PRs focused and small
- Only trigger on important file types

## Benefits

✅ **Automated quality assurance**
✅ **Consistent review standards**
✅ **Faster feedback loop**
✅ **Educational for contributors**
✅ **Reduces maintainer burden**
✅ **24/7 availability**

## Next Steps

After setup:
1. Start contributing improvements
2. Create issues for enhancements
3. Share the skills with others
4. Iterate based on feedback

## Support

If you encounter issues:
1. Check GitHub Actions logs
2. Review this guide again
3. Create an issue in the repository
4. Check Anthropic API status

---

**Happy contributing! 🚀**
