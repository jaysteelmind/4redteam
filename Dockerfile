# syntax=docker/dockerfile:1.4

# STEP 1: Build the frontend
FROM node:23-slim as fe-build

ENV NODE_ENV=production
ENV VITE_BUILD_MEMORY_LIMIT=4096
ENV NODE_OPTIONS="--max-old-space-size=4096"

WORKDIR /frontend

# Install build essentials
RUN apt-get update && apt-get install -y \
    ca-certificates \
    tzdata \
    gcc \
    g++ \
    make \
    git

COPY ./backend/pkg/graph/schema.graphqls ../backend/pkg/graph/
COPY frontend/ .

# Install dependencies with package manager detection for SBOM
RUN --mount=type=cache,target=/root/.npm \
    npm ci --include=dev

# Build frontend with optimizations and parallel processing
RUN npm run build -- \
    --mode production \
    --minify esbuild \
    --outDir dist \
    --emptyOutDir \
    --sourcemap false \
    --target es2020

# STEP 2: Build the backend
FROM golang:1.24-bookworm as be-build

ENV CGO_ENABLED=0
ENV GO111MODULE=on

# Install build essentials
RUN apt-get update && apt-get install -y \
    ca-certificates \
    tzdata \
    gcc \
    g++ \
    make \
    git \
    musl-dev

WORKDIR /backend

COPY backend/ .

# Download dependencies with module detection for SBOM
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

# Build backend
RUN go build -trimpath -o /4redteam ./cmd/4redteam

# Build ctester utility
RUN go build -trimpath -o /ctester ./cmd/ctester

# Build ftester utility
RUN go build -trimpath -o /ftester ./cmd/ftester

# Build etester utility
RUN go build -trimpath -o /etester ./cmd/etester

# STEP 3: Build the final image
FROM alpine:3.23.3

# Create non-root user and docker group with specific GID
RUN addgroup -g 998 docker && \
    addgroup -S redteam && \
    adduser -S redteam -G redteam && \
    addgroup redteam docker

# Install required packages
RUN apk --no-cache add ca-certificates openssl shadow

ADD entrypoint.sh /opt/4redteam/bin/

RUN chmod +x /opt/4redteam/bin/entrypoint.sh

RUN mkdir -p \
    /opt/4redteam/bin \
    /opt/4redteam/ssl \
    /opt/4redteam/fe \
    /opt/4redteam/logs \
    /opt/4redteam/data \
    /opt/4redteam/conf

COPY --from=be-build /4redteam /opt/4redteam/bin/4redteam
COPY --from=be-build /ctester /opt/4redteam/bin/ctester
COPY --from=be-build /ftester /opt/4redteam/bin/ftester
COPY --from=be-build /etester /opt/4redteam/bin/etester
COPY --from=fe-build /frontend/dist /opt/4redteam/fe

# Copy provider configuration files
COPY examples/configs/custom-openai.provider.yml /opt/4redteam/conf/
COPY examples/configs/deepinfra.provider.yml /opt/4redteam/conf/
COPY examples/configs/deepseek.provider.yml /opt/4redteam/conf/
COPY examples/configs/moonshot.provider.yml /opt/4redteam/conf/
COPY examples/configs/ollama-llama318b-instruct.provider.yml /opt/4redteam/conf/
COPY examples/configs/ollama-llama318b.provider.yml /opt/4redteam/conf/
COPY examples/configs/ollama-qwen332b-fp16-tc.provider.yml /opt/4redteam/conf/
COPY examples/configs/ollama-qwq32b-fp16-tc.provider.yml /opt/4redteam/conf/
COPY examples/configs/openrouter.provider.yml /opt/4redteam/conf/
COPY examples/configs/vllm-qwen332b-fp16.provider.yml /opt/4redteam/conf/

COPY LICENSE /opt/4redteam/LICENSE
COPY NOTICE /opt/4redteam/NOTICE
COPY EULA.md /opt/4redteam/EULA
COPY EULA.md /opt/4redteam/fe/EULA.md

RUN chown -R redteam:redteam /opt/4redteam

WORKDIR /opt/4redteam

USER redteam

ENTRYPOINT ["/opt/4redteam/bin/entrypoint.sh", "/opt/4redteam/bin/4redteam"]

# Image Metadata
LABEL org.opencontainers.image.source="https://github.com/jaysteelmind/4redteam"
LABEL org.opencontainers.image.description="4RedTeam - Fully autonomous AI Agents system for advanced red team operations"
LABEL org.opencontainers.image.authors="4minds"
LABEL org.opencontainers.image.licenses="MIT License"
