---
name: secure
description: PROACTIVELY use this skill before production deployment or when users mention "security", "audit", "vulnerabilities", "OWASP", "penetration test", "security scan", "production ready". Automatically activate when preparing for production to ensure applications are secure. Performs comprehensive security audits, vulnerability scanning, and implements security best practices including OWASP Top 10 protection, authentication security, data encryption, and secure configuration.
---

# Secure - Security Auditing & Hardening

This skill performs comprehensive security audits and implements security best practices to ensure production applications are secure and protected against common vulnerabilities.

## Purpose

Transform an application into a secure, production-ready system. Conducts security audits, scans for vulnerabilities, implements security best practices, and ensures compliance with security standards like OWASP Top 10.

## IMPORTANT: Proactive Usage

**This skill should be activated AUTOMATICALLY and PROACTIVELY** when:

1. **Before production deployment**: Always audit security before going live
2. **User mentions security**: "Is this secure?", "Check for vulnerabilities", "Audit security"
3. **Production readiness**: Ensuring app is ready for production
4. **Compliance requirements**: GDPR, HIPAA, SOC2, etc.
5. **After ship completes**: Automatically offer security audit

**DO NOT wait for explicit request**. Before production, AUTOMATICALLY suggest: "I'll run a security audit to ensure production readiness."

**Example automatic triggers**:
- Before deployment: "Let me audit security before production" -> ACTIVATE IMMEDIATELY
- User: "Is this secure?" -> ACTIVATE IMMEDIATELY
- User: "Check for vulnerabilities" -> ACTIVATE IMMEDIATELY
- User: "Make it production ready" -> ACTIVATE IMMEDIATELY (include security)

After activating, run security scans, implement fixes, and document security measures.

## When to Use This Skill

Use this skill when:
- Preparing to deploy to production
- Application integration is complete
- Need to verify security best practices
- Compliance audit required
- Security incident occurred
- Regular security reviews

Trigger phrases include:
- "Audit the security"
- "Check for vulnerabilities"
- "Is this secure?"
- "Run security scan"
- "Make this production secure"

## How to Use This Skill

### Step 1: Dependency Vulnerability Scanning

Scan for known vulnerabilities in dependencies:

**Tools**:
- `npm audit` / `yarn audit` (Node.js)
- `pip-audit` or `safety` (Python)
- `dotnet list package --vulnerable` (.NET)
- **Snyk**: Comprehensive dependency scanning
- **OWASP Dependency-Check**: Multi-language scanner
- **GitHub Dependabot**: Automated vulnerability alerts

**Actions**:
```bash
# Node.js
npm audit
npm audit fix

# Python
pip-audit
safety check

# .NET
dotnet list package --vulnerable

# Using Snyk
snyk test
snyk fix
```

**Fix Priority**:
1. Critical vulnerabilities: Fix immediately
2. High vulnerabilities: Fix before production
3. Medium/Low: Schedule fixes, may accept risk

### Step 2: OWASP Top 10 Security Audit

Check for OWASP Top 10 vulnerabilities:

#### 1. Broken Access Control
- ✅ Check authentication on all protected routes
- ✅ Verify authorization for sensitive operations
- ✅ Prevent access to other users' data
- ✅ Test for horizontal/vertical privilege escalation
- ✅ Validate JWT tokens properly

**Example Fix (Express)**:
```javascript
// Authentication middleware
const requireAuth = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'Unauthorized' });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
};

// Authorization check
const requireOwnership = async (req, res, next) => {
  const resource = await Resource.findById(req.params.id);
  if (resource.userId !== req.user.id) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  next();
};
```

#### 2. Cryptographic Failures
- ✅ Use HTTPS everywhere (enforce with HSTS)
- ✅ Encrypt sensitive data at rest
- ✅ Hash passwords with bcrypt (cost factor ≥12)
- ✅ Use secure random number generation
- ✅ Protect API keys and secrets

**Example (Password Hashing)**:
```javascript
const bcrypt = require('bcrypt');

// Hash password
const hashedPassword = await bcrypt.hash(password, 12);

// Verify password
const isValid = await bcrypt.compare(password, hashedPassword);
```

#### 3. Injection
- ✅ Use parameterized queries (prevent SQL injection)
- ✅ Validate and sanitize all inputs
- ✅ Use ORM/query builders safely
- ✅ Avoid eval() and dangerous functions
- ✅ Validate data types

**Example (SQL Injection Prevention)**:
```javascript
// BAD - Vulnerable to SQL injection
const query = `SELECT * FROM users WHERE email = '${email}'`;

// GOOD - Parameterized query
const query = 'SELECT * FROM users WHERE email = ?';
const result = await db.query(query, [email]);

// GOOD - Using ORM
const user = await User.findOne({ where: { email } });
```

