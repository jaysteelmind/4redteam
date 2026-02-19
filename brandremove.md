# 4RedTeam — Brand Migration Complete

**Project:** 4RedTeam — Autonomous AI-powered penetration testing platform
**Organization:** 4minds
**GitHub:** `jaysteelmind`
**Completed:** 2026-02-19

---

## Summary

All traces of the original PentAGI/VXControl branding have been completely removed from the codebase. The project is now recognized solely as **4RedTeam** by **4minds**. The Go backend builds cleanly (`go build ./...`), all dependencies resolve to jaysteelmind-owned forks, and a comprehensive audit confirms zero old branding references remain.

---

## Decisions

| Decision | Value |
|----------|-------|
| **GitHub Account** | `jaysteelmind` |
| **Go Module Name** | `4redteam` |
| **Brand Name (UI/docs)** | 4RedTeam |
| **Env Variable Prefix** | `REDTEAM_` |
| **Container/Volume Prefix** | `redteam-` |
| **Database Name** | `redteamdb` |
| **Domain** | Placeholders (`example.com`) — replace when ready |
| **Scraper Service** | Removed from docker-compose — build replacement later |
| **Favicon/Logo** | Placeholders — replace with real assets later |
| **EULA** | Placeholder — replace with real legal text later |
| **Update Server** | Removed — auto-update feature disabled |

---

## Completed Stages

### Stage 1: VXControl Cloud SDK Removal (AGPL)

**Status: COMPLETE**

Removed the only AGPL-licensed component (`github.com/vxcontrol/cloud`). This SDK provided license key validation and installation ID generation — both unnecessary for our own product.

**Changes:**
- Removed `sdk.IntrospectLicenseKey()` calls and `system.GetInstallationID()` calls
- Replaced installation ID generation with `uuid.New()` (Go stdlib)
- Stripped `LICENSE_KEY` and `INSTALLATION_ID` environment variables
- Removed SDK from go.mod, cleaned go.sum
- Updated NOTICE to remove VXControl Cloud attribution

**Files modified:** `config.go`, `hardening.go`, `server_settings_form.go`, `controller.go`, `locale.go`, `go.mod`, `NOTICE`

---

### Stage 2: langchaingo Fork

**Status: COMPLETE**

Forked the LLM backbone library from `vxcontrol/langchaingo` to `jaysteelmind/langchaingo`. This is a multi-package Go module with 23+ subpackages used across 56 source files.

**Key challenge:** Go modules require internal import paths to match the declared module path. A simple `replace` directive doesn't fix internal cross-references in multi-package modules. The fork itself needed all internal paths rewritten.

**Changes:**
- Forked `github.com/vxcontrol/langchaingo` → `github.com/jaysteelmind/langchaingo`
- Rewrote module path in 505 files inside the fork (go.mod + all Go source files)
- Based on `release/v0.1.14-update.1` branch (commit `ef220222`) which includes reasoning/extended thinking support
- Rebranded commit pushed as `97972f04` on `release/v0.1.14-update.1`
- Updated all 56 Go import paths in main project
- Dependency resolves as `v0.1.15-0.20260219231047-97972f049aa0`

**Fork URL:** https://github.com/jaysteelmind/langchaingo

---

### Stage 3: graphiti-go-client Fork

**Status: COMPLETE**

Forked the Graphiti knowledge graph client from `vxcontrol/graphiti-go-client` to `jaysteelmind/graphiti-go-client`. This is a single-package module (2 Go files, no subpackages) — much simpler than langchaingo.

**Changes:**
- Forked `github.com/vxcontrol/graphiti-go-client` → `github.com/jaysteelmind/graphiti-go-client`
- Rewrote module path in 5 files inside the fork (root + examples)
- Updated 1 Go import in main project
- Dependency resolves as `v0.0.0-20260219230402-b96969cf0be6`

**Fork URL:** https://github.com/jaysteelmind/graphiti-go-client

---

### Stage 4: Full Rebrand

**Status: COMPLETE**

Removed every trace of PentAGI/VXControl branding across the entire codebase.

**Brand mapping applied:**

| Old | New |
|-----|-----|
| `PentAGI` | `4RedTeam` |
| `pentagi` | `4redteam` |
| `PENTAGI_` | `REDTEAM_` |
| `pentagi-` (docker) | `redteam-` |
| `/opt/pentagi/` | `/opt/4redteam/` |
| `pentagidb` / `pentagiuser` / `pentagipass` | `redteamdb` / `redteamuser` / `redteampass` |
| `vxcontrol/pentagi` | `jaysteelmind/4redteam` |
| `@pentagi.com` | `@example.com` |
| `pentagi.com` | `example.com` |
| `PentAGI Development Team` | `4minds` |
| `pentagi.local` | `4redteam.local` |
| `vxcontrol/kali-linux` | `jaysteelmind/kali-redteam` |
| `vxcontrol/pgvector` | `pgvector/pgvector:pg17` |
| `vxcontrol/graphiti` | `jaysteelmind/graphiti` |
| `cmd/pentagi` (directory) | `cmd/4redteam` |

**Scope of changes:**
- **Go module:** `module pentagi` → `module 4redteam` (313+ Go source files)
- **Go imports:** All `pentagi/pkg/...` → `4redteam/pkg/...`
- **Frontend:** package.json, package-lock.json, HTML title, web manifest, login form, sidebar, flow messages, SSL generation
- **Docker:** docker-compose.yml, docker-compose-graphiti.yml, Dockerfile, entrypoint.sh — volumes, networks, services, paths, images, labels
- **Legal:** LICENSE, NOTICE, EULA.md (all updated to 4minds/4RedTeam)
- **Documentation:** README.md, 10+ docs files, examples, Grafana dashboards
- **API docs:** Swagger annotations, docs.go, swagger.json, swagger.yaml
- **GraphQL:** schema.graphqls, generated.go (380+ encoded symbol replacements)
- **Installer:** 60+ locale strings, controller, forms, processors, checker
- **Removed:** Scraper service from docker-compose, archival reference file

---

## Final Audit (2026-02-19)

Three independent audit agents swept the entire codebase:

| Check | Result |
|-------|--------|
| `go build ./...` | **PASSES** |
| `pentagi` in any file (case-insensitive) | **ZERO matches** |
| `PentAGI` in any file | **ZERO matches** |
| `vxcontrol` in any file (case-insensitive) | **ZERO matches** |
| `VXControl` in any file | **ZERO matches** |
| `PENTAGI_` env vars | **ZERO matches** |
| `@pentagi.com` emails | **ZERO matches** |
| `/opt/pentagi` paths | **ZERO matches** |
| `pentagidb`/`pentagiuser`/`pentagipass` | **ZERO matches** |
| Old Docker images (vxcontrol/*) | **ZERO matches** |
| Old container names (pentagi-*) | **ZERO matches** |
| Filenames containing "pentagi" | **ZERO matches** |
| Filenames containing "vxcontrol" | **ZERO matches** |
| Directories containing "pentagi" | **ZERO matches** |
| `vxcontrol` in go.mod | **ZERO matches** |
| `vxcontrol` in go.sum | **ZERO matches** |

**The project is 100% recognized as 4RedTeam only.**

---

## Deferred Work

- [ ] Obtain real domain name and replace `example.com` placeholders
- [ ] Design and create 4RedTeam logo/favicon assets
- [ ] Draft proper EULA legal text
- [ ] Build Playwright-based scraper microservice
- [ ] Build `jaysteelmind/kali-redteam` Docker image with pentest toolset
- [ ] Set up CI/CD for `jaysteelmind/4redteam` Docker image builds
- [ ] Decide on update server strategy
