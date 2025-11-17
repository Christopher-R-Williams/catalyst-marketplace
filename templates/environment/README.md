# Environment Templates

Pre-configured `.env.example` files for common tech stacks with all necessary environment variables.

## Available Templates

| Template | Stack | Services |
|----------|-------|----------|
| `.env.example.react-express-mongodb` | MERN | React, Express, MongoDB, Redis |
| `.env.example.nextjs-postgresql` | Next.js | Next.js, PostgreSQL, Prisma |

---

## Quick Start

### 1. Choose Your Stack Template

```bash
# Copy the template for your stack
cp .env.example.react-express-mongodb /path/to/your/project/.env

# Or for Next.js
cp .env.example.nextjs-postgresql /path/to/your/project/.env.local
```

### 2. Fill in Values

```bash
# Edit the file
nano .env

# Required values:
# - Database connection strings
# - JWT secrets
# - API keys for services you're using
```

### 3. Generate Secrets

```bash
# Generate random secret
openssl rand -base64 32

# Or use Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"
```

### 4. Verify Setup

```bash
# Check if .env is in .gitignore
grep -q "^\.env$" .gitignore || echo ".env" >> .gitignore

# Test loading variables
node -e "require('dotenv').config(); console.log('API_URL:', process.env.API_URL)"
```

---

## Template Breakdown

### React + Express + MongoDB

**Frontend Variables (VITE_*):**
- API configuration
- Public API keys (Stripe, Maps)
- Feature flags

**Backend Variables:**
- Database connections
- Authentication secrets
- External service keys

**External Services:**
- Stripe payments
- SendGrid email
- AWS S3 storage
- OAuth providers

### Next.js + PostgreSQL

**Public Variables (NEXT_PUBLIC_*):**
- Exposed to browser
- Analytics IDs
- Public API keys

**Server Variables:**
- Database URLs
- Private API keys
- Webhook secrets

**NextAuth Configuration:**
- OAuth providers
- Session management
- Email configuration

---

## Environment Variable Naming Conventions

### Prefix Conventions

```bash
# React/Vite - Browser accessible
VITE_API_URL=...
VITE_STRIPE_KEY=...

# Next.js - Browser accessible
NEXT_PUBLIC_API_URL=...
NEXT_PUBLIC_GA_ID=...

# No prefix - Server-side only
DATABASE_URL=...
JWT_SECRET=...
STRIPE_SECRET_KEY=...
```

### Naming Patterns

```bash
# Good naming
DATABASE_URL=postgresql://...
SMTP_HOST=smtp.example.com
SMTP_PORT=587
OAUTH_GOOGLE_CLIENT_ID=...
OAUTH_GOOGLE_CLIENT_SECRET=...

# Poor naming
DB=postgresql://...
MAIL_SERVER=smtp.example.com
GOOGLE_ID=...
```

---

## Security Best Practices

### 1. Never Commit Secrets

```bash
# .gitignore should include:
.env
.env.local
.env.*.local
.env.production
*.env
```

### 2. Use Strong Secrets

```bash
# ❌ Weak
JWT_SECRET=mysecret

# ✅ Strong (32+ characters)
JWT_SECRET=a8f5f167f44f4964e6c998dee827110c

# Generate strong secrets
openssl rand -hex 32
```

### 3. Separate by Environment

```bash
# Development
.env.development
DATABASE_URL=postgresql://localhost:5432/myapp_dev

# Production
.env.production
DATABASE_URL=postgresql://prod-server:5432/myapp_prod
```

### 4. Use Environment-Specific Values

```bash
# Development
CORS_ORIGIN=http://localhost:3000
STRIPE_SECRET_KEY=sk_test_...

# Production
CORS_ORIGIN=https://yourapp.com
STRIPE_SECRET_KEY=sk_live_...
```

---

## Common Services Configuration

### Database URLs

```bash
# PostgreSQL
DATABASE_URL=postgresql://username:password@localhost:5432/database

# MongoDB
MONGODB_URI=mongodb://localhost:27017/database

# MongoDB Atlas
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/db

# MySQL
DATABASE_URL=mysql://user:password@localhost:3306/database

# SQLite
DATABASE_URL=file:./dev.db
```

### Redis

```bash
# Local
REDIS_URL=redis://localhost:6379

# With password
REDIS_URL=redis://:password@localhost:6379

# Upstash (serverless)
REDIS_URL=https://abc-123.upstash.io
REDIS_TOKEN=AXYz...
```

### Email Services

```bash
# SendGrid
SENDGRID_API_KEY=SG.abc123...
FROM_EMAIL=noreply@yourapp.com

# Resend
RESEND_API_KEY=re_...

# SMTP (generic)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
```

### OAuth Providers

```bash
# Google
GOOGLE_CLIENT_ID=123-abc.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=GOCSPX-...
GOOGLE_CALLBACK_URL=http://localhost:3000/auth/google/callback

# GitHub
GITHUB_CLIENT_ID=Iv1.abc123...
GITHUB_CLIENT_SECRET=abc123...
GITHUB_CALLBACK_URL=http://localhost:3000/auth/github/callback
```

