ARG PLATFORM=amd64
ARG UNIFI_VERSION=7.3.83

FROM --platform=${PLATFORM} ubuntu:18.04 AS builder
ARG UNIFI_VERSION

ADD https://dl.ui.com/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb /tmp
#COPY files/unifi_sysvinit_all.deb /tmp
COPY files/entrypoint.sh /usr/bin

USER root

RUN useradd appuser -c "Application User" && \
    apt update && \
    apt upgrade && \
    apt install -y \
        openjdk-11-jdk-headless \
        libcap2 \
        binutils \
        logrotate \
        curl \
        mongodb \
        mongodb-server && \
    dpkg --install /tmp/unifi_sysvinit_all.deb && \
    apt -f install && \
    rm -Rf /tmp/unifi_sysvinit_all.deb

VOLUME /var/log/unifi /var/lib/unifi

HEALTHCHECK --interval=30s --timeout=2s \
  CMD curl --insecure https://127.0.0.1:8443 || exit 1

EXPOSE 6789/tcp 8080/tcp 8443/tcp 8843/tcp 8880/tcp 1900/udp 5353/udp 3478/udp 10001/udp

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
