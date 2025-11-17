---
name: monitor
description: PROACTIVELY use this skill after ship completes or when users mention "monitoring", "logging", "observability", "track errors", "production readiness", "performance monitoring". Automatically activate when the application is integrated and ready for production. Sets up comprehensive logging, error tracking, performance monitoring, and observability infrastructure to ensure production applications are monitored and debuggable.
---

# Monitor - Logging & Observability

This skill sets up comprehensive monitoring, logging, and observability infrastructure for production applications. It ensures that applications are observable, debuggable, and production-ready with proper logging, error tracking, and performance monitoring.

## Purpose

Transform a working application into a production-ready system with full observability. After integration is complete, this skill adds logging infrastructure, error tracking, performance monitoring, and alerting to ensure you can monitor and debug production issues effectively.

## IMPORTANT: Proactive Usage

**This skill should be activated AUTOMATICALLY and PROACTIVELY** when:

1. **After ship completes**: Automatically offer to add monitoring when integration is done
2. **Preparing for production**: When users mention "deploy to production", "production ready", "go live"
3. **User wants observability**: "Add logging", "Track errors", "Monitor performance", "Set up observability"
4. **Debugging needs**: "How do I debug in production?", "Track user errors", "Monitor API performance"
5. **Production best practices**: Ensuring production readiness

**DO NOT wait for explicit request**. After integration, AUTOMATICALLY suggest: "I'll add monitoring and observability infrastructure for production readiness."

**Example automatic triggers**:
- After ship: "Application is working. Let me add monitoring for production." -> ACTIVATE IMMEDIATELY
- User: "How do I monitor this in production?" -> ACTIVATE IMMEDIATELY
- User: "Add error tracking" -> ACTIVATE IMMEDIATELY
- User: "Make it production ready" -> ACTIVATE IMMEDIATELY (include monitoring)

After activating, setup logging, error tracking, performance monitoring, and alerts.

## When to Use This Skill

Use this skill when:
- Application integration is complete and working
- Preparing to deploy to production
- Need to debug production issues
- Want to track user errors and issues
- Need performance monitoring and analytics
- Want to ensure production readiness

Trigger phrases include:
- "Add monitoring to the application"
- "Setup logging and error tracking"
- "How do I monitor this in production?"
- "Make this production ready"
- "Add observability infrastructure"

## How to Use This Skill

### Step 1: Assess Current State

Identify what's already in place:
- **Existing logging**: Console.log, print statements, etc.
- **Error handling**: Try/catch blocks, error middleware
- **Monitoring**: Any existing monitoring tools
- **Stack**: Node.js, Python, .NET, Java, etc.

Document what needs to be added.

### Step 2: Setup Structured Logging

Implement proper logging infrastructure:

**Backend Logging**:
- **Node.js**: Winston, Pino, or Bunyan
- **Python**: Loguru, structlog, or Python logging
- **.NET**: Serilog, NLog, or log4net
- **Java**: Log4j2, Logback, or SLF4J

**Logging Best Practices**:
- Use structured logging (JSON format)
- Include context: user ID, request ID, timestamp
- Log levels: ERROR, WARN, INFO, DEBUG
- Correlation IDs for request tracing
- Avoid logging sensitive data (passwords, tokens, PII)

**Example (Node.js with Winston)**:
```javascript
const winston = require('winston');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: { service: 'api-server' },
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
  ],
});

// Add console transport for development
if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple(),
  }));
}

module.exports = logger;
```

**Frontend Logging**:
- Console logging for development
- Structured error reporting for production
- Avoid verbose logging in production
- Log user actions for analytics

### Step 3: Setup Error Tracking

Implement error tracking to capture and analyze production errors:

**Error Tracking Services**:
- **Sentry**: Comprehensive error tracking (recommended)
- **Rollbar**: Error monitoring and alerting
- **Bugsnag**: Error monitoring for apps
- **LogRocket**: Session replay with errors
- **Datadog**: Full observability platform

**Sentry Integration Example (Node.js)**:
```javascript
const Sentry = require("@sentry/node");

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0, // Adjust for production
});

// Express error handler
app.use(Sentry.Handlers.errorHandler());
```

**Sentry Integration Example (React)**:
```javascript
import * as Sentry from "@sentry/react";

Sentry.init({
  dsn: process.env.REACT_APP_SENTRY_DSN,
  environment: process.env.NODE_ENV,
  integrations: [new Sentry.BrowserTracing()],
  tracesSampleRate: 1.0,
});
```

