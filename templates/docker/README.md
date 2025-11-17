# Docker Templates

Production-ready Dockerfiles and docker-compose configurations for common stacks.

## Available Templates

### Dockerfiles

| Template | Stack | Description |
|----------|-------|-------------|
| `Dockerfile.nextjs` | Next.js 13+ | Multi-stage build with standalone output |
| `Dockerfile.react-vite` | React + Vite | Build + nginx serving |
| `Dockerfile.express` | Node.js + Express | Production-ready with health checks |

### Docker Compose

| Template | Purpose | Services |
|----------|---------|----------|
| `docker-compose.dev.yml` | Development | Frontend, Backend, MongoDB, Redis, Adminer |
| `docker-compose.prod.yml` | Production | Same + health checks, backups, resource limits |

### Supporting Files

- `nginx.conf` - nginx configuration for SPAs with caching and security headers

---

## Quick Start

### Development

```bash
# Copy template to your project
cp docker-compose.dev.yml /path/to/your/project/

# Create .env file
cat > .env <<EOF
VITE_STRIPE_PUBLISHABLE_KEY=pk_test_...
JWT_SECRET=your-secret-key
STRIPE_SECRET_KEY=sk_test_...
EOF

# Start all services
docker-compose -f docker-compose.dev.yml up

# Frontend: http://localhost:5173
# Backend: http://localhost:3001
# MongoDB: localhost:27017
# Adminer (DB GUI): http://localhost:8080
```

### Production

```bash
# Copy template
cp docker-compose.prod.yml /path/to/your/project/

# Create production .env
cat > .env <<EOF
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=secure-password
JWT_SECRET=production-secret
STRIPE_SECRET_KEY=sk_live_...
FRONTEND_URL=https://yourapp.com
REDIS_PASSWORD=redis-password
EOF

# Build and start
docker-compose -f docker-compose.prod.yml up -d

# View logs
docker-compose -f docker-compose.prod.yml logs -f backend
```

---

## Usage Examples

### Next.js Application

```dockerfile
# Use Dockerfile.nextjs as-is or customize
docker build -f Dockerfile.nextjs -t my-nextjs-app .
docker run -p 3000:3000 my-nextjs-app
```

### React + Vite with nginx

```bash
# Copy Dockerfile and nginx.conf to your frontend/
cp Dockerfile.react-vite /path/to/frontend/Dockerfile
cp nginx.conf /path/to/frontend/

# Build
docker build -t my-react-app /path/to/frontend

# Run
docker run -p 80:80 my-react-app
```

### Express API

```dockerfile
# Customize environment variables
docker build -f Dockerfile.express -t my-api .
docker run -p 3001:3001 \
  -e DATABASE_URL=mongodb://... \
  -e JWT_SECRET=secret \
  my-api
```

---

## Customization Guide

### Modify for Your Stack

#### 1. Update Build Context
```yaml
# In docker-compose.yml
frontend:
  build:
    context: ./frontend  # ← Your frontend directory
    dockerfile: Dockerfile.react-vite
```

#### 2. Change Ports
```yaml
ports:
  - "8080:80"  # host:container
```

#### 3. Add Environment Variables
```yaml
environment:
  - VITE_API_URL=${API_URL}
  - VITE_CUSTOM_VAR=${CUSTOM_VAR}
```

#### 4. Mount Volumes for Development
```yaml
volumes:
  - ./src:/app/src  # Hot reload
  - /app/node_modules  # Don't override
```

### Add New Services

```yaml
# Example: PostgreSQL instead of MongoDB
postgres:
  image: postgres:15-alpine
  ports:
    - "5432:5432"
  volumes:
    - postgres_data:/var/lib/postgresql/data
  environment:
    - POSTGRES_DB=myapp
    - POSTGRES_USER=user
    - POSTGRES_PASSWORD=password
```

---

## Health Checks

All production templates include health checks:

### Backend Health Endpoint
```javascript
// Add to your Express app
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', timestamp: new Date() });
});
```

