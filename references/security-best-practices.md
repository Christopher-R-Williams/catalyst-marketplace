# Security Best Practices

Quick reference for security best practices across all phases of development.

## Authentication & Authorization

### Passwords
- ✅ Minimum 8 characters (recommend 12+)
- ✅ Require mix of uppercase, lowercase, numbers, special chars
- ✅ Hash with bcrypt (cost factor ≥12) or Argon2
- ✅ Never store plain text passwords
- ✅ Never log passwords

### Tokens
- ✅ Use JWT for stateless auth
- ✅ Short expiry (15min-24h for access tokens)
- ✅ Long expiry for refresh tokens (7-30 days)
- ✅ Store tokens in httpOnly cookies (web) or secure storage (mobile)
- ✅ Avoid localStorage for sensitive tokens

### Sessions
- ✅ Secure session cookies (httpOnly, secure, sameSite)
- ✅ Session timeout after inactivity
- ✅ Regenerate session ID on login
- ✅ Implement CSRF protection

## Input Validation

### General
- ✅ Validate all user inputs
- ✅ Whitelist allowed values
- ✅ Sanitize HTML content
- ✅ Validate data types
- ✅ Check length limits
- ✅ Reject unexpected fields

### Common Patterns
```javascript
// Email
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// URL
const urlRegex = /^https?:\/\/.+/;

// Strong password
const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
```

## SQL Injection Prevention

### Always Use
- ✅ Parameterized queries
- ✅ ORM/query builders
- ✅ Prepared statements
- ✅ Input validation

### Never Use
- ❌ String concatenation for queries
- ❌ User input directly in SQL
- ❌ Dynamic query building without validation

## XSS Prevention

### Frontend
- ✅ Use framework auto-escaping (React, Vue, Angular)
- ✅ Sanitize user HTML (DOMPurify)
- ✅ Content Security Policy headers
- ✅ Avoid `dangerouslySetInnerHTML`

### Backend
- ✅ Escape output in templates
- ✅ Set X-XSS-Protection header
- ✅ Validate content types

## CSRF Protection

- ✅ Use CSRF tokens for cookie-based auth
- ✅ SameSite cookie attribute
- ✅ Double-submit cookies
- ✅ Custom headers for AJAX requests

### CSRF Token Implementation (Express)

```javascript
const csrf = require('csurf');
const cookieParser = require('cookie-parser');

// Setup
app.use(cookieParser());
const csrfProtection = csrf({ cookie: true });

// Add to forms
app.get('/form', csrfProtection, (req, res) => {
  res.render('form', { csrfToken: req.csrfToken() });
});

// Validate on submission
app.post('/form', csrfProtection, (req, res) => {
  // CSRF token automatically validated
  // Process form data
});

// In HTML template
<input type="hidden" name="_csrf" value="<%= csrfToken %>">

// For AJAX requests
fetch('/api/data', {
  method: 'POST',
  headers: {
    'CSRF-Token': csrfToken, // Get from meta tag or cookie
    'Content-Type': 'application/json',
  },
  body: JSON.stringify(data),
});
```

### SameSite Cookie Configuration

```javascript
app.use(session({
  secret: process.env.SESSION_SECRET,
  cookie: {
    httpOnly: true,
    secure: true, // HTTPS only
    sameSite: 'strict', // or 'lax'
    maxAge: 24 * 60 * 60 * 1000, // 24 hours
  },
}));
```

## API Security

- ✅ Use HTTPS only
- ✅ Rate limiting per user/IP
- ✅ Authentication on protected endpoints
- ✅ Input validation
- ✅ Output filtering
- ✅ CORS configuration
- ✅ API versioning
- ✅ Request size limits

## File Upload Security

- ✅ Validate file type (extension + MIME)
- ✅ Limit file size
- ✅ Scan for malware
- ✅ Random filenames
- ✅ Store outside webroot
- ✅ Set Content-Disposition header

## Database Security

- ✅ Least privilege principle
- ✅ Separate users for read/write
- ✅ Enable SSL/TLS connections
- ✅ Encrypt sensitive data
- ✅ Regular backups
- ✅ Audit logging
- ✅ Network isolation

## Secret Management

- ✅ Never commit secrets to git
- ✅ Use environment variables
- ✅ Rotate secrets regularly
- ✅ Different secrets per environment
- ✅ Use secret managers (Vault, AWS Secrets)

## Headers

### Security Headers (use helmet.js)
```javascript
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Content-Security-Policy: default-src 'self'
```

## Logging

### Do Log
- ✅ Authentication attempts
- ✅ Authorization failures
- ✅ Input validation failures
- ✅ Server errors

### Never Log
- ❌ Passwords
- ❌ API keys
- ❌ Tokens
- ❌ Credit card numbers
- ❌ SSN/PII

## Dependency Security

- ✅ Regular updates
- ✅ npm audit / yarn audit
- ✅ Snyk/Dependabot monitoring
- ✅ Remove unused dependencies
- ✅ Lock files (package-lock.json)

## OWASP Top 10 Checklist

1. ✅ Broken Access Control
2. ✅ Cryptographic Failures
3. ✅ Injection
4. ✅ Insecure Design
5. ✅ Security Misconfiguration
6. ✅ Vulnerable Components
7. ✅ Authentication Failures
8. ✅ Software/Data Integrity
9. ✅ Logging/Monitoring
10. ✅ SSRF

## Production Checklist

- ✅ HTTPS everywhere
- ✅ Security headers configured
- ✅ Rate limiting enabled
- ✅ CORS properly configured
- ✅ Secrets in environment variables
- ✅ Error messages don't leak info
- ✅ Logging configured
- ✅ Monitoring enabled
- ✅ Backups automated
- ✅ Incident response plan
