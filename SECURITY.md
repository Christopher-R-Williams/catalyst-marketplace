# Security Policy

## Supported Versions

We release patches for security vulnerabilities for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

### 1. **Do Not** Create a Public Issue

Please **do not** report security vulnerabilities through public GitHub issues.

### 2. Report Privately

Send a detailed report to: **christopher.r.williams@outlook.com**

Include:
- **Description** of the vulnerability
- **Steps to reproduce** the issue
- **Potential impact** assessment
- **Suggested fix** (if you have one)
- **Your contact information**

### 3. Response Timeline

- **Initial Response:** Within 48 hours
- **Status Update:** Within 7 days
- **Fix Timeline:** Depends on severity
  - **Critical:** 1-7 days
  - **High:** 7-30 days
  - **Medium:** 30-90 days
  - **Low:** Best effort

### 4. Disclosure Process

1. **Report Received:** We acknowledge your report
2. **Investigation:** We verify and assess the vulnerability
3. **Fix Development:** We develop and test a patch
4. **Release:** We release the security patch
5. **Public Disclosure:** After patch is released, we publicly disclose:
   - Nature of the vulnerability (if appropriate)
   - Credit to reporter (if desired)
   - Fixed version number

## Security Considerations for Users

### Plugin Security

Catalyst is a Claude Code plugin that:
- **Reads/writes files:** Skills may create, read, or modify files in your project
- **Uses APIs:** Skills may call external APIs during research
- **Executes commands:** Skills may run shell commands for setup/deployment

### Best Practices

1. **Review Generated Code**
   - Always review code before committing
   - Check for hardcoded secrets or sensitive data
   - Validate API endpoints and database queries

2. **Environment Variables**
   - Never commit `.env` files
   - Use `.env.example` for templates
   - Rotate secrets regularly

3. **API Keys**
   - Store in environment variables
   - Use separate keys for dev/prod
   - Rotate after team member changes

4. **Dependencies**
   - Review generated `package.json` dependencies
   - Check for known vulnerabilities
   - Keep dependencies updated

5. **Database Credentials**
   - Never hardcode in source
   - Use environment variables
   - Restrict database user permissions

6. **Parallel Agents**
   - Review agent outputs before integration
   - Validate API contracts are secure
   - Check for injection vulnerabilities

## Known Security Considerations

### Skill Execution

**Risk:** Skills execute with full file system access

**Mitigation:**
- Review skill code before installation
- Skills are open source and auditable
- No network access except documented APIs

### Generated Code

**Risk:** Generated code may have vulnerabilities

**Mitigation:**
- Always review generated code
- Run security linters (ESLint, Bandit, etc.)
- Perform security testing
- Follow secure coding practices

### API Contracts

**Risk:** Poorly defined contracts may lead to vulnerabilities

**Mitigation:**
- Validate all inputs
- Use parameterized queries
- Implement rate limiting
- Add authentication/authorization

## Secure Development with Catalyst

### Architect Phase
- Design authentication/authorization early
- Plan for input validation
- Include security in API contracts
- Consider OWASP Top 10

### Deploy Phase
- Validate all user inputs
- Use ORMs to prevent SQL injection
- Hash passwords with bcrypt
- Implement rate limiting
- Add CORS configuration

### Ship Phase
- Enable HTTPS in production
- Set secure HTTP headers
- Validate environment variables
- Review authentication flows
- Test for common vulnerabilities

## Security Features in Templates

Our templates include security best practices:

### API Templates
- Input validation schemas
- Rate limiting configuration
- JWT authentication
- CORS setup
- Error handling (without leaking info)

### Database Templates
- Parameterized queries
- Password hashing
- UUID primary keys
- CHECK constraints
- Role-based access

### Integration Examples
- Environment variable management
- Secrets handling
- HTTPS enforcement
- Security headers

## Vulnerability Disclosure

When we fix a security vulnerability, we:

1. Release a patch version
2. Update CHANGELOG.md
3. Create a GitHub Security Advisory
4. Credit the reporter (if desired)
5. Provide upgrade guidance

## Security Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP API Security](https://owasp.org/www-project-api-security/)
- [Node.js Security Best Practices](https://nodejs.org/en/docs/guides/security/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

## Scope

### In Scope
- Catalyst plugin code
- Skill definitions
- Template code
- CI/CD workflows
- Documentation examples

### Out of Scope
- Applications built using Catalyst
- Third-party dependencies
- Claude Code platform itself
- User-specific configurations

## Hall of Fame

We recognize security researchers who help us:

- *No reports yet*

Thank you to everyone who helps keep Catalyst secure!

## Questions?

For security questions (non-vulnerabilities), contact:
**christopher.r.williams@outlook.com**

---

**Thank you for helping keep Catalyst and our community safe!**
