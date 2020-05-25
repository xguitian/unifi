FROM registry.access.redhat.com/ubi8

MAINTAINER "Xabier Guitián <xguitian@gmail.com>"

ARG UNIFI_VERSION=5.12.72
ARG UNIFI_SHA256=60ea65e14ad0e8845debf451dc8e656363dc0d9d90eb053b2e6b9e2c49f09072
ENV UNIFI_VERSION=${UNIFI_VERSION}
ENV UNIFI_SHA256=${UNIFI_SHA256}

ARG UNIFI_UID=271
ENV UNIFI_UID=${UNIFI_UID}

ARG JVM_MAX_HEAP_SIZE=1024m
ENV JVM_MAX_HEAP_SIZE=${JVM_MAX_HEAP_SIZE}

RUN dnf -y update && \
    dnf install -y java-1.8.0-openjdk wget unzip && \
    dnf install -y https://repo.mongodb.org/yum/redhat/8/mongodb-org/3.4/x86_64/RPMS/mongodb-org-server-3.4.24-1.el8.x86_64.rpm && \
    dnf clean all -y

RUN adduser -r -s /sbin/nologin -d /opt/unifi -u 271 -U unifi && \
    curl -LS https://dl.ubnt.com/unifi/${UNIFI_VERSION}/UniFi.unix.zip | \
        { UNIFI_FILE_DOWNLOAD="$(mktemp --suffix=-unifi-"${UNIFI_VERSION}")"; \
        trap "rm -f '${UNIFI_FILE_DOWNLOAD}'" INT TERM EXIT; cat >| "${UNIFI_FILE_DOWNLOAD}"; \
        sha256sum --quiet -c <<<"${UNIFI_SHA256} ${UNIFI_FILE_DOWNLOAD}" \
        || exit 1; unzip "${UNIFI_FILE_DOWNLOAD}" -d /opt; } && \
    mv /opt/UniFi /opt/unifi && \
    mkdir /opt/unifi/data && mkdir /opt/unifi/logs

COPY unifi /opt/unifi/unifi

RUN chown -R ${UNIFI_UID}:${UNIFI_UID} /opt/unifi && chmod +x /opt/unifi/unifi

USER ${UNIFI_UID}
EXPOSE 3478/udp 8080/tcp 8443/tcp 8843/tcp 8880/tcp 3478/udp 6789/tcp 10001/udp
VOLUME ["/opt/unifi/data", "/opt/unifi/logs", "/opt/unifi/run"]

WORKDIR /opt/unifi

CMD ["/opt/unifi/unifi"]
