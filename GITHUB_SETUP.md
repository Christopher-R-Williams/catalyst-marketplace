# GitHub Repository Setup Guide

This guide will help you push the skills repository to GitHub and enable automated Claude Code PR reviews.

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `enterprise-web-app-skills` (or your preferred name)
3. Description: "Claude skills for enterprise web application development with parallel agent workflows"
4. Visibility: Public or Private (your choice)
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
cd "C:\Users\Christopher Williams\.claude\skills"

# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/enterprise-web-app-skills.git

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
3. Go to "Actions" tab
4. You should see the "Claude Code PR Review" workflow listed

## Step 5: Test the PR Review Workflow

Create a test PR to verify Claude reviews work:

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
