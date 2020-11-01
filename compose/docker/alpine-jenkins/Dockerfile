ARG TAG

FROM zeroc0d3labdevops/alpine-base-consul:${TAG:-latest}

ARG BUILD_DATE
ARG BUILD_VERSION
ARG GIT_COMMIT
ARG GIT_URL

ARG COMPOSER_VERSION="2.0.4"

LABEL maintainer="Dwi Fahni Denni (@zeroc0d3)" \
      org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.name="alpine-jenkins" \
      org.label-schema.description="alpine-jenkins image" \
      org.label-schema.vcs-ref="$GIT_COMMIT" \
      org.label-schema.vcs-url="$GIT_URL" \
      org.label-schema.vendor="ZeroC0D3Lab" \
      org.label-schema.version="$BUILD_VERSION"

ENV JENKINS_VERSION=2.249.2 \
    JENKINS_HOME=/home/jenkins

RUN mkdir ${JENKINS_HOME} && \
    addgroup -S jenkins && \
    adduser -S -D -g "" -G jenkins -s /bin/sh -h ${JENKINS_HOME} jenkins && \
    chown jenkins:jenkins ${JENKINS_HOME}

RUN apk add --no-cache --update git \
    openjdk11-jre \
    openssh-client \
    ttf-dejavu \
    docker \
    docker-compose \
    openrc && \
    mkdir /usr/local/jenkins && \
    curl -sSL http://mirrors.jenkins-ci.org/war-stable/${JENKINS_VERSION}/jenkins.war -o /usr/local/jenkins/jenkins.war && \
    curl -sSL https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer

RUN chmod +x /usr/local/bin/composer; sync
RUN rc-update add docker boot; sync

COPY rootfs/ /
COPY docker-compose-mariadb.yml /opt/mariadb/docker-compose.yml
COPY .env.example /opt/mariadb/.env

ENTRYPOINT ["/init"]
CMD []

EXPOSE 8080
VOLUME ["/home/jenkins"]
