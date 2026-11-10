# Keep the private HTTPS gateway independent of application repositories.
FROM --platform=$BUILDPLATFORM docker.io/library/golang:1.27.3-alpine@sha256:d200d2dd76b03a99b52651fd1325aff7dcd35422c35c01bac56571b0507f3deb AS builder
ARG TARGETARCH
ENV GOTOOLCHAIN=local GOMAXPROCS=2
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@v0.4.7
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH xcaddy build v2.11.8 \
    --with github.com/caddy-dns/cloudflare@v0.2.4 --output /out/caddy

FROM docker.io/library/caddy:2.11.8@sha256:4fcafa98afd1c2e642e353e3c5cf9ddbe892fcee14bc990e7ba2c5b78e51f9cf
COPY --from=builder /out/caddy /usr/bin/caddy
LABEL org.opencontainers.image.source="https://github.com/Kiyo5hi/Dockerfiles" \
      org.opencontainers.image.title="Caddy with Cloudflare DNS" \
      org.opencontainers.image.version="2.11.8-cloudflare-0.2.4"
RUN caddy version | grep -q '^v2.11.8 ' && \
    caddy list-modules --versions | grep -q '^dns.providers.cloudflare v0.2.4$'