### Frontend nginx Health
```nginx
# Already configured in nginx.conf
# Checks: wget http://localhost:80/
```

---

## Resource Limits

### Development
No limits - use all available resources

### Production
```yaml
deploy:
  resources:
    limits:
      cpus: '1'        # Max 1 CPU core
      memory: 1G       # Max 1GB RAM
    reservations:
      cpus: '0.5'      # Reserve 0.5 cores
      memory: 512M     # Reserve 512MB
```

---

## Networking

### Access Between Services

Services communicate using service names:

```javascript
// Backend connects to MongoDB
const mongoUri = 'mongodb://mongodb:27017/myapp';

// Frontend calls backend
const apiUrl = 'http://backend:3001/api';
```

### External Access

```yaml
ports:
  - "3001:3001"  # Exposed to host
# vs
expose:
  - "3001"  # Only accessible within Docker network
```

---

## Security Best Practices

### 1. Non-Root Users
```dockerfile
RUN adduser --system --uid 1001 appuser
USER appuser
```

### 2. Read-Only Volumes
```yaml
volumes:
  - ./config:/app/config:ro  # :ro = read-only
```

### 3. Secrets Management
```bash
# Use Docker secrets (Swarm) or environment variables
# Never commit secrets to version control
echo "secret-value" | docker secret create jwt_secret -
```

### 4. Network Isolation
```yaml
networks:
  frontend_network:
  backend_network:

services:
  frontend:
    networks:
      - frontend_network
  backend:
    networks:
      - frontend_network
      - backend_network
  database:
    networks:
      - backend_network  # Not accessible from frontend
```

---

## Troubleshooting

### Container Won't Start
```bash
# Check logs
docker-compose logs frontend

# Inspect container
docker inspect <container-id>

# Shell into running container
docker exec -it <container-name> sh
```

### Port Already in Use
```bash
# Find what's using the port
lsof -i :3000

# Change port in docker-compose.yml
ports:
  - "3002:3000"  # Use 3002 instead
```

### Build Cache Issues
```bash
# Rebuild without cache
docker-compose build --no-cache

# Remove all stopped containers and images
docker system prune -a
```

### Database Connection Failed
```bash
# Ensure database is healthy
docker-compose ps

# Check environment variables
docker-compose config

# Verify network connectivity
docker exec backend ping mongodb
```

---

## Production Deployment

### 1. Build Images
```bash
docker-compose -f docker-compose.prod.yml build
```

### 2. Push to Registry
```bash
# Tag images
docker tag my-app_frontend registry.example.com/my-app/frontend:1.0.0
docker tag my-app_backend registry.example.com/my-app/backend:1.0.0

# Push
docker push registry.example.com/my-app/frontend:1.0.0
docker push registry.example.com/my-app/backend:1.0.0
```

### 3. Deploy
```bash
# On production server
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

### 4. Monitor
```bash
# View logs
docker-compose logs -f --tail=100

# Check resource usage
docker stats

# Health status
docker-compose ps
```

---

## Backup & Restore

### MongoDB Backup
```bash
# Manual backup
docker-compose exec mongodb mongodump --out=/backup/$(date +%Y%m%d)

# Restore
docker-compose exec mongodb mongorestore /backup/20250117
```

### Volume Backup
```bash
# Backup volume to tar
docker run --rm -v mongodb_prod_data:/data -v $(pwd):/backup alpine \
  tar czf /backup/mongodb-backup.tar.gz /data

# Restore volume from tar
docker run --rm -v mongodb_prod_data:/data -v $(pwd):/backup alpine \
  tar xzf /backup/mongodb-backup.tar.gz -C /
```

---

## References

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose File Reference](https://docs.docker.com/compose/compose-file/)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Security](https://docs.docker.com/engine/security/)

---

**Next Steps:**
1. Copy templates to your project
2. Customize environment variables
3. Run `docker-compose up`
4. Access your application!

Need help? See [SUPPORT.md](../../SUPPORT.md) or open an issue.
