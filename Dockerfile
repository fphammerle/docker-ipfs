# on alpine with libc6-compat=1.1.24-r9:
# > Error relocating /usr/local/bin/ipfs: __fprintf_chk: symbol not found
# > Error relocating /usr/local/bin/ipfs: __vfprintf_chk: symbol not found
FROM debian:buster-slim

ARG JQ_PACKAGE_VERSION=1.5+dfsg-2+b1
ARG TINI_PACKAGE_VERSION=0.18.0-1
ENV IPFS_PATH /ipfs-repo
RUN apt-get update \
    && apt-get install --no-install-recommends --yes \
        jq=$JQ_PACKAGE_VERSION \
        tini=$TINI_PACKAGE_VERSION \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists \
    && find / -xdev -type f -perm /u+s -exec chmod --changes u-s {} \; \
    && find / -xdev -type f -perm /g+s -exec chmod --changes g-s {} \; \
    && useradd --system ipfs \
    && mkdir --mode u=rwx,g=,o= $IPFS_PATH \
    && chown ipfs $IPFS_PATH
VOLUME $IPFS_PATH

ARG IPFS_VERSION=0.7.0
COPY ipfs-arch.sh /
ARG INSTALL_DEPENDENCIES="wget ca-certificates"
RUN apt-get update \
    && apt-get install --no-install-recommends --yes $INSTALL_DEPENDENCIES \
    && wget -O- https://dist.ipfs.io/go-ipfs/v${IPFS_VERSION}/go-ipfs_v${IPFS_VERSION}_linux-$(/ipfs-arch.sh).tar.gz \
        | tar -xz -C /tmp \
    && apt-get purge --yes --autoremove $INSTALL_DEPENDENCIES \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists \
    && mv /tmp/go-ipfs/ipfs /usr/local/bin \
    && rm -r /tmp/go-ipfs

ENV IPFS_CONFIG_PATH="${IPFS_PATH}/config" \
    IPFS_INIT_PROFILE=server \
    IPFS_API_ADDR=/ip4/0.0.0.0/tcp/5001 \
    IPFS_SWARM_ADDRS=/ip4/0.0.0.0/tcp/4001 \
    IPFS_BOOTSTRAP_ADD=
COPY entrypoint.sh /
RUN chmod a=rx /entrypoint.sh
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]

USER ipfs
# swarm
EXPOSE 4001/tcp
# api & webgui
EXPOSE 5001/tcp
# http gateway
EXPOSE 8080/tcp
CMD ["ipfs", "daemon"]
