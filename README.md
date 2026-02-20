<div align="center">

# 4RedTeam

### Autonomous Multi-Agent Penetration Testing Platform with Adaptive Memory and Knowledge Graph Intelligence

[![Go](https://img.shields.io/badge/go-1.24-blue)]()
[![React](https://img.shields.io/badge/react-19-blue)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()
[![Docker](https://img.shields.io/badge/docker-compose-2496ED)]()
[![Providers](https://img.shields.io/badge/LLM%20providers-8%2B-orange)]()

*Orchestrated AI agent teams executing real-world security assessments in sandboxed environments*
**Created By: Jerome Naidoo**

[Overview](#overview) • [Architecture](#architecture) • [Key Capabilities](#key-capabilities) • [Quick Start](#quick-start) • [Configuration](#configuration) • [Development](#development) • [Documentation](#documentation)

</div>

---

## Overview

Penetration testing remains one of the most labor-intensive disciplines in cybersecurity. Skilled operators spend hours on reconnaissance, tool selection, exploit chaining, and report generation — cognitive work that follows discoverable patterns but resists simple automation.

**4RedTeam** approaches this problem by deploying **coordinated teams of specialized AI agents** that plan, research, execute, and adapt in real time. Rather than scripting known attack sequences, the system reasons about targets, selects appropriate tools, interprets results, and adjusts strategy — mirroring the decision-making process of an experienced penetration tester.

Each agent operates within a fully isolated Docker environment with access to professional security tooling. All actions, observations, and conclusions are persisted in a vector-indexed memory system and an optional temporal knowledge graph, enabling the platform to learn from previous engagements and apply accumulated expertise to new assessments.

This is not a vulnerability scanner. It is an autonomous reasoning system that conducts security research.

---

## The Problem with Current Approaches

Existing automated security tools operate at opposite extremes:

| Approach | Limitation |
|----------|-----------|
| **Vulnerability Scanners** | Signature-based detection with no reasoning — high false positive rates, no exploit chaining |
| **Script Collections** | Rigid playbooks that cannot adapt to unexpected configurations or defenses |
| **Single-Agent LLM Tools** | No specialization, no memory, no delegation — context window exhaustion on complex targets |
| **Manual Pentesting** | Gold standard for quality, but prohibitively expensive for continuous assessment |

4RedTeam occupies the gap between manual expertise and automated tooling by combining multi-agent coordination, persistent memory, and sandboxed execution into a system that reasons about security the way operators do.

---

## Architecture

4RedTeam operates as a **multi-tier platform** with isolated execution, persistent knowledge, and full observability:

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                            4REDTEAM PLATFORM                                     │
├──────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│   │   Frontend    │    │   Backend    │    │  Agent Pool  │    │  Exec Layer  │  │
│   │              │    │              │    │              │    │              │  │
│   │  React 19    │───▶│  Go / Gin    │───▶│  Orchestrator│───▶│  Docker API  │  │
│   │  TypeScript  │    │  GraphQL     │    │  Researcher  │    │  Sandboxed   │  │
│   │  Apollo GQL  │    │  REST / WS   │    │  Developer   │    │  Containers  │  │
│   │  Tailwind    │    │  Auth / OIDC │    │  Pentester   │    │  20+ Tools   │  │
│   └──────────────┘    └──────┬───────┘    └──────┬───────┘    └──────────────┘  │
│                              │                   │                               │
│   ┌──────────────────────────┴───────────────────┴────────────────────────────┐  │
│   │                         DATA & KNOWLEDGE LAYER                            │  │
│   ├───────────────┬────────────────┬──────────────────┬──────────────────────┤  │
│   │  PostgreSQL   │  Vector Store  │  Knowledge Graph │  Chain Summarizer   │  │
│   │  + pgvector   │  Embeddings    │  Neo4j/Graphiti  │  Context Management │  │
│   │  Persistence  │  Semantic Search│  Temporal Rels   │  Token Optimization │  │
│   └───────────────┴────────────────┴──────────────────┴──────────────────────┘  │
│                                                                                  │
│   ┌──────────────────────────────────────────────────────────────────────────┐  │
│   │                         OBSERVABILITY LAYER                               │  │
│   ├──────────────┬──────────────┬───────────────┬────────────────────────────┤  │
│   │  Langfuse    │  Grafana     │  OpenTelemetry│  Jaeger / Loki /          │  │
│   │  LLM Traces  │  Dashboards  │  Collection   │  VictoriaMetrics          │  │
│   └──────────────┴──────────────┴───────────────┴────────────────────────────┘  │
│                                                                                  │
└──────────────────────────────────────────────────────────────────────────────────┘
```

### Component Breakdown

| Layer | Components | Purpose |
|-------|-----------|---------|
| **Frontend** | React 19, TypeScript, Apollo Client, Tailwind CSS | Real-time flow monitoring, configuration, and reporting |
| **Backend** | Go 1.24, Gin, gqlgen (GraphQL), Swagger (REST) | API gateway, auth (OIDC/OAuth), task orchestration, WebSocket streams |
| **Agent Pool** | 13 specialized agent types with role-based LLM routing | Autonomous planning, research, code generation, exploitation, reporting |
| **Exec Layer** | Docker API, on-demand container provisioning | Sandboxed tool execution with network isolation and capability control |
| **Data Layer** | PostgreSQL + pgvector, Neo4j + Graphiti | Persistent storage, semantic search, temporal knowledge graph |
| **Observability** | Langfuse, Grafana, OpenTelemetry, Jaeger, Loki | LLM tracing, metrics, distributed traces, log aggregation |

---

## Key Capabilities

### Multi-Agent Coordination

The system deploys **13 specialized agent types**, each optimized for a distinct phase of the assessment lifecycle:

| Agent | Role | Capability |
|-------|------|-----------|
| **Orchestrator** | Primary reasoning and task decomposition | Breaks complex objectives into subtasks, delegates to specialists |
| **Researcher** | Target analysis and reconnaissance | Gathers intelligence, identifies attack surfaces, maps infrastructure |
| **Pentester** | Exploitation and vulnerability validation | Executes security tools, chains exploits, validates findings |
| **Developer** | Payload and script generation | Writes custom exploits, scripts, and automation |
| **Coder** | Code analysis and generation | Reviews source code, identifies vulnerabilities, generates patches |
| **Adviser** | Strategic guidance and expert consultation | Provides domain expertise and recommends attack vectors |
| **Searcher** | Multi-source information gathering | Queries search engines, web sources, and knowledge bases |
| **Enricher** | Data enrichment and context expansion | Augments findings with additional intelligence |
| **Reflector** | Self-analysis and quality assessment | Reviews agent outputs for accuracy and completeness |
| **Refiner** | Content improvement and optimization | Polishes reports, refines exploit code, improves accuracy |
| **Generator** | Content and report creation | Produces vulnerability reports with exploitation guides |
| **Assistant** | Interactive user support | Handles direct user queries with optional agent delegation |
| **Installer** | Environment setup and configuration | Manages tool installation and container provisioning |

Each agent type can be mapped to a different LLM model, allowing cost/performance optimization per role.

### Adaptive Memory System

Three-tier memory architecture ensures agents learn and retain context across sessions:

| Memory Type | Storage | Function |
|-------------|---------|----------|
| **Long-term Memory** | PostgreSQL + pgvector | Persistent vector-indexed storage of research, exploits, and domain knowledge |
| **Working Memory** | In-context with chain summarization | Active task state, goals, and current observations with intelligent context compression |
| **Episodic Memory** | Knowledge Graph (Neo4j/Graphiti) | Temporal relationships between tools, targets, techniques, and outcomes |

The **chain summarization engine** manages LLM context growth by selectively compressing older conversation sections while preserving critical reasoning chains — preventing token exhaustion on complex, multi-step engagements.

### Sandboxed Execution Environment

All tool execution occurs inside isolated Docker containers:

- **On-demand provisioning** — containers spawned per-flow with configurable images
- **Capability control** — `NET_RAW` for network operations, optional `NET_ADMIN`
- **20+ professional tools** — nmap, metasploit, sqlmap, nikto, gobuster, hydra, and more
- **Network isolation** — dedicated Docker networks with configurable boundaries
- **Two-node architecture** — optional worker node for complete execution isolation

### LLM Provider Flexibility

Connect to any combination of providers with per-agent model routing:

| Provider | Models | Notes |
|----------|--------|-------|
| **OpenAI** | GPT-4.1, o1, o3, o4-mini | Reasoning models for complex analysis |
| **Anthropic** | Claude 4, Sonnet, Haiku | Extended thinking for methodical research |
| **Google AI** | Gemini 2.5 Pro/Flash | Up to 2M token context windows |
| **AWS Bedrock** | Claude, Nova, Llama, Titan | Enterprise-grade with VPC integration |
| **Ollama** | Llama, Qwen, QwQ, any GGUF | Zero-cost local inference |
| **DeepSeek** | DeepSeek R1, V3 | Cost-effective reasoning |
| **OpenRouter** | 200+ models | Multi-provider aggregation |
| **Custom** | Any OpenAI-compatible API | LiteLLM proxy, vLLM, any endpoint |

### Search Intelligence

Integrated search across multiple engines for comprehensive reconnaissance:

- **Tavily** — AI-optimized search with structured results
- **Perplexity** — AI-powered answers with source citations
- **Traversaal** — Deep web intelligence gathering
- **DuckDuckGo** — Privacy-respecting general search
- **Google Custom Search** — Targeted domain-specific queries
- **SearXNG** — Self-hosted meta-search aggregating multiple engines

---

## What Makes This Different

<table>
<tr>
<th>Dimension</th>
<th>Traditional Security Automation</th>
<th>4RedTeam</th>
</tr>
<tr>
<td><b>Reasoning</b></td>
<td>Rule-based or single-prompt</td>
<td>Multi-agent deliberation with role specialization</td>
</tr>
<tr>
<td><b>Execution</b></td>
<td>Host-level or shared environment</td>
<td>Per-flow sandboxed containers with capability control</td>
</tr>
<tr>
<td><b>Memory</b></td>
<td>Stateless between runs</td>
<td>Three-tier persistence with vector search and knowledge graph</td>
</tr>
<tr>
<td><b>Adaptation</b></td>
<td>Fixed playbooks</td>
<td>Dynamic strategy adjustment based on target responses</td>
</tr>
<tr>
<td><b>Observability</b></td>
<td>Log files</td>
<td>Full-stack tracing with Langfuse, Grafana, Jaeger, and OpenTelemetry</td>
</tr>
<tr>
<td><b>Cost Control</b></td>
<td>One model for everything</td>
<td>Per-agent model routing — expensive models only where needed</td>
</tr>
<tr>
<td><b>Context Management</b></td>
<td>Truncation or failure</td>
<td>Intelligent chain summarization preserving critical reasoning</td>
</tr>
</table>

---

## Quick Start

### Requirements
- Docker and Docker Compose
- 2+ vCPU, 4GB+ RAM, 20GB+ disk
- At least one LLM provider API key

### Installation

```bash
# Create working directory
mkdir 4redteam && cd 4redteam

# Download compose file and environment template
curl -O https://raw.githubusercontent.com/jaysteelmind/4redteam/main/docker-compose.yml
curl -o .env https://raw.githubusercontent.com/jaysteelmind/4redteam/main/.env.example

# Configure your LLM provider (at minimum, one of these)
# Edit .env and set: OPEN_AI_KEY, ANTHROPIC_API_KEY, GEMINI_API_KEY, or OLLAMA_SERVER_URL

# Launch
docker compose up -d
```

Access the web UI at [https://localhost:8443](https://localhost:8443) — default credentials: `admin@example.com` / `admin`

### Interactive Installer (Recommended)

For guided setup with system checks, provider configuration, and security hardening:

```bash
# Download and run the installer
mkdir 4redteam && cd 4redteam
wget -O installer.zip https://example.com/downloads/linux/amd64/installer-latest.zip
unzip installer.zip && sudo ./installer
```

The installer walks through: system verification, LLM provider setup, search engine configuration, credential generation, SSL provisioning, and deployment.

### Optional Stacks

```bash
# Add LLM observability (Langfuse)
docker compose -f docker-compose.yml -f docker-compose-langfuse.yml up -d

# Add knowledge graph (Graphiti + Neo4j)
docker compose -f docker-compose.yml -f docker-compose-graphiti.yml up -d

# Add system monitoring (Grafana + Prometheus + Jaeger + Loki)
docker compose -f docker-compose.yml -f docker-compose-observability.yml up -d

# All stacks together
docker compose \
  -f docker-compose.yml \
  -f docker-compose-langfuse.yml \
  -f docker-compose-graphiti.yml \
  -f docker-compose-observability.yml \
  up -d
```

---

## Configuration

### Core Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `OPEN_AI_KEY` | OpenAI API key | One provider required |
| `ANTHROPIC_API_KEY` | Anthropic API key | One provider required |
| `GEMINI_API_KEY` | Google AI API key | One provider required |
| `OLLAMA_SERVER_URL` | Ollama server endpoint | One provider required |
| `BEDROCK_REGION` / `BEDROCK_ACCESS_KEY_ID` / `BEDROCK_SECRET_ACCESS_KEY` | AWS Bedrock credentials | One provider required |
| `LLM_SERVER_URL` / `LLM_SERVER_KEY` / `LLM_SERVER_CONFIG_PATH` | Custom OpenAI-compatible provider | One provider required |
| `DUCKDUCKGO_ENABLED` | Enable DuckDuckGo search | Optional |
| `TAVILY_API_KEY` | Tavily search API key | Optional |
| `PERPLEXITY_API_KEY` | Perplexity search API key | Optional |
| `GRAPHITI_ENABLED` | Enable knowledge graph | Optional (default: `false`) |
| `COOKIE_SIGNING_SALT` | Session security salt | Recommended |
| `PUBLIC_URL` | External access URL | Production |

### Custom Model Routing

Map specific LLM models to each agent type via YAML configuration:

```yaml
# provider-config.yml
simple:
  model: "gpt-4.1-nano"
  temperature: 0.7
  max_tokens: 4000

primary_agent:
  model: "claude-sonnet-4-20250514"
  temperature: 0.3
  max_tokens: 16000

pentester:
  model: "o3"
  temperature: 0.2
  max_tokens: 32000

coder:
  model: "claude-sonnet-4-20250514"
  temperature: 0.1
  max_tokens: 16000
```

```bash
LLM_SERVER_CONFIG_PATH=/path/to/provider-config.yml
```

### Embedding Providers

Configure vector embeddings for semantic search and memory:

| Provider | Variable | Notes |
|----------|----------|-------|
| OpenAI (default) | `EMBEDDING_PROVIDER=openai` | Uses `text-embedding-3-small` |
| Ollama | `EMBEDDING_PROVIDER=ollama` | Local inference, no API key |
| Jina | `EMBEDDING_PROVIDER=jina` | Requires `EMBEDDING_KEY` |
| VoyageAI | `EMBEDDING_PROVIDER=voyageai` | Requires `EMBEDDING_KEY` |
| HuggingFace | `EMBEDDING_PROVIDER=huggingface` | Requires `EMBEDDING_KEY` |
| Google AI | `EMBEDDING_PROVIDER=googleai` | Requires `EMBEDDING_KEY` |
| Mistral | `EMBEDDING_PROVIDER=mistral` | Requires `EMBEDDING_KEY` |

### Production Deployment

For security-sensitive environments, deploy with a **two-node architecture** where worker containers run on dedicated hardware:

- Isolated execution on separate server
- Network boundaries between control plane and pentest operations
- Docker-in-Docker with TLS mutual authentication
- Dedicated port ranges for out-of-band techniques

See the [Worker Node Setup Guide](examples/guides/worker_node.md) for detailed instructions.

---

## Development

### Prerequisites

- Go 1.24+
- Node.js 18+
- Docker
- PostgreSQL with pgvector extension

### Backend

```bash
cd backend
go mod download
go run cmd/4redteam/main.go
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

### Code Generation

```bash
# GraphQL resolvers
cd backend && go run github.com/99designs/gqlgen --config ./gqlgen/gqlgen.yml

# Swagger documentation
swag init -g ../../pkg/server/router.go -o pkg/server/docs/ --parseDependency --parseInternal --parseDepth 2 -d cmd/4redteam

# Database models (sqlc)
docker run --rm -v $(pwd):/src -w /src --network redteam-network sqlc/sqlc generate -f sqlc/sqlc.yml
```

### Testing Utilities

| Tool | Purpose | Usage |
|------|---------|-------|
| `ctester` | Validate LLM agent capabilities | `go run cmd/ctester/*.go -verbose` |
| `etester` | Test embedding providers and vector DB | `go run cmd/etester/main.go test -verbose` |
| `ftester` | Debug individual agent functions | `go run cmd/ftester/main.go terminal -command "nmap -sV target"` |

### Building

```bash
# Docker image
docker build -t jaysteelmind/4redteam:latest .

# Cross-platform
docker buildx build --platform linux/amd64,linux/arm64 -t jaysteelmind/4redteam:latest .
```

---

## Project Structure

```
4redteam/
├── backend/
│   ├── cmd/
│   │   ├── 4redteam/              # Main application entry point
│   │   ├── installer/             # Interactive TUI installer
│   │   ├── ctester/               # LLM capability test suite
│   │   ├── etester/               # Embedding provider tester
│   │   └── ftester/               # Function-level debugger
│   ├── pkg/
│   │   ├── providers/             # LLM provider implementations
│   │   │   ├── anthropic/         #   Anthropic Claude
│   │   │   ├── openai/            #   OpenAI GPT / o-series
│   │   │   ├── ollama/            #   Ollama local inference
│   │   │   ├── gemini/            #   Google Gemini
│   │   │   ├── bedrock/           #   AWS Bedrock
│   │   │   ├── custom/            #   OpenAI-compatible APIs
│   │   │   └── embeddings/        #   Vector embedding providers
│   │   ├── tools/                 # Agent tool implementations
│   │   ├── graph/                 # GraphQL schema and resolvers
│   │   ├── server/                # HTTP/WS server, auth, middleware
│   │   ├── docker/                # Container lifecycle management
│   │   ├── cast/                  # Chain AST and summarization
│   │   ├── csum/                  # Chain summary engine
│   │   ├── graphiti/              # Knowledge graph client
│   │   ├── database/              # PostgreSQL models and queries
│   │   ├── observability/         # Langfuse and OpenTelemetry
│   │   ├── templates/             # Agent prompt templates
│   │   └── config/                # Environment configuration
│   ├── migrations/                # Database migrations
│   ├── gqlgen/                    # GraphQL code generation config
│   └── docs/                      # Backend documentation
├── frontend/
│   ├── src/
│   │   ├── features/              # Feature modules (auth, flows, settings)
│   │   ├── components/            # Shared UI components
│   │   ├── graphql/               # GraphQL queries and mutations
│   │   └── pages/                 # Route pages
│   └── public/                    # Static assets
├── observability/                 # Grafana dashboards and OTel config
├── examples/
│   ├── configs/                   # Provider configuration examples
│   ├── guides/                    # Deployment guides
│   └── tests/                     # LLM provider test reports
├── docker-compose.yml             # Core platform services
├── docker-compose-langfuse.yml    # LLM observability stack
├── docker-compose-graphiti.yml    # Knowledge graph stack
├── docker-compose-observability.yml # Monitoring stack
├── Dockerfile                     # Multi-stage build
└── entrypoint.sh                  # Container initialization
```

---

## Documentation

| Document | Description |
|----------|-------------|
| [Configuration Reference](backend/docs/config.md) | Full environment variable reference |
| [Database Schema](backend/docs/database.md) | PostgreSQL schema and migrations |
| [Docker Architecture](backend/docs/docker.md) | Container management and networking |
| [Observability Setup](backend/docs/observability.md) | Grafana, Langfuse, and OpenTelemetry |
| [Ollama Integration](backend/docs/ollama.md) | Local LLM setup and model configuration |
| [Chain Summarization](backend/docs/chain_summary.md) | Context management algorithm |
| [Prompt Engineering](backend/docs/prompt_engineering.md) | Agent prompt design patterns |
| [Worker Node Setup](examples/guides/worker_node.md) | Two-node production architecture |
| [Installer Documentation](backend/docs/installer/) | TUI installer internals |

---

## Design Principles

This system is built on principles from:

- **Multi-Agent Systems** — Specialized agents with role-based delegation and coordination protocols
- **Retrieval-Augmented Generation** — Vector-indexed memory for grounding agent decisions in prior experience
- **Temporal Knowledge Graphs** — Structured relationship tracking between entities, tools, and outcomes over time
- **Defense in Depth** — Sandboxed execution with container isolation, capability restriction, and network segmentation
- **Observable Systems** — Full-stack tracing from user intent through agent reasoning to tool execution

---

## Research

This project builds on developments in autonomous agent architectures:

- [Emerging Architectures for LLM Applications](https://lilianweng.github.io/posts/2023-06-23-agent) — Lilian Weng
- [A Survey of Autonomous LLM Agents](https://arxiv.org/abs/2403.08299) — arXiv 2024

---

## Contributing

We welcome contributions that advance the platform's capabilities:

1. All code must maintain existing test coverage
2. Agent changes must preserve sandboxed execution guarantees
3. New providers must implement the standard provider interface
4. Security-critical changes require review

---

## License

MIT License — See [LICENSE](LICENSE) for details.

---

<div align="center">

**4RedTeam** — *Autonomous AI agents conducting real-world security assessments*
**Jerome Naidoo**

Building the next generation of intelligent security tooling.

</div>
