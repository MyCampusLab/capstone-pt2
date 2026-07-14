# Monitoring Setup — {Monitoring Stack}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Output Location:** `{apps|backend|frontend}/docs/operations/monitoring/` — **INSIDE git repo. DILARANG menulis credential aktual (password, token, API key, server IP). Gunakan referensi .env atau prod-docs/.**
> **Purpose:** Dokumentasi setup monitoring, alerting, dan observability

---

## Overview

**Monitoring Stack:** {Prometheus + Grafana / Datadog / New Relic / Custom}  
**Metrics:** {Application metrics, server metrics, custom metrics}  
**Alerting:** {Email / Slack / PagerDuty / SMS}

---

## Prometheus + Grafana (Self-Hosted)

### Overview

Prometheus untuk metrics collection dan storage. Grafana untuk visualization dan alerting.

### Prerequisites

- Docker dan Docker Compose terinstall
- Server dengan minimal 2GB RAM
- Firewall rules untuk Prometheus (9090) dan Grafana (3000)

### Setup

**1. Create docker-compose.yml:**

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=30d'
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}
      - GF_SECURITY_ADMIN_USER=${GRAFANA_ADMIN_USER}
    volumes:
      - grafana_data:/var/lib/grafana
    restart: unless-stopped

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    restart: unless-stopped

volumes:
  prometheus_data:
  grafana_data:
```

**2. Create prometheus.yml:**

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: '{project_name}'
    static_configs:
      - targets: ['{app_host}:{metrics_port}']
    metrics_path: '/metrics'
```

**3. Start monitoring stack:**

```bash
docker-compose up -d
```

**4. Access:**
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (credentials: See .env: GRAFANA_ADMIN_USER / GRAFANA_ADMIN_PASSWORD)

---

## Application Metrics Endpoint

### Laravel (with spatie/laravel-prometheus)

**Installation:**
```bash
composer require spatie/laravel-prometheus
php artisan vendor:publish --provider="Spatie\Prometheus\PrometheusServiceProvider"
```

**Config:** `config/prometheus.php`
```php
return [
    'enabled' => env('PROMETHEUS_ENABLED', true),
    'url' => '/metrics',
    'middleware' => [], // Add auth middleware if needed
];
```

**Add custom metrics:**
```php
// app/Providers/AppServiceProvider.php
use Spatie\Prometheus\Collectors\Collector;
use Prometheus\Counter;
use Prometheus\Gauge;

class AppServiceProvider extends ServiceProvider
{
    public function boot()
    {
        // Register custom collectors
        Prometheus::registerCollector(new class implements Collector {
            public function registerMetrics(): void
            {
                $counter = new Counter([
                    'namespace' => 'myapp',
                    'name' => 'orders_total',
                    'help' => 'Total number of orders',
                    'labelNames' => ['status'],
                ]);
                
                $counter->labels(['completed'])->incBy(100);
                $counter->labels(['pending'])->incBy(50);
            }
        });
    }
}
```

### Node.js (with prom-client)

**Installation:**
```bash
npm install prom-client
```

**Setup:**
```javascript
// src/metrics/index.js
const client = require('prom-client');

// Create a Registry
const register = new client.Registry();

// Add default metrics
client.collectDefaultMetrics({ register });

// Custom metrics
const httpRequestDuration = new client.Histogram({
    name: 'http_request_duration_seconds',
    help: 'Duration of HTTP requests in seconds',
    labelNames: ['method', 'route', 'status_code'],
    buckets: [0.1, 0.5, 1, 2, 5]
});

register.registerMetric(httpRequestDuration);

const ordersTotal = new client.Counter({
    name: 'orders_total',
    help: 'Total number of orders',
    labelNames: ['status']
});

register.registerMetric(ordersTotal);

// Middleware to track request duration
const metricsMiddleware = (req, res, next) => {
    const end = httpRequestDuration.startTimer();
    res.on('finish', () => {
        end({ method: req.method, route: req.route?.path || req.path, status_code: res.statusCode });
    });
    next();
};

// Endpoint to expose metrics
const metricsHandler = async (req, res) => {
    res.set('Content-Type', register.contentType);
    res.end(await register.metrics());
};

module.exports = { metricsMiddleware, metricsHandler, ordersTotal };
```

**Use in Express:**
```javascript
// src/app.js
const express = require('express');
const { metricsMiddleware, metricsHandler } = require('./metrics');

const app = express();

// Metrics middleware
app.use(metricsMiddleware);

// Metrics endpoint
app.get('/metrics', metricsHandler);

// Your routes
// ...
```

### Go (with prometheus/client_golang)

**Installation:**
```bash
go get github.com/prometheus/client_golang/prometheus
go get github.com/prometheus/client_golang/prometheus/promhttp
```

**Setup:**
```go
// internal/metrics/metrics.go
package metrics

import (
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promauto"
)

var (
    OrdersTotal = promauto.NewCounterVec(
        prometheus.CounterOpts{
            Name: "orders_total",
            Help: "Total number of orders",
        },
        []string{"status"},
    )
    
    RequestDuration = promauto.NewHistogramVec(
        prometheus.HistogramOpts{
            Name:    "http_request_duration_seconds",
            Help:    "Duration of HTTP requests in seconds",
            Buckets: prometheus.DefBuckets,
        },
        []string{"method", "path", "status"},
    )
)
```