#### 4. Insecure Design
- ✅ Implement rate limiting
- ✅ Add CAPTCHA for sensitive operations
- ✅ Use secure session management
- ✅ Implement proper error handling
- ✅ Principle of least privilege

#### 5. Security Misconfiguration
- ✅ Remove default credentials
- ✅ Disable directory listing
- ✅ Remove unnecessary features/endpoints
- ✅ Keep dependencies updated
- ✅ Configure security headers

**Security Headers (helmet.js)**:
```javascript
const helmet = require('helmet');

app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true,
  },
}));
```

#### 6. Vulnerable Components
- ✅ Regular dependency updates
- ✅ Remove unused dependencies
- ✅ Monitor security advisories
- ✅ Use lock files (package-lock.json)

#### 7. Authentication Failures
- ✅ Implement strong password policy
- ✅ Multi-factor authentication (optional but recommended)
- ✅ Secure password reset flow
- ✅ Account lockout after failed attempts
- ✅ Session timeout

**Rate Limiting (express-rate-limit)**:
```javascript
const rateLimit = require('express-rate-limit');

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts
  message: 'Too many login attempts, please try again later',
});

app.post('/auth/login', loginLimiter, loginHandler);
```

#### 8. Software and Data Integrity Failures
- ✅ Verify file upload integrity
- ✅ Use Subresource Integrity (SRI) for CDN
- ✅ Implement CI/CD security scanning
- ✅ Code signing where applicable

#### 9. Security Logging and Monitoring
- ✅ Log authentication events
- ✅ Log authorization failures
- ✅ Monitor for suspicious activity
- ✅ Alert on security events
- ✅ Do NOT log sensitive data

#### 10. Server-Side Request Forgery (SSRF)
- ✅ Validate and sanitize URLs
- ✅ Use allowlists for external requests
- ✅ Disable following redirects
- ✅ Validate response types

### Step 3: Input Validation & Sanitization

Implement comprehensive input validation:

**Validation Libraries**:
- **Joi** (Node.js)
- **Yup** (Node.js)
- **class-validator** (TypeScript)
- **Pydantic** (Python)
- **FluentValidation** (.NET)

**Example (Joi)**:
```javascript
const Joi = require('joi');

const userSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(8).pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])/),
  age: Joi.number().integer().min(13).max(120),
});

app.post('/users', async (req, res) => {
  const { error, value } = userSchema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });

  // Use validated data
  const user = await createUser(value);
  res.json(user);
});
```

**Sanitization**:
- Use DOMPurify for HTML sanitization (frontend)
- Use validator.js for string sanitization
- Escape output in templates
- Whitelist allowed characters

### Step 4: Cross-Site Scripting (XSS) Protection

Prevent XSS attacks:

**Frontend**:
- Use framework auto-escaping (React, Vue, Angular)
- Avoid `dangerouslySetInnerHTML` / `v-html`
- Sanitize user-generated HTML content
- Content Security Policy headers

**Backend**:
- Set `X-XSS-Protection` header
- Escape output in server-rendered templates
- Sanitize inputs

**React Example**:
```javascript
// BAD - XSS vulnerable
<div dangerouslySetInnerHTML={{ __html: userContent }} />

// GOOD - Auto-escaped
<div>{userContent}</div>

// GOOD - Sanitized HTML (if really needed)
import DOMPurify from 'dompurify';
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userContent) }} />
```

### Step 5: CSRF Protection

Implement Cross-Site Request Forgery protection:

**Techniques**:
- CSRF tokens (for cookie-based auth)
- SameSite cookie attribute
- Double-submit cookies
- Custom headers (for AJAX)

**Example (csurf middleware)**:
```javascript
const csrf = require('csurf');
const csrfProtection = csrf({ cookie: true });

app.get('/form', csrfProtection, (req, res) => {
  res.render('form', { csrfToken: req.csrfToken() });
});

app.post('/form', csrfProtection, (req, res) => {
  // Process form
});
```

**For JWT/Token Auth**:
- Not needed (not cookie-based)
- Ensure tokens stored securely (not localStorage for sensitive apps)

### Step 6: File Upload Security

Secure file upload handling:

**Security Measures**:
- Validate file types (extension + MIME type)
- Limit file sizes
- Scan for malware
- Store uploads outside webroot
- Generate random filenames
- Serve files with `Content-Disposition: attachment`

**Example (multer + validation)**:
```javascript
const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
  destination: './uploads/',
  filename: (req, file, cb) => {
    const uniqueName = `${Date.now()}-${Math.random().toString(36).substr(2, 9)}${path.extname(file.originalname)}`;
    cb(null, uniqueName);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB
  fileFilter: (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|pdf/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);

    if (extname && mimetype) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type'));
    }
  },
});
```

