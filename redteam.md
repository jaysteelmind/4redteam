# 4RedTeam — Deployment Readiness Report

**Date:** 2026-02-19
**Repository:** github.com/jaysteelmind/4redteam
**Status:** NOT READY FOR PRODUCTION — requires fixes listed below

---

## What Works

| Component | Status | Notes |
|-----------|--------|-------|
| Go backend build | PASSES | `go build ./...` compiles cleanly with Go 1.24.1 |
| Go dependencies | RESOLVED | All deps point to jaysteelmind forks, zero vxcontrol refs |
| Database migrations | PRESENT | 20 migration files under `backend/migrations/sql/` |
| Dockerfile | VALID | Multi-stage build (Node 23 + Go 1.24 + Alpine 3.23.3) |
| Docker Compose (core) | VALID | 3 services: 4redteam, pgvector, pgexporter |
| Docker Compose (graphiti) | VALID | Neo4j + Graphiti knowledge graph stack |
| Docker Compose (langfuse) | VALID | LLM observability stack |
| Docker Compose (observability) | VALID | Prometheus + Grafana monitoring |
| SSL generation | WORKS | entrypoint.sh auto-generates self-signed certs |
| Provider configs | PRESENT | 10 example configs under `examples/configs/` |
| Frontend source | PRESENT | React 19 + TypeScript + Vite + Tailwind |
| GraphQL schema | VALID | Schema + generated resolvers present |
| Branding | CLEAN | Zero traces of old PentAGI/VXControl branding |

---

## Critical Blockers

These must be fixed before the first deployment.

### 1. Missing `.env.example` file

**Impact:** Users have no reference for the 80+ environment variables needed to run the platform. The installer also creates a symlink to `.env.example` that currently points to nothing.

**Fix:** Create `.env.example` in the project root with all variables from `docker-compose.yml` documented with comments and safe defaults. At minimum:

```
# LLM Providers (at least one required)
OPEN_AI_KEY=
ANTHROPIC_API_KEY=

# Database
REDTEAM_POSTGRES_USER=postgres
REDTEAM_POSTGRES_PASSWORD=changeme
REDTEAM_POSTGRES_DB=redteamdb

# Server
REDTEAM_LISTEN_IP=127.0.0.1
REDTEAM_LISTEN_PORT=8443
SERVER_USE_SSL=true
PUBLIC_URL=https://localhost:8443
```

### 2. Missing Docker images on Docker Hub

**Impact:** `docker compose up` will fail immediately — the images don't exist.

| Image | Referenced In | Status |
|-------|---------------|--------|
| `jaysteelmind/4redteam:latest` | docker-compose.yml:22 | DOES NOT EXIST |
| `jaysteelmind/kali-redteam:latest` | testdata.go (default pentest image) | DOES NOT EXIST |
| `jaysteelmind/graphiti:latest` | docker-compose-graphiti.yml | DOES NOT EXIST |

**Fix options:**
- **Option A:** Build and push images via CI/CD (GitHub Actions)
- **Option B:** Build locally with `docker build -t jaysteelmind/4redteam:latest .` and use `docker compose up` without pulling

### 3. Missing volume mount files in root directory

**Impact:** Docker Compose will fail on startup — it mounts files that don't exist.

| File Referenced | Compose Line | Purpose |
|-----------------|--------------|---------|
| `./example.custom.provider.yml` | docker-compose.yml:143 | Custom LLM provider config |
| `./example.ollama.provider.yml` | docker-compose.yml:144 | Ollama provider config |
| `./docker-ssl/` | docker-compose.yml:145 | Docker TLS certificates |

**Fix:** Create placeholder files in root:
```bash
touch example.custom.provider.yml
touch example.ollama.provider.yml
mkdir -p docker-ssl
```

Or better — copy from existing examples:
```bash
cp examples/configs/custom-openai.provider.yml example.custom.provider.yml
cp examples/configs/ollama-llama318b.provider.yml example.ollama.provider.yml
```

---

## High Priority Issues

These won't prevent startup but will cause runtime failures or broken UI.

### 4. Font filename typos in CSS

**File:** `frontend/src/styles/index.css`

Two font references have double hyphens that don't match the actual filenames:

| CSS Reference (broken) | Actual File on Disk |
|------------------------|---------------------|
| `/fonts/inter--italic.woff2` (line 21) | `/fonts/inter-italic.woff2` |
| `/fonts/roboto-mono--italic.woff2` (line 85) | `/fonts/roboto-mono-italic.woff2` |

**Impact:** Italic fonts won't load — text falls back to browser default italic rendering.

**Fix:** Remove the extra hyphen in both references.

### 5. Hardcoded `admin@example.com` default email

**File:** `backend/cmd/installer/processor/pg.go:23`

```go
AdminEmail = "admin@example.com"
```

This is also baked into the initial database migration. The admin account will be created with a placeholder email.

**Fix:** Either make this configurable via env var (`REDTEAM_ADMIN_EMAIL`) or document that users must change it after first login.

### 6. Nonexistent model `gpt-5-mini` in Graphiti config

**File:** `docker-compose-graphiti.yml:68`

```yaml
MODEL_NAME: ${GRAPHITI_MODEL_NAME:-gpt-5-mini}
```

`gpt-5-mini` does not exist. This will cause Graphiti to fail on startup if no model override is provided.

**Fix:** Change default to a real model: `gpt-4o-mini` or `gpt-4.1-mini`.

### 7. Migration file with space in name

**File:** `backend/migrations/sql/20250412_181121_subtask_context copy.sql`

The space in the filename may cause issues with some migration runners and will definitely cause problems in shell scripts without proper quoting.

