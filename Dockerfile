ARG PLATFORM=amd64
ARG UNIFI_VERSION=8.2.93
ARG INSTALLER_FILE=ca97-debian-8.2.93-d03274d8-7021-4b69-9233-5b521691b501.deb

FROM --platform=${PLATFORM} ubuntu:18.04 AS builder
ARG UNIFI_VERSION
ARG INSTALLER_FILE

#ADD https://dl.ui.com/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb /tmp
#COPY files/e2e7-debian-7.4.162-03ed77823cbb477490a0d9cceb477689.deb /tmp
#COPY files/unifi_sysvinit_all.deb /tmp
COPY files/${INSTALLER_FILE} /tmp
COPY files/entrypoint.sh /usr/bin

USER root

RUN useradd appuser -c "Application User" && \
    apt update && \
    apt upgrade -y && \
    apt install -y \
        openjdk-17-jdk-headless \
        libcap2 \
        binutils \
        logrotate \
        curl \
        mongodb \
        mongodb-server && \
    dpkg --install /tmp/${INSTALLER_FILE} && \
    apt -f install && \
    rm -Rf /tmp/${INSTALLER_FILE}

VOLUME /var/log/unifi /var/lib/unifi

HEALTHCHECK --interval=30s --timeout=2s \
  CMD curl --insecure https://127.0.0.1:8443 || exit 1

EXPOSE 6789/tcp 8080/tcp 8443/tcp 8843/tcp 8880/tcp 1900/udp 5353/udp 3478/udp 10001/udp

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