**What to Track**:
- Uncaught exceptions and promise rejections
- API errors (4xx, 5xx)
- Frontend errors (component errors, async errors)
- User context (ID, email, session)
- Request context (URL, method, headers)
- Stack traces and breadcrumbs

### Step 4: Setup Performance Monitoring

Monitor application performance in production:

**Application Performance Monitoring (APM)**:
- **New Relic**: Full-stack observability
- **Datadog APM**: Distributed tracing
- **Dynatrace**: AI-powered monitoring
- **Elastic APM**: Open-source APM
- **AWS X-Ray**: AWS-native tracing

**Metrics to Track**:
- API response times (p50, p95, p99)
- Database query performance
- External API call latency
- Frontend page load times
- Time to First Byte (TTFB)
- Core Web Vitals (LCP, FID, CLS)

**Custom Metrics**:
- Business metrics (signups, purchases, conversions)
- User engagement metrics
- Feature usage tracking
- Error rates and success rates

**Example (Express + Prometheus)**:
```javascript
const promClient = require('prom-client');
const express = require('express');

// Create metrics
const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
});

// Middleware to track metrics
app.use((req, res, next) => {
  const start = Date.now();

  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    httpRequestDuration.labels(req.method, req.route?.path || req.path, res.statusCode).observe(duration);
  });

  next();
});

// Expose metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', promClient.register.contentType);
  res.end(await promClient.register.metrics());
});
```

### Step 5: Setup Database Monitoring

Monitor database performance:

**Database Metrics**:
- Query execution times
- Connection pool usage
- Slow query logs
- Database CPU and memory
- Disk I/O and storage

**Tools**:
- **PostgreSQL**: pg_stat_statements, pgBadger
- **MongoDB**: MongoDB Atlas monitoring, mongostat
- **MySQL**: Performance Schema, slow query log
- **SQL Server**: SQL Server Profiler, Query Store

**Query Performance Logging**:
```javascript
// Prisma example
const prisma = new PrismaClient({
  log: [
    { level: 'query', emit: 'event' },
    { level: 'error', emit: 'event' },
  ],
});

prisma.$on('query', (e) => {
  if (e.duration > 100) { // Log slow queries (>100ms)
    logger.warn('Slow query detected', {
      query: e.query,
      duration: e.duration,
      params: e.params,
    });
  }
});
```

### Step 6: Setup Alerting

Configure alerts for critical issues:

**Alert Channels**:
- Email notifications
- Slack/Discord webhooks
- PagerDuty for on-call
- SMS for critical alerts

**Alerts to Configure**:
- High error rates (>1% of requests)
- Slow response times (p95 > threshold)
- Service downtime or health check failures
- Database connection issues
- High memory or CPU usage
- Security incidents (repeated failed logins)

**Example (Sentry Alerts)**:
- Configure alert rules in Sentry dashboard
- Set thresholds for error frequency
- Define escalation policies
- Integrate with Slack/email/PagerDuty

### Step 7: Setup Health Checks

Implement health and readiness endpoints:

**Health Check Endpoint**:
```javascript
app.get('/health', async (req, res) => {
  try {
    // Check database connection
    await prisma.$queryRaw`SELECT 1`;

    // Check Redis connection (if applicable)
    await redis.ping();

    res.status(200).json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      version: process.env.APP_VERSION,
    });
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      error: error.message,
    });
  }
});

// Readiness check (can accept traffic)
app.get('/ready', async (req, res) => {
  // Check if app is ready to serve traffic
  const isReady = await checkDatabaseReady() && await checkDependenciesReady();

  if (isReady) {
    res.status(200).json({ status: 'ready' });
  } else {
    res.status(503).json({ status: 'not ready' });
  }
});
```

### Step 8: Setup Dashboards

Create monitoring dashboards:

**Dashboard Tools**:
- **Grafana**: Visualize metrics from Prometheus, InfluxDB
- **Datadog**: Built-in dashboards
- **New Relic**: Pre-built and custom dashboards
- **CloudWatch**: AWS-native dashboards

**Dashboard Sections**:
- System health overview
- API performance metrics
- Error rates and types
- User activity and engagement
- Database performance
- Infrastructure metrics

