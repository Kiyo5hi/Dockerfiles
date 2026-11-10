# Private HTTPS runtime

This builds Caddy 2.11.8 with only the Cloudflare DNS provider v0.2.4, using
xcaddy 0.4.7 and Go 1.27.3. Base images are pinned by digest. Application code,
gateway configuration, certificates and credentials are not part of the image.
It replaces the temporary runtime-only build housed in the GMWE repository.

The dedicated workflow builds and checks both amd64 and arm64 on PRs. Only main
publishes `ghcr.io/kiyo5hi/caddy-gateway:cloudflare-2.11.8`, reusing the existing
gateway package. The general gateway image's exec/forward-proxy plugins are
not included. Production must pin the published digest, validate its real Caddy
configuration, preserve ACME storage and verify private routes before cutover.
Publication itself does not deploy anything.

To update, review the upstream Caddy/plugin releases, update explicit versions
and base digests in the Dockerfile and the publication tag, then repeat PR CI
and deployment validation. GHA caches intermediate layers in a dedicated scope.
