# Deployment Guide

## Overview

Spotlight OS is designed for deployment using Kamal, Docker containers, and modern cloud infrastructure. This guide covers deployment strategies, environment configuration, and operational procedures.

## Deployment Architecture

### Production Environment

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Load Balancer │    │   Application   │    │   Database      │
│   (nginx/HAProxy)│◄──►│   Servers       │◄──►│   (PostgreSQL)  │
│                 │    │   (Docker)      │    │   (RDS/Managed) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CDN           │    │   Background    │    │   Redis         │
│   (CloudFlare)  │    │   Jobs          │    │   (ElastiCache) │
│                 │    │   (Solid Queue) │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Prerequisites

### System Requirements

#### Minimum Requirements
- **CPU**: 2 vCPUs
- **Memory**: 4 GB RAM
- **Storage**: 20 GB SSD
- **Network**: 1 Gbps

#### Recommended Requirements
- **CPU**: 4 vCPUs
- **Memory**: 8 GB RAM
- **Storage**: 50 GB SSD
- **Network**: 1 Gbps

### Software Dependencies

#### Server Requirements
- **Docker**: 24.0+
- **Docker Compose**: 2.0+
- **Linux**: Ubuntu 22.04 LTS or equivalent

#### Database Requirements
- **PostgreSQL**: 14+
- **Redis**: 7.0+

## Kamal Deployment

### Initial Setup

1. **Install Kamal**
   ```bash
   gem install kamal
   ```

2. **Configure Deploy**
   ```bash
   # config/deploy.yml
   service: spotlight-os
   image: spotlight-os
   
   servers:
     web:
       hosts:
         - your-server-ip
       labels:
         traefik.http.routers.spotlight.rule: Host(`your-domain.com`)
   
   registry:
     server: ghcr.io
     username:
       - GITHUB_ACTOR
     password:
       - GITHUB_TOKEN
   
   env:
     clear:
       RAILS_ENV: production
       RAILS_LOG_LEVEL: info
     secret:
       - RAILS_MASTER_KEY
       - DATABASE_URL
       - REDIS_URL
   ```

3. **First Deployment**
   ```bash
   kamal setup
   ```

### Regular Deployments

```bash
# Deploy latest changes
kamal deploy

# Deploy specific version
kamal deploy --version=v1.2.3

# Deploy with database migrations
kamal deploy --skip-hooks
bin/rails db:migrate
kamal app start
```

### Environment Variables

#### Required Environment Variables

```bash
# Application
RAILS_ENV=production
RAILS_MASTER_KEY=your_master_key
SECRET_KEY_BASE=your_secret_key

# Database
DATABASE_URL=postgresql://user:password@host:5432/spotlight_production
REDIS_URL=redis://redis-host:6379/0

# External Services
OPENAI_API_KEY=your_openai_key
ELEVENLABS_API_KEY=your_elevenlabs_key
STRIPE_SECRET_KEY=your_stripe_key
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key

# Email
SMTP_HOST=smtp.mailgun.org
SMTP_USERNAME=your_smtp_username
SMTP_PASSWORD=your_smtp_password

# File Storage
AWS_ACCESS_KEY_ID=your_aws_key
AWS_SECRET_ACCESS_KEY=your_aws_secret
AWS_REGION=us-east-1
AWS_BUCKET=spotlight-os-production
```

#### Optional Environment Variables

```bash
# Monitoring
SENTRY_DSN=your_sentry_dsn
NEW_RELIC_LICENSE_KEY=your_newrelic_key

# Feature Flags
ENABLE_FEATURE_X=true
MAINTENANCE_MODE=false

# Performance
WEB_CONCURRENCY=4
MAX_THREADS=5
RAILS_LOG_LEVEL=info
```

## Docker Configuration

### Dockerfile

```dockerfile
FROM ruby:3.2-slim

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    git \
    libpq-dev \
    nodejs \
    npm \
    curl

# Set working directory
WORKDIR /app

# Install Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle config --global frozen 1 && \
    bundle install --jobs 4 --retry 3

# Install Node.js dependencies
COPY package.json package-lock.json ./
RUN npm ci --production

# Copy application code
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

# Create non-root user
RUN groupadd -r app && useradd -r -g app app
RUN chown -R app:app /app
USER app

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Start application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
```