### Storage Services

```bash
# AWS S3
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=us-east-1
AWS_S3_BUCKET=my-bucket

# Cloudinary
CLOUDINARY_CLOUD_NAME=your-cloud
CLOUDINARY_API_KEY=123456789
CLOUDINARY_API_SECRET=abc...

# Vercel Blob
BLOB_READ_WRITE_TOKEN=vercel_blob_rw_...
```

---

## Loading Environment Variables

### Node.js (dotenv)

```javascript
// Load from .env file
require('dotenv').config();

// Access variables
const dbUrl = process.env.DATABASE_URL;
const port = process.env.PORT || 3000;

// Validate required variables
const required = ['DATABASE_URL', 'JWT_SECRET'];
required.forEach(key => {
  if (!process.env[key]) {
    throw new Error(`Missing required environment variable: ${key}`);
  }
});
```

### Next.js

```javascript
// Server-side (API routes, getServerSideProps)
const secret = process.env.JWT_SECRET;

// Client-side (must use NEXT_PUBLIC_ prefix)
const apiUrl = process.env.NEXT_PUBLIC_API_URL;

// next.config.js - expose variables
module.exports = {
  env: {
    CUSTOM_KEY: process.env.CUSTOM_KEY,
  },
};
```

### Vite (React, Vue)

```javascript
// vite.config.js - define variables
export default defineConfig({
  define: {
    'import.meta.env.VITE_API_URL': JSON.stringify(process.env.VITE_API_URL),
  },
});

// In components - access with import.meta.env
const apiUrl = import.meta.env.VITE_API_URL;
```

### Docker

```yaml
# docker-compose.yml
services:
  backend:
    env_file:
      - .env
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - JWT_SECRET=${JWT_SECRET}
```

---

## Validation

### Required Variables Check

```javascript
// validate-env.js
const required = [
  'DATABASE_URL',
  'JWT_SECRET',
  'CORS_ORIGIN',
];

const missing = required.filter(key => !process.env[key]);

if (missing.length > 0) {
  console.error('Missing required environment variables:');
  missing.forEach(key => console.error(`  - ${key}`));
  process.exit(1);
}

console.log('✅ All required environment variables are set');
```

### TypeScript Validation

```typescript
// env.ts
import { z } from 'zod';

const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(32),
  PORT: z.string().transform(Number).default('3000'),
  NODE_ENV: z.enum(['development', 'production', 'test']),
});

export const env = envSchema.parse(process.env);

// Usage
import { env } from './env';
console.log(env.DATABASE_URL); // Type-safe!
```

---

## Troubleshooting

### Variables Not Loading

```bash
# Check if .env file exists
ls -la .env

# Check file permissions
chmod 600 .env

# Verify dotenv is installed
npm list dotenv

# Load .env explicitly
node -r dotenv/config app.js
```

### Wrong Environment

```bash
# Check which .env file is loaded
echo $NODE_ENV

# Force specific environment
NODE_ENV=production node app.js

# Check loaded variables
node -e "require('dotenv').config(); console.log(process.env)"
```

### Secrets Not Working

```bash
# Check for whitespace
cat .env | od -c

# Check for quotes
# ❌ Wrong
JWT_SECRET="abc123"

# ✅ Correct
JWT_SECRET=abc123
```

---

## Production Deployment

### Hosting Platforms

#### Vercel
```bash
# Add via CLI
vercel env add DATABASE_URL production

# Or via dashboard: Settings → Environment Variables
```

#### Railway
```bash
# Set via CLI
railway variables set DATABASE_URL=postgresql://...

# Or via dashboard: Variables tab
```

#### Heroku
```bash
# Set config vars
heroku config:set DATABASE_URL=postgresql://...

# View all
heroku config
```

#### AWS/DigitalOcean
```bash
# Use secrets manager or env files
# Never hardcode in code or commit to git
```

---

## Security Checklist

Before deploying:

- [ ] All secrets are in .env, not in code
- [ ] .env is in .gitignore
- [ ] Using different secrets for dev/prod
- [ ] JWT secrets are 32+ characters
- [ ] Database credentials are strong
- [ ] OAuth redirect URLs are whitelisted
- [ ] API keys have proper scopes/permissions
- [ ] No NEXT_PUBLIC_/VITE_ prefix on secrets
- [ ] Secrets are rotated regularly
- [ ] Production uses HTTPS
- [ ] CORS is properly configured
- [ ] Rate limiting is enabled

---

## References

- [12-Factor App: Config](https://12factor.net/config)
- [dotenv Documentation](https://github.com/motdotla/dotenv)
- [Next.js Environment Variables](https://nextjs.org/docs/basic-features/environment-variables)
- [Vite Environment Variables](https://vitejs.dev/guide/env-and-mode.html)

---

**Need help?** See [SUPPORT.md](../../SUPPORT.md) or open an issue.
