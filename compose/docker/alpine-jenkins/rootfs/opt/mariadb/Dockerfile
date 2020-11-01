ARG TAG

FROM alpine:${TAG:-latest}

ARG BUILD_DATE
ARG BUILD_VERSION
ARG GIT_COMMIT
ARG GIT_URL
ARG VCS_REF

LABEL maintainer="Dwi Fahni Denni (@zeroc0d3)" \
      architecture="amd64/x86_64" \
      mariadb-version="10.4.12" \
      alpine-version="3.12.0" \
      build="01-Oct-2020" \
      org.opencontainers.image.title="alpine-mariadb" \
      org.opencontainers.image.description="MariaDB Docker image running on Alpine Linux" \
      org.opencontainers.image.authors="ZeroC0D3Lab <zeroc0d3.team@gmail.com>" \
      org.opencontainers.image.vendor="ZeroC0D3Lab" \
      org.opencontainers.image.version="v10.4.12" \
      org.opencontainers.image.url="https://hub.docker.com/r/yobasystems/alpine-mariadb/" \
      org.opencontainers.image.source="https://github.com/yobasystems/alpine-mariadb" \
      org.opencontainers.image.revision="$VCS_REF" \
      org.opencontainers.image.created="$BUILD_DATE" \
      org.label-schema.version="$BUILD_VERSION"

RUN apk update
RUN apk add --no-cache bash mariadb mariadb-client mariadb-server-utils pwgen && \
    rm -f /var/cache/apk/*

USER root
RUN mkdir -p /docker-entrypoint-initdb.d && \
    mkdir -p /scripts/pre-exec.d && \
    mkdir -p /scripts/pre-init.d && \
    chmod -R 755 /scripts

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/scripts/run.sh"]