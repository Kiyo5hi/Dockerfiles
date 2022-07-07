FROM docker.io/library/golang:alpine AS build

WORKDIR /src
RUN apk add git && \
    git clone https://github.com/cnsilvan/UnblockNeteaseMusic.git /src && \
    chmod +x /src/build.sh && /src/build.sh && \
    mkdir /output && cp /src/bin/* /src/createCertificate.sh /output

FROM docker.io/library/alpine:latest

WORKDIR /app
COPY --from=build /output /app
COPY entrypoint.sh /app/entrypoint.sh
RUN apk add --no-cache openssl && chmod +x /app/*.sh

EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "/app/entrypoint.sh" ]

