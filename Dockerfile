ARG TZ=America/Lima
ARG NODE_ENV=production

FROM python:3.14-slim AS converter

# Install uv and pandoc
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN apt-get update -qq && \
    apt-get install -y -qq --no-install-recommends pandoc && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Notebooks and conversion script
COPY src/ src/
COPY scripts/ scripts/

RUN uv run --with nbconvert scripts/convert_notebooks.py


FROM oven/bun:1-slim AS builder

ARG TZ
ARG NODE_ENV

ENV TZ=$TZ
ENV NODE_ENV=$NODE_ENV

WORKDIR /app

# Typescript and dependencies
COPY package.json bunfig.toml bun.lock tsconfig.json ./

RUN bun install --ci

# Disable Astro telemetry
RUN bun astro telemetry disable

# Copy converted markdown from converter stage (keeps .ipynb too)
COPY --from=converter /app/src/ src/

# Astro config and public files
COPY astro.config.ts pwa-assets.config.ts ./
COPY public/ public/

RUN bun run build


FROM nginx:1-alpine-slim AS runtime

# Add wget for ready endpoint healthcheck
COPY --from=busybox /lib/* /lib/
COPY --from=busybox /lib64/* /lib64/
COPY --from=busybox /bin/wget /bin/

ARG TZ

ENV TZ=$TZ

# Delete default nginx
RUN apk del -r nginx

RUN apk add --no-cache \
  nginx \
  nginx-mod-http-brotli

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/dist/ /usr/share/nginx/html/

EXPOSE 80

HEALTHCHECK --interval=120s --timeout=5s --start-period=5s \
  CMD ["/bin/wget", "--spider", "--timeout=5", "http://localhost:80/_health"]