### Step 7: Environment & Configuration Security

Secure configuration and secrets:

**Best Practices**:
- Never commit secrets to git
- Use environment variables
- Rotate secrets regularly
- Use secret management (AWS Secrets Manager, HashiCorp Vault)
- Different secrets per environment

**Example (.env.example)**:
```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# JWT
JWT_SECRET=your-secret-key-here
JWT_EXPIRES_IN=24h

# API Keys (examples - replace with real values)
STRIPE_SECRET_KEY=sk_test_...
SENDGRID_API_KEY=SG...
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...

# Security
SESSION_SECRET=your-session-secret-here
ENCRYPTION_KEY=your-encryption-key-here
```

**Gitignore**:
```
.env
.env.local
.env.production
config/secrets.yaml
```

### Step 8: API Security

Secure REST APIs:

**Best Practices**:
- Use HTTPS only
- Implement authentication (JWT, OAuth)
- Rate limiting per user/IP
- API versioning
- Request validation
- Response filtering (don't expose internal IDs)
- CORS configuration

**CORS Configuration**:
```javascript
const cors = require('cors');

app.use(cors({
  origin: process.env.FRONTEND_URL,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
```

### Step 9: Database Security

Secure database access:

**Best Practices**:
- Use least privilege principle
- Separate read/write users
- Enable SSL/TLS connections
- Encrypt sensitive data
- Regular backups
- Audit logging
- Network isolation

**Encryption at Rest**:
```javascript
const crypto = require('crypto');

function encrypt(text, key) {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-gcm', Buffer.from(key, 'hex'), iv);
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  const authTag = cipher.getAuthTag();

  return {
    encrypted,
    iv: iv.toString('hex'),
    authTag: authTag.toString('hex'),
  };
}
```

### Step 10: Security Testing

Perform security testing:

**Automated Tools**:
- **OWASP ZAP**: Web application security scanner
- **Burp Suite**: Security testing platform
- **Nikto**: Web server scanner
- **SQLMap**: SQL injection testing
- **Nmap**: Network scanning

**Manual Testing**:
- Test authentication bypass
- Test authorization bypass
- Test injection vulnerabilities
- Test file upload exploits
- Test for sensitive data exposure

### Step 11: Compliance Checklist

Ensure regulatory compliance:

**GDPR**:
- ✅ Data processing consent
- ✅ Right to access data
- ✅ Right to deletion
- ✅ Data portability
- ✅ Breach notification (72 hours)

**HIPAA** (Healthcare):
- ✅ Encryption at rest and in transit
- ✅ Access controls
- ✅ Audit logging
- ✅ Business Associate Agreements

**PCI DSS** (Payment cards):
- ✅ Don't store CVV/CVV2
- ✅ Use payment processor (Stripe, PayPal)
- ✅ Encrypt cardholder data
- ✅ Regular security testing

### Step 12: Security Documentation

Document security measures:

```markdown
# Security Documentation

## Authentication
- Method: JWT tokens
- Token expiry: 24 hours
- Refresh token: 7 days
- Password hashing: bcrypt (cost 12)

## Authorization
- Role-based access control (RBAC)
- Roles: admin, user, guest
- Protected routes: [list]

## Encryption
- In transit: TLS 1.3
- At rest: AES-256-GCM for sensitive fields
- Passwords: bcrypt

## Security Headers
- Helmet.js configured
- CSP enabled
- HSTS enabled (max-age: 1 year)

## Rate Limiting
- Login: 5 attempts per 15 minutes
- API: 100 requests per minute per user
- File upload: 10 per hour

## Input Validation
- All user inputs validated with Joi
- XSS protection enabled
- SQL injection prevented (parameterized queries)

## Dependency Security
- npm audit run weekly
- Snyk monitoring enabled
- Auto-updates: patch and minor versions

## Compliance
- GDPR: Data export/delete endpoints
- Cookie consent: Implemented
- Privacy policy: [URL]

## Incident Response
- Security contact: security@example.com
- Incident logging: Enabled
- Breach notification: Within 72 hours
```

## Best Practices

### Security-First Development
- Security review in every PR
- Automated security testing in CI/CD
- Regular security training
- Threat modeling for new features

### Defense in Depth
- Multiple layers of security
- Don't rely on single control
- Fail securely (deny by default)

### Principle of Least Privilege
- Minimal permissions for users/services
- Separate production/development access
- Regular permission audits

## Notes

- Security is ongoing, not one-time
- Regular updates and patches critical
- Monitor security advisories
- Incident response plan essential
- Security testing before every release