### Docker Compose (Development)

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://postgres:password@db:5432/spotlight_development
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis
    volumes:
      - .:/app
      - bundle_cache:/usr/local/bundle

  db:
    image: postgres:14
    environment:
      POSTGRES_PASSWORD: password
      POSTGRES_DB: spotlight_development
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  worker:
    build: .
    command: bundle exec rails jobs:work
    environment:
      - DATABASE_URL=postgresql://postgres:password@db:5432/spotlight_development
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis

volumes:
  postgres_data:
  redis_data:
  bundle_cache:
```

## Database Deployment

### Migration Strategy

#### Zero-Downtime Migrations

```ruby
# Example: Adding a column with default value
class AddStatusToLeads < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    # Step 1: Add column without default
    add_column :leads, :status, :string

    # Step 2: Backfill data in batches
    Lead.in_batches.update_all(status: 'new')

    # Step 3: Add index
    add_index :leads, :status, algorithm: :concurrently

    # Step 4: Add constraint (if needed)
    change_column_null :leads, :status, false
  end
end
```

#### Migration Best Practices

1. **Additive Changes**: Add columns, don't remove
2. **Backward Compatibility**: Support old and new schemas
3. **Batched Operations**: Process large datasets in chunks
4. **Index Creation**: Use `algorithm: :concurrently`
5. **Rollback Strategy**: Plan for migration rollbacks

### Database Backup Strategy

#### Automated Backups

```bash
#!/bin/bash
# scripts/backup_database.sh

DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="spotlight_backup_${DATE}.sql"

# Create backup
pg_dump $DATABASE_URL > /backups/$BACKUP_FILE

# Compress backup
gzip /backups/$BACKUP_FILE

# Upload to S3
aws s3 cp /backups/${BACKUP_FILE}.gz s3://spotlight-backups/

# Clean up old backups (keep 30 days)
find /backups -name "*.gz" -mtime +30 -delete
```

#### Backup Schedule

- **Full Backup**: Daily at 2 AM UTC
- **Incremental Backup**: Every 6 hours
- **Point-in-Time Recovery**: Enabled with 7-day retention
- **Cross-Region Replication**: Weekly full backups

## Monitoring and Logging

### Application Monitoring

#### Health Check Endpoint

```ruby
# app/controllers/health_controller.rb
class HealthController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    checks = {
      database: database_check,
      redis: redis_check,
      queue: queue_check,
      disk_space: disk_space_check
    }

    status = checks.values.all? ? :ok : :service_unavailable
    render json: { status: status, checks: checks }, status: status
  end

  private

  def database_check
    ActiveRecord::Base.connection.execute("SELECT 1")
    { status: 'ok', response_time: measure_time { User.count } }
  rescue => e
    { status: 'error', error: e.message }
  end

  def redis_check
    Redis.current.ping
    { status: 'ok' }
  rescue => e
    { status: 'error', error: e.message }
  end

  def queue_check
    queue_size = SolidQueue::Job.pending.count
    { status: queue_size < 1000 ? 'ok' : 'warning', queue_size: queue_size }
  end

  def disk_space_check
    usage = `df -h / | tail -1 | awk '{print $5}'`.strip
    { status: usage.to_i < 80 ? 'ok' : 'warning', usage: usage }
  end

  def measure_time
    start_time = Time.current
    yield
    ((Time.current - start_time) * 1000).round(2)
  end
end
```

#### Metrics Collection

```ruby
# config/initializers/metrics.rb
require 'prometheus_exporter'
require 'prometheus_exporter/server'
require 'prometheus_exporter/middleware'

# Custom metrics
RESPONSE_TIME = PrometheusExporter::Metric::Histogram.new(
  'http_request_duration_seconds',
  'HTTP request duration'
)

ACTIVE_USERS = PrometheusExporter::Metric::Gauge.new(
  'active_users_total',
  'Number of active users'
)

