# CI/CD Templates

Continuous Integration and Deployment workflows for automated testing and deployment.

## Available Templates

| Template | Platform | Purpose |
|----------|----------|---------|
| `github-actions-nodejs.yml` | GitHub Actions | Full CI/CD for Node.js full-stack apps |

---

## Quick Start

### GitHub Actions

1. **Copy template to your project:**
```bash
mkdir -p .github/workflows
cp github-actions-nodejs.yml /path/to/your/project/.github/workflows/ci-cd.yml
```

2. **Configure secrets** (Repository Settings → Secrets and variables → Actions):
```
Required:
- VITE_API_URL
- VERCEL_TOKEN (if using Vercel)
- RAILWAY_TOKEN (if using Railway)

Optional:
- SNYK_TOKEN (security scanning)
- SLACK_WEBHOOK (deployment notifications)
```

3. **Push to trigger:**
```bash
git add .
git commit -m "Add CI/CD workflow"
git push origin main
```

---

## What's Included

### Lint & Format
- ESLint checks
- Prettier formatting
- Runs on all PRs and pushes

### Testing
- **Frontend tests** (Jest/Vitest)
- **Backend tests** (with MongoDB & Redis)
- **E2E tests** (Playwright)
- Code coverage reporting

### Building
- **Frontend build** (Vite/Next.js)
- **Backend build** (TypeScript compilation)
- Artifact uploads

### Security
- npm audit
- Snyk vulnerability scanning
- Dependency checks

### Deployment
- **Staging** (on `develop` branch)
- **Production** (on `main` branch)
- Automated releases

---

## Workflows

### On Pull Request
```
1. Lint & Format checks
2. Run all tests
3. Build verification
4. Security scan
```

### On Push to develop
```
1. All PR checks
2. Deploy to staging
3. Run smoke tests
```

### On Push to main
```
1. All checks
2. Deploy to production
3. Create GitHub release
4. Send notifications
```

---

## Customization

### Change Node Version
```yaml
env:
  NODE_VERSION: '20.x'  # Update here
```

### Add/Remove Jobs
```yaml
jobs:
  my-custom-job:
    name: My Custom Job
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # Your steps
```

### Modify Test Services
```yaml
services:
  postgres:  # Add PostgreSQL instead of MongoDB
    image: postgres:15
    ports:
      - 5432:5432
    env:
      POSTGRES_PASSWORD: test
```

### Change Deployment Platform

**Netlify:**
```yaml
- name: Deploy to Netlify
  uses: nwtgck/actions-netlify@v2
  with:
    publish-dir: './frontend/dist'
    production-deploy: true
  env:
    NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_TOKEN }}
    NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

**AWS:**
```yaml
- name: Deploy to AWS
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: us-east-1
```

---

## Best Practices

### 1. Use Caching
```yaml
- uses: actions/setup-node@v4
  with:
    cache: 'npm'  # Speeds up installs
```

### 2. Fail Fast
```yaml
strategy:
  fail-fast: true  # Stop all jobs if one fails
```

### 3. Matrix Testing
```yaml
strategy:
  matrix:
    node-version: [18, 20]
    os: [ubuntu-latest, windows-latest]
```

### 4. Required Status Checks
In GitHub: Settings → Branches → Add branch protection rule
- Require status checks to pass
- Require branches to be up to date

---

## Troubleshooting

### Workflow doesn't run
```bash
# Check workflow file is in correct location
ls .github/workflows/

# Validate YAML syntax
yamllint .github/workflows/ci-cd.yml
```

### Tests fail in CI but pass locally
```bash
# Common causes:
1. Missing environment variables
2. Different Node versions
3. Database connection issues

# Fix:
- Add all required env vars to workflow
- Match Node version
- Check service configuration
```

### Deployment fails
```bash
# Check secrets are set
- Go to Settings → Secrets
- Verify all required secrets exist
- Check secret names match workflow
```

### Coverage upload fails
```bash
# Ensure Codecov token is set (if using private repo)
env:
  CODECOV_TOKEN: ${{ secrets.CODECOV_TOKEN }}
```

---

## Common Patterns

### Run on Schedule
```yaml
on:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight
```

### Manual Trigger
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy'
        required: true
        default: 'staging'
```

### Conditional Jobs
```yaml
if: github.ref == 'refs/heads/main'
```

### Dependent Jobs
```yaml
needs: [build, test]  # Wait for these jobs
```

---

## Optimization Tips

### 1. Parallel Jobs
```yaml
jobs:
  test-frontend:
    # Runs in parallel with:
  test-backend:
```

### 2. Skip CI
```bash
git commit -m "docs: update README [skip ci]"
```

### 3. Cache Dependencies
```yaml
- uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
```

### 4. Reusable Workflows
```yaml
# .github/workflows/reusable-test.yml
on:
  workflow_call:
```

---

## Monitoring

### View Workflow Runs
```
GitHub → Actions tab → Select workflow
```

### Debug Failed Jobs
```yaml
- name: Debug
  if: failure()
  run: |
    echo "Job failed!"
    env
    ls -la
```

### Enable Debug Logging
```
Repository secrets:
ACTIONS_STEP_DEBUG=true
ACTIONS_RUNNER_DEBUG=true
```

---

## Cost Optimization

### GitHub Actions Minutes
- Public repos: Unlimited
- Private repos: 2,000 minutes/month (free tier)

### Reduce Usage:
```yaml
# Run only on specific paths
on:
  push:
    paths:
      - 'src/**'
      - 'package.json'
```

```yaml
# Skip redundant jobs
if: "!contains(github.event.head_commit.message, 'skip ci')"
```

---

## Security

### 1. Use Secrets
```yaml
env:
  API_KEY: ${{ secrets.API_KEY }}  # ✅ Good
  API_KEY: abc123  # ❌ Never hardcode
```

### 2. Limit Permissions
```yaml
permissions:
  contents: read  # Minimal permissions
```

### 3. Pin Actions Versions
```yaml
uses: actions/checkout@v4  # ✅ Pin to major version
uses: actions/checkout@main  # ❌ Unpredictable
```

### 4. Scan Dependencies
```yaml
- run: npm audit
- run: snyk test
```

---

## Next Steps

1. **Add badges to README:**
```markdown
![CI/CD](https://github.com/user/repo/actions/workflows/ci-cd.yml/badge.svg)
```

2. **Set up branch protection:**
- Require status checks
- Require pull request reviews
- Enforce restrictions

3. **Add deployment slots:**
- Staging environment
- Preview deployments for PRs
- Production with approval gates

4. **Monitor and improve:**
- Track workflow run times
- Optimize slow jobs
- Add more test coverage

---

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
- [Security Hardening](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)

---

**Need help?** See [SUPPORT.md](../../SUPPORT.md) or open an issue.