**Key Metrics to Display**:
- Request rate (req/sec)
- Error rate (%)
- Response time (p50, p95, p99)
- Active users
- Database connections
- Memory and CPU usage

### Step 9: Setup Log Aggregation

Centralize logs for easier analysis:

**Log Aggregation Tools**:
- **ELK Stack**: Elasticsearch, Logstash, Kibana
- **Datadog Logs**: Managed log aggregation
- **CloudWatch Logs**: AWS-native logging
- **Splunk**: Enterprise log management
- **Loki + Grafana**: Lightweight log aggregation

**Log Collection**:
- Ship application logs to central location
- Include logs from all services/containers
- Add metadata: service name, environment, version
- Set retention policies (30-90 days)

**Log Analysis**:
- Search and filter logs by context
- Create alerts from log patterns
- Analyze error trends
- Debug production issues

### Step 10: Documentation

Document monitoring setup:

**Monitoring Documentation**:
- How to access dashboards
- What metrics are tracked
- Alert configurations
- How to investigate alerts
- Runbooks for common issues
- On-call procedures (if applicable)

**Environment Variables**:
```
# Monitoring & Observability
SENTRY_DSN=https://...
LOG_LEVEL=info
NEW_RELIC_LICENSE_KEY=...
DATADOG_API_KEY=...
```

## Best Practices

### Privacy and Compliance

- **Never log sensitive data**: passwords, tokens, credit cards, SSNs
- **Redact PII**: mask email addresses, phone numbers
- **Comply with regulations**: GDPR, HIPAA, SOC2
- **Secure log access**: Restrict who can view logs
- **Data retention**: Set appropriate retention periods

### Performance Considerations

- **Sample in production**: Don't trace every request (use sampling)
- **Async logging**: Don't block main thread
- **Log rotation**: Prevent disk space issues
- **Efficient queries**: Optimize metric collection
- **Batch data**: Send metrics in batches, not individually

### Cost Optimization

- **Use sampling**: 100% tracing is expensive
- **Set retention limits**: Older logs cost more to store
- **Filter noise**: Don't log everything
- **Choose appropriate plans**: Many tools have free tiers
- **Self-host**: Consider open-source tools for cost savings

## Integration with Other Skills

This skill works with:
- **ship**: Add monitoring during integration phase
- **deploy** (future skill): Include monitoring in deployment
- **scale** (future skill): Use monitoring data to guide scaling
- **secure** (future skill): Monitor security events

## Output Format

Document monitoring setup:

```markdown
# Monitoring & Observability Setup

## Overview
- **Error Tracking**: Sentry
- **Logging**: Winston (backend), Browser console (frontend)
- **APM**: New Relic / Datadog / None
- **Metrics**: Prometheus + Grafana / CloudWatch
- **Alerts**: Slack, Email

## Dashboards
- Main dashboard: [URL]
- Error tracking: [Sentry URL]
- APM: [APM URL]

## Alerts Configured
- High error rate (>1% of requests) -> Slack #alerts
- API response time p95 > 500ms -> Email
- Service health check failing -> PagerDuty

## Health Endpoints
- Health: GET /health
- Readiness: GET /ready

## Logs
- Backend logs: Winston -> CloudWatch Logs / File
- Frontend errors: Sentry
- Database: Slow query log enabled

## Runbooks
- [Investigating high error rates](docs/runbooks/high-error-rate.md)
- [Debugging slow API responses](docs/runbooks/slow-api.md)
- [Database connection issues](docs/runbooks/database-issues.md)

## Access
- Sentry: [Team members with access]
- Grafana: [URL and credentials]
- Log aggregation: [URL and access instructions]
```

## Common Monitoring Tools by Stack

### Node.js
- Logging: Winston, Pino
- Errors: Sentry, Bugsnag
- APM: New Relic, Datadog, Elastic APM

### Python
- Logging: Loguru, structlog
- Errors: Sentry, Rollbar
- APM: New Relic, Datadog, Scout APM

### .NET
- Logging: Serilog, NLog
- Errors: Sentry, Raygun
- APM: Application Insights, New Relic

### Java
- Logging: Log4j2, Logback
- Errors: Sentry, Rollbar
- APM: New Relic, Dynatrace, AppDynamics

## Notes

- Monitoring is essential for production applications
- Start with basics: logging + error tracking
- Add APM and metrics as needed
- Configure alerts before issues occur
- Test monitoring setup before going to production
- Review and update monitoring regularly