CONVERSATION_COUNT = PrometheusExporter::Metric::Counter.new(
  'conversations_total',
  'Total number of conversations'
)
```

### Logging Configuration

#### Structured Logging

```ruby
# config/application.rb
config.log_formatter = proc do |severity, datetime, progname, msg|
  {
    timestamp: datetime.iso8601,
    level: severity,
    message: msg,
    service: 'spotlight-os',
    environment: Rails.env,
    request_id: Thread.current[:request_id]
  }.to_json + "\n"
end
```

#### Log Aggregation

```yaml
# config/fluent.conf
<source>
  @type tail
  path /app/log/production.log
  pos_file /tmp/production.log.pos
  tag rails.app
  format json
</source>

<match rails.**>
  @type elasticsearch
  host elasticsearch.logging.svc.cluster.local
  port 9200
  index_name spotlight-logs
  type_name _doc
</match>
```

## Security Configuration

### SSL/TLS Setup

#### Let's Encrypt with Traefik

```yaml
# traefik.yml
certificatesResolvers:
  letsencrypt:
    acme:
      email: admin@spotlight.com
      storage: acme.json
      httpChallenge:
        entryPoint: web

entryPoints:
  web:
    address: ":80"
    http:
      redirections:
        entrypoint:
          to: websecure
          scheme: https
  websecure:
    address: ":443"
```

#### Security Headers

```ruby
# config/application.rb
config.force_ssl = true
config.ssl_options = {
  hsts: { expires: 1.year, subdomains: true, preload: true },
  secure_cookies: true
}

# Content Security Policy
config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, :data
  policy.img_src     :self, :https, :data
  policy.object_src  :none
  policy.script_src  :self, :https
  policy.style_src   :self, :https, :unsafe_inline
  policy.connect_src :self, :https, "ws:", "wss:"
end
```

### Network Security

#### Firewall Configuration

```bash
# Ubuntu UFW setup
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

#### VPC Configuration (AWS)

```yaml
# terraform/vpc.tf
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "spotlight-vpc"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "spotlight-private-${count.index + 1}"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 10}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "spotlight-public-${count.index + 1}"
  }
}
```

## Performance Optimization

### Application Performance

#### Database Optimization

```ruby
# config/database.yml
production:
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000
  checkout_timeout: 5
  variables:
    statement_timeout: 30s
    lock_timeout: 10s
  prepared_statements: true
```

#### Caching Strategy

```ruby
# config/environments/production.rb
config.cache_store = :redis_cache_store, {
  url: ENV['REDIS_URL'],
  pool_size: 5,
  pool_timeout: 5,
  namespace: 'spotlight'
}

config.action_controller.perform_caching = true
config.action_controller.enable_fragment_cache_logging = true
```

#### Background Job Configuration

```ruby
# config/queue.yml
production:
  dispatchers:
    - polling_interval: 1
      batch_size: 500
  workers:
    - queues: critical,default,low
      threads: 3
      processes: 4
      polling_interval: 0.1
```

### Infrastructure Scaling

#### Auto Scaling Configuration

```yaml
# k8s/hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: spotlight-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: spotlight-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

#### Load Balancer Configuration

```nginx
# nginx.conf
upstream spotlight_app {
    least_conn;
    server app1:3000 max_fails=3 fail_timeout=30s;
    server app2:3000 max_fails=3 fail_timeout=30s;
    server app3:3000 max_fails=3 fail_timeout=30s;
}

