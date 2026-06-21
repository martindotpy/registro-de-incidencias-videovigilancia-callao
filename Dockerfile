# check=skip=FromPlatformFlagConstDisallowed
ARG TZ=America/Lima
ARG NODE_ENV=production

FROM pandoc/typst:latest-debian AS converter

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install fonts (Arial from mscorefonts)
RUN apt-get update -qq && \
    echo "deb http://deb.debian.org/debian bookworm contrib non-free non-free-firmware" >> /etc/apt/sources.list.d/contrib.list && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends ttf-mscorefonts-installer && \
    fc-cache -f && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mkdir -p public

# Notebooks and conversion script
COPY pyproject.toml uv.lock ./

RUN uv sync --only-group dev --no-cache

COPY src/assets/ src/assets/
COPY src/content/docs/ src/content/docs/
COPY scripts/ scripts/

RUN uv run --only-group dev scripts/convert_notebooks.py

COPY docs/ docs/

RUN typst compile --root . docs/proy.typ public/proy.pdf


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
COPY src/ src/
COPY --from=converter /app/src/content/docs/ src/content/docs/

# Copy compiled Typst PDF
COPY --from=converter /app/public/proy.pdf public/proy.pdf

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
