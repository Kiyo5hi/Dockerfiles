FROM caddy:2-builder AS builder

RUN xcaddy build \
    --with github.com/abiosoft/caddy-exec

FROM caddy:2
EXPOSE 80
EXPOSE 443

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