**Use in HTTP handler:**
```go
// cmd/server/main.go
package main

import (
    "net/http"
    "time"
    
    "github.com/prometheus/client_golang/prometheus/promhttp"
    "your-project/internal/metrics"
)

func main() {
    // Metrics endpoint
    http.Handle("/metrics", promhttp.Handler())
    
    // Your handlers with metrics
    http.HandleFunc("/orders", func(w http.ResponseWriter, r *http.Request) {
        start := time.Now()
        
        // Process request
        w.WriteHeader(http.StatusOK)
        
        // Record metrics
        duration := time.Since(start).Seconds()
        metrics.RequestDuration.WithLabelValues(r.Method, "/orders", "200").Observe(duration)
        metrics.OrdersTotal.WithLabelValues("completed").Inc()
    })
    
    http.ListenAndServe(":8080", nil)
}
```

---

## Grafana Dashboards

### Import Pre-built Dashboards

**1. Access Grafana:**
```
http://localhost:3000
```

**2. Add Prometheus data source:**
- Configuration → Data Sources → Add data source
- Select Prometheus
- URL: http://prometheus:9090
- Save & Test

**3. Import dashboards:**
- Create → Import
- Use dashboard ID from grafana.com:
  - Node Exporter Full: 1860
  - Laravel Metrics: 14595
  - Node.js Application: 11159
  - Go Application: 12559

### Custom Dashboard Example

**Dashboard JSON:** `docs/operations/monitoring/grafana-dashboard.json`

```json
{
  "dashboard": {
    "title": "{Project Name} - Application Metrics",
    "panels": [
      {
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])"
          }
        ]
      },
      {
        "title": "Error Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total{status=~\"5..\"}[5m])"
          }
        ]
      },
      {
        "title": "Request Duration (p95)",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))"
          }
        ]
      }
    ]
  }
}
```

---

## Alerting

### Prometheus Alert Rules

**File:** `alert.rules.yml`

```yaml
groups:
  - name: application
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value }} errors per second"
      
      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High latency detected"
          description: "95th percentile latency is {{ $value }}s"
      
      - alert: LowDiskSpace
        expr: (node_filesystem_avail_bytes / node_filesystem_size_bytes) < 0.1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Low disk space"
          description: "Disk {{ $labels.mountpoint }} is {{ $value | humanizePercentage }} full"
```

### Alertmanager Configuration

**File:** `alertmanager.yml`

```yaml
global:
  smtp_smarthost: '${SMTP_HOST}:${SMTP_PORT}'
  smtp_from: '${ALERT_FROM_EMAIL}'
  smtp_auth_username: '${SMTP_USERNAME}'
  smtp_auth_password: '${SMTP_PASSWORD}'

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'email'

receivers:
  - name: 'email'
    email_configs:
      - to: '${ALERT_TO_EMAIL}'
        send_resolved: true
  
  - name: 'slack'
    slack_configs:
      - api_url: '${SLACK_WEBHOOK_URL}'
        channel: '#alerts'
        send_resolved: true
```

---

## Verification

**1. Check Prometheus targets:**
```
http://localhost:9090/targets
```

**2. Check metrics endpoint:**
```bash
curl http://localhost:{metrics_port}/metrics
```

**3. Check Grafana dashboards:**
```
http://localhost:3000
```

**4. Test alert:**
```bash
# Trigger test alert
curl -X POST http://localhost:9090/api/v1/alerts \
  -H "Content-Type: application/json" \
  -d '[{"labels":{"alertname":"TestAlert","severity":"test"},"annotations":{"summary":"Test alert"}}]'
```

---

## Troubleshooting

### Metrics endpoint tidak accessible

**Symptom:** curl returns 404 or connection refused

**Solutions:**
1. Check if metrics endpoint is configured
2. Check firewall rules
3. Check application logs

### Prometheus tidak scrape metrics

**Symptom:** Targets show "DOWN" in Prometheus UI

**Solutions:**
1. Check prometheus.yml configuration
2. Check if metrics endpoint is accessible from Prometheus container
3. Check network connectivity

### Grafana tidak connect ke Prometheus

**Symptom:** Data source test fails

**Solutions:**
1. Check Prometheus URL (use container name, not localhost)
2. Check if Prometheus is running
3. Check network connectivity

---

## Auto-Setup Script

**Script:** `{project_path}/docs/operations/scripts/setup-monitoring.sh`

```bash
#!/bin/bash
# Setup monitoring stack

PROJECT_PATH="{project_path}"
MONITORING_PATH="$PROJECT_PATH/docs/operations/monitoring"

# Create monitoring directory
mkdir -p $MONITORING_PATH

# Copy docker-compose files
cp $MONITORING_PATH/docker-compose.yml ./

# Start monitoring stack
docker-compose up -d

# Wait for services to start
sleep 10

# Check status
docker-compose ps

echo "Monitoring stack started"
echo "Prometheus: http://localhost:9090"
echo "Grafana: http://localhost:3000 (credentials: See .env)"
```

**Run (auto-setup mode):**
```bash
bash {project_path}/docs/operations/scripts/setup-monitoring.sh
```

**Run (manual-setup mode):**
```bash
# Copy commands dari script dan jalankan manual
```
