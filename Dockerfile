FROM alpine:3.8

RUN find / -xdev -type f -perm /u+s -exec chmod --changes u-s {} \; \
    && find / -xdev -type f -perm /g+s -exec chmod --changes g-s {} \;

RUN apk add tini
ENTRYPOINT ["/sbin/tini", "-s", "--"]

# $ readelf -l /tmp/go-ipfs/ipfs | grep 'program interpreter'
#   [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
RUN apk add libc6-compat

RUN adduser -S ipfs

ENV IPFS_PATH /ipfs-repo
RUN mkdir -m u=rwx,g=,o= $IPFS_PATH && chown ipfs $IPFS_PATH
VOLUME $IPFS_PATH

ENV IPFS_VERSION 0.4.18
ENV IPFS_ARCH amd64
RUN wget -O- https://dist.ipfs.io/go-ipfs/v${IPFS_VERSION}/go-ipfs_v${IPFS_VERSION}_linux-${IPFS_ARCH}.tar.gz \
        | tar -xz -C /tmp \
    && mv /tmp/go-ipfs/ipfs /usr/local/bin \
    && rm -r /tmp/go-ipfs

COPY ./ipfs-daemon /usr/local/bin/ipfs-daemon
RUN chmod a=rx /usr/local/bin/ipfs-daemon

USER ipfs
EXPOSE 4001/tcp
# ipfs http gateway
EXPOSE 8080/tcp
ENV IPFS_INIT_PROFILE server
CMD ["ipfs-daemon"]