server {
    listen 80;
    server_name spotlight.com;

    location / {
        proxy_pass http://spotlight_app;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

## Disaster Recovery

### Backup and Recovery Procedures

#### Database Recovery

```bash
# Point-in-time recovery
pg_restore --verbose --clean --no-acl --no-owner \
  --host=localhost --dbname=spotlight_production \
  spotlight_backup_20250527.sql

# Verify data integrity
psql -d spotlight_production -c "SELECT COUNT(*) FROM users;"
```

#### Application Recovery

```bash
# Rollback to previous version
kamal app stop
kamal app start --version=previous

# Verify application health
curl -f https://spotlight.com/health
```

### High Availability Setup

#### Multi-Region Deployment

```yaml
# config/deploy.yml
servers:
  web:
    - host: us-east-1.spotlight.com
      region: us-east-1
    - host: us-west-2.spotlight.com
      region: us-west-2
  worker:
    - host: worker-1.us-east-1.spotlight.com
    - host: worker-2.us-east-1.spotlight.com
```

#### Database Replication

```sql
-- Primary database configuration
ALTER SYSTEM SET wal_level = replica;
ALTER SYSTEM SET max_wal_senders = 3;
ALTER SYSTEM SET wal_keep_segments = 64;

-- Create replication user
CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'password';
```

## Maintenance Procedures

### Regular Maintenance Tasks

#### Weekly Tasks

```bash
#!/bin/bash
# scripts/weekly_maintenance.sh

# Update system packages
apt update && apt upgrade -y

# Clean up old Docker images
docker system prune -f

# Rotate logs
logrotate /etc/logrotate.conf

# Database maintenance
psql -d spotlight_production -c "VACUUM ANALYZE;"

# Clear expired sessions
bin/rails db:sessions:clear
```

#### Monthly Tasks

```bash
#!/bin/bash
# scripts/monthly_maintenance.sh

# Security updates
unattended-upgrades

# Certificate renewal check
certbot renew --dry-run

# Performance analysis
bin/rails db:analyze

# Backup verification
scripts/verify_backups.sh
```

### Emergency Procedures

#### Service Outage Response

1. **Immediate Response** (0-5 minutes)
   - Check service status
   - Review monitoring alerts
   - Assess impact scope

2. **Investigation** (5-15 minutes)
   - Check application logs
   - Review infrastructure metrics
   - Identify root cause

3. **Mitigation** (15-30 minutes)
   - Implement temporary fix
   - Scale resources if needed
   - Communicate with stakeholders

4. **Recovery** (30+ minutes)
   - Deploy permanent fix
   - Verify service restoration
   - Conduct post-mortem

#### Rollback Procedures

```bash
# Emergency rollback
kamal app stop
kamal app start --version=last-known-good

# Database rollback (if needed)
pg_restore --clean snapshot_before_deployment.sql

# Verify rollback success
scripts/health_check.sh
```

## Troubleshooting Guide

### Common Issues

#### High CPU Usage

```bash
# Identify problematic processes
htop
# Check Rails processes
ps aux | grep rails

# Application-level debugging
bin/rails runner "puts GC.stat"
```

#### Memory Leaks

```bash
# Monitor memory usage
free -h
# Check swap usage
swapon -s

# Rails memory debugging
bin/rails runner "puts ObjectSpace.count_objects"
```

#### Database Connection Issues

```bash
# Check connection pool
bin/rails dbconsole -c "SHOW max_connections;"
bin/rails dbconsole -c "SELECT count(*) FROM pg_stat_activity;"

# Reset connections
bin/rails db:pool:clear
```

#### Slow Queries

```sql
-- Enable slow query logging
ALTER SYSTEM SET log_min_duration_statement = 1000;
SELECT pg_reload_conf();

-- Analyze slow queries
SELECT query, mean_time, calls 
FROM pg_stat_statements 
ORDER BY mean_time DESC 
LIMIT 10;
```

### Performance Debugging

#### Application Profiling

```ruby
# Add to Gemfile
gem 'rack-mini-profiler'
gem 'memory_profiler'
gem 'stackprof'

# Profile specific actions
def slow_action
  StackProf.run(mode: :cpu, out: 'tmp/stackprof.dump') do
    # slow code here
  end
end
```

#### Database Query Analysis

```ruby
# Log all SQL queries
ActiveRecord::Base.logger = Logger.new(STDOUT)

# Analyze query performance
User.joins(:assistants).includes(:leads).explain
```

This deployment guide provides comprehensive coverage of deploying and maintaining Spotlight OS in production environments. Follow these procedures for reliable, secure, and scalable deployments.
