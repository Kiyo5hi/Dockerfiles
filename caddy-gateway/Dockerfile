FROM caddy:2-builder AS builder

RUN xcaddy build \
    --with github.com/abiosoft/caddy-exec \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive

FROM caddy:2
EXPOSE 80
EXPOSE 443
EXPOSE 443/udp

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
