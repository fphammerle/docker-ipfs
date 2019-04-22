FROM alpine:3.8

RUN find / -xdev -type f -perm /u+s -exec chmod --changes u-s {} \; \
    && find / -xdev -type f -perm /g+s -exec chmod --changes g-s {} \;

RUN apk add tini jq

# $ readelf -l /tmp/go-ipfs/ipfs | grep 'program interpreter'
#   [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
RUN apk add libc6-compat

RUN adduser -S ipfs

ENV IPFS_PATH /ipfs-repo
RUN mkdir -m u=rwx,g=,o= $IPFS_PATH && chown ipfs $IPFS_PATH
VOLUME $IPFS_PATH

ENV IPFS_VERSION 0.4.20
COPY ipfs-arch.sh /
RUN wget -O- https://dist.ipfs.io/go-ipfs/v${IPFS_VERSION}/go-ipfs_v${IPFS_VERSION}_linux-$(/ipfs-arch.sh).tar.gz \
        | tar -xz -C /tmp \
    && mv /tmp/go-ipfs/ipfs /usr/local/bin \
    && rm -r /tmp/go-ipfs

ENV IPFS_CONFIG_PATH="${IPFS_PATH}/config" \
    IPFS_INIT_PROFILE=server \
    IPFS_API_ADDR=/ip4/0.0.0.0/tcp/5001 \
    IPFS_SWARM_ADDRS=/ip4/0.0.0.0/tcp/4001 \
    IPFS_BOOTSTRAP_ADD=
COPY entrypoint.sh /
RUN chmod a=rx /entrypoint.sh
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

USER ipfs
# swarm
EXPOSE 4001/tcp
# api & webgui
EXPOSE 5001/tcp
# http gateway
EXPOSE 8080/tcp
CMD ["ipfs", "daemon"]