**Fix:** Rename to `20250412_181121_subtask_context_copy.sql` or determine if this is a duplicate that should be deleted.

### 8. Insecure Langfuse defaults

**File:** `docker-compose-langfuse.yml`

| Variable | Default Value | Risk |
|----------|---------------|------|
| `ENCRYPTION_KEY` | `0000...0000` (64 zeros) | All Langfuse data encrypted with null key |
| `LANGFUSE_INIT_USER_PASSWORD` | `P3nTagIsD0d` | Contains old branding, weak password |
| `LANGFUSE_POSTGRES_PASSWORD` | `postgres` | Default password |

**Fix:** Generate real defaults or require these to be set in `.env`:
```
LANGFUSE_ENCRYPTION_KEY=<generate with: openssl rand -hex 32>
LANGFUSE_INIT_USER_PASSWORD=<strong password>
LANGFUSE_POSTGRES_PASSWORD=<strong password>
```

Note: The password `P3nTagIsD0d` also contains a trace of old branding (PentAGI → P3nTagI).

---

## Medium Priority Issues

### 9. Unimplemented installer update functions

**File:** `backend/cmd/installer/processor/update.go`

Three functions are stubbed with TODO comments:
- `downloadInstaller()` — line 61
- `updateInstaller()` — line 86
- `removeInstaller()` — line 99

The installer's self-update feature is non-functional. The update server was removed during rebranding.

**Fix:** Either implement these functions or remove the update UI/routes entirely to avoid confusing users.

### 10. Unimplemented ftester tool functions

**File:** `backend/cmd/ftester/worker/executor.go:358`

```go
return nil, fmt.Errorf("TODO: tool for function %s is not implemented yet", funcName)
```

The function tester utility will return runtime errors for unimplemented tool types.

**Fix:** Implement the missing tool handlers or return a more graceful error.

### 11. Scraper service removed but still referenced

The scraper service was removed from docker-compose during rebranding, but environment variables still reference it:

```yaml
SCRAPER_PUBLIC_URL=${SCRAPER_PUBLIC_URL:-}
SCRAPER_PRIVATE_URL=${SCRAPER_PRIVATE_URL:-}
```

**Fix:** Keep the env vars (they default to empty and won't break anything) but document that the scraper is not included and must be built separately.

---

## Deployment Checklist

### Before First Deploy

- [ ] Create `.env.example` with all variables documented
- [ ] Create `example.custom.provider.yml` in root (copy from `examples/configs/custom-openai.provider.yml`)
- [ ] Create `example.ollama.provider.yml` in root (copy from `examples/configs/ollama-llama318b.provider.yml`)
- [ ] Create `docker-ssl/` directory (even if empty — volume mount requires it)
- [ ] Fix font filename typos in `frontend/src/styles/index.css` (remove double hyphens)
- [ ] Change `gpt-5-mini` default to `gpt-4o-mini` in `docker-compose-graphiti.yml`
- [ ] Change Langfuse default password from `P3nTagIsD0d` to something neutral
- [ ] Rename migration file to remove space: `subtask_context copy.sql` → `subtask_context_copy.sql`
- [ ] Build Docker image: `docker build -t jaysteelmind/4redteam:latest .`

### Before Public Release

- [ ] Push `jaysteelmind/4redteam:latest` to Docker Hub
- [ ] Build and push `jaysteelmind/kali-redteam:latest` (Kali Linux with pentest tools)
- [ ] Build and push `jaysteelmind/graphiti:latest` (knowledge graph service)
- [ ] Set up GitHub Actions CI/CD for automated image builds
- [ ] Replace `admin@example.com` with configurable admin email
- [ ] Implement or remove installer self-update feature
- [ ] Obtain real domain and replace `example.com` placeholders
- [ ] Design 4RedTeam logo and favicon
- [ ] Draft proper EULA legal text
- [ ] Build Playwright-based scraper microservice
- [ ] Generate real Langfuse encryption key for production defaults

---

## Quick Start (Once Blockers Are Fixed)

```bash
# Clone
git clone https://github.com/jaysteelmind/4redteam.git
cd 4redteam

# Configure
cp .env.example .env
# Edit .env — add at least one LLM API key

# Create required mount files
cp examples/configs/custom-openai.provider.yml example.custom.provider.yml
cp examples/configs/ollama-llama318b.provider.yml example.ollama.provider.yml
mkdir -p docker-ssl

# Build and run
docker build -t jaysteelmind/4redteam:latest .
docker compose up -d

# Access
open https://localhost:8443
```

### With Graphiti (knowledge graph)

```bash
docker compose -f docker-compose.yml -f docker-compose-graphiti.yml up -d
```

### With Langfuse (LLM observability)

```bash
docker compose -f docker-compose.yml -f docker-compose-langfuse.yml up -d
```

### With full observability stack

```bash
docker compose -f docker-compose.yml \
  -f docker-compose-langfuse.yml \
  -f docker-compose-graphiti.yml \
  -f docker-compose-observability.yml up -d
```

---

## Architecture Summary

```
                    HTTPS :8443
                        |
                   [4RedTeam Container]
                   /        |        \
            [React SPA]  [Go API]  [SSL Gen]
                           |
              +------------+------------+
              |            |            |
         [pgvector]   [Docker API]  [LLM APIs]
         PostgreSQL    Kali Linux   OpenAI/Anthropic/
           + vectors   containers   Gemini/Bedrock/
                                    Ollama/Custom
```

**Core stack:** Go 1.24 + React 19 + PostgreSQL (pgvector) + Docker-in-Docker

**Optional stacks:**
- Graphiti: Neo4j knowledge graph for long-term agent memory
- Langfuse: LLM call tracing and cost tracking
- Observability: Prometheus + Grafana for infrastructure monitoring
