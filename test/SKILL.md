---
name: test
description: PROACTIVELY use this skill during or after deploy/ship phases when users mention "testing", "tests", "coverage", "quality assurance", "QA", "test automation". Automatically activate to ensure code quality through comprehensive unit tests, integration tests, E2E tests, and test automation. Generates tests for untested code and ensures >80% coverage.
---

# Test - Comprehensive Testing & QA

This skill implements comprehensive testing strategies including unit tests, integration tests, E2E tests, and test automation to ensure code quality and reliability.

## Purpose

Ensure application quality through comprehensive testing. Generates missing tests, sets up testing infrastructure, achieves high coverage, and automates testing in CI/CD.

## IMPORTANT: Proactive Usage

**This skill should be activated AUTOMATICALLY and PROACTIVELY** when:

1. **During deployment**: Offer to add tests while building components
2. **After ship**: Ensure comprehensive test coverage before production
3. **User mentions testing**: "Add tests", "Test coverage", "QA", "Quality assurance"
4. **Low coverage detected**: Automatically suggest improving coverage
5. **Production readiness**: Part of production checklist

**DO NOT wait for explicit request**. Proactively suggest: "Let me add comprehensive tests to ensure quality."

**Example automatic triggers**:
- User: "Add tests" -> ACTIVATE IMMEDIATELY
- User: "Check test coverage" -> ACTIVATE IMMEDIATELY
- Low coverage: "Coverage is low, let me add tests" -> ACTIVATE IMMEDIATELY

## When to Use This Skill

Use this skill when:
- Components are built but lack tests
- Test coverage is below 80%
- Need E2E test automation
- Preparing for production
- Want to ensure code quality

## How to Use This Skill

### Step 1: Setup Testing Infrastructure

**Frontend Testing (React/Vue/Angular)**:
- Jest + React Testing Library / Vitest
- Playwright / Cypress for E2E
- MSW for API mocking

**Backend Testing (Node.js/Python/.NET)**:
- Jest / Mocha / Vitest (Node.js)
- pytest (Python)
- xUnit / NUnit (.NET)
- Supertest for API testing

### Step 2: Unit Testing

Generate unit tests for all components:

**React Component Test Example**:
```javascript
import { render, screen, fireEvent } from '@testing-library/react';
import { LoginForm } from './LoginForm';

describe('LoginForm', () => {
  it('renders login form', () => {
    render(<LoginForm />);
    expect(screen.getByLabelText(/email/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument();
  });

  it('submits form with valid data', async () => {
    const onSubmit = jest.fn();
    render(<LoginForm onSubmit={onSubmit} />);

    fireEvent.change(screen.getByLabelText(/email/i), {
      target: { value: 'test@example.com' },
    });
    fireEvent.change(screen.getByLabelText(/password/i), {
      target: { value: 'password123' },
    });
    fireEvent.click(screen.getByText(/sign in/i));

    expect(onSubmit).toHaveBeenCalledWith({
      email: 'test@example.com',
      password: 'password123',
    });
  });
});
```

**Backend Service Test Example**:
```javascript
describe('UserService', () => {
  let userService;
  let mockDb;

  beforeEach(() => {
    mockDb = {
      user: {
        findUnique: jest.fn(),
        create: jest.fn(),
      },
    };
    userService = new UserService(mockDb);
  });

  it('creates a new user', async () => {
    const userData = { email: 'test@example.com', password: 'hashed' };
    mockDb.user.create.mockResolvedValue({ id: 1, ...userData });

    const result = await userService.createUser(userData);

    expect(result).toHaveProperty('id');
    expect(mockDb.user.create).toHaveBeenCalledWith({ data: userData });
  });
});
```

### Step 3: Integration Testing

Test API endpoints with real database:

```javascript
const request = require('supertest');
const app = require('../app');

describe('POST /api/users', () => {
  it('creates a new user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'test@example.com',
        password: 'Password123!',
      })
      .expect(201);

    expect(response.body).toHaveProperty('id');
    expect(response.body.email).toBe('test@example.com');
  });

  it('returns 400 for invalid email', async () => {
    await request(app)
      .post('/api/users')
      .send({
        email: 'invalid-email',
        password: 'Password123!',
      })
      .expect(400);
  });
});
```

### Step 4: E2E Testing

Setup Playwright or Cypress:

**Playwright Example**:
```javascript
import { test, expect } from '@playwright/test';

test('user can login', async ({ page }) => {
  await page.goto('http://localhost:3000');

  await page.fill('input[name="email"]', 'test@example.com');
  await page.fill('input[name="password"]', 'password123');
  await page.click('button[type="submit"]');

  await expect(page).toHaveURL(/dashboard/);
  await expect(page.locator('h1')).toContainText('Dashboard');
});
```

### Step 5: Test Coverage

Generate coverage reports:

```json
{
  "scripts": {
    "test": "jest",
    "test:coverage": "jest --coverage",
    "test:watch": "jest --watch"
  },
  "jest": {
    "coverageThreshold": {
      "global": {
        "branches": 80,
        "functions": 80,
        "lines": 80,
        "statements": 80
      }
    }
  }
}
```

### Step 6: Automated Testing in CI/CD

Add tests to GitHub Actions:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run test:coverage
      - uses: codecov/codecov-action@v3
```

## Testing Checklist

- ✅ Unit tests for all components/functions
- ✅ Integration tests for all API endpoints
- ✅ E2E tests for critical user flows
- ✅ Test coverage >80%
- ✅ Tests run in CI/CD
- ✅ Mocking external dependencies
- ✅ Error case testing
- ✅ Edge case testing
- ✅ Performance testing
- ✅ Accessibility testing

## Notes

- Write tests before production
- Aim for >80% coverage
- Test edge cases and errors
- Mock external dependencies
- Automate in CI/CD
