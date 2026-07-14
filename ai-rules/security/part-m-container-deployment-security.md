# Container & Deployment Security (Mandatory if using Docker/K8s)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

###  Container Security

**Docker:**
```dockerfile
# ✅ DO: Use specific version, non-root user
FROM node:18-alpine
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
USER appuser
WORKDIR /app
COPY --chown=appuser:appgroup package*.json ./
RUN npm ci --only=production
COPY --chown=appuser:appgroup . .
EXPOSE 3000
CMD ["node", "server.js"]

# ❌ DON'T: Latest tag, root user, secrets in image
FROM node:latest
COPY .env .env  # NEVER DO THIS
USER root
```

**Requirements:**
1. **Image Security:**
   - Use official images, specific versions (no `latest`)
   - Scan images: `trivy image myapp:latest`
   - Multi-stage builds (reduce attack surface)
   - Non-root user di container

2. **Runtime Security:**
   - Read-only filesystem dimana possible
   - Resource limits (CPU, memory)
   - Network policies (restrict container communication)
   - Secrets via environment variables atau secrets manager (bukan file di image)

3. **Orchestration (Kubernetes):**
   - Pod Security Policies (restrict privileges)
   - Network Policies (zero-trust networking)
   - RBAC (Role-Based Access Control)
   - Secrets encryption at rest (etcd encryption)
   - Audit logging enabled

---

Kembali ke [Index](./README.md)
