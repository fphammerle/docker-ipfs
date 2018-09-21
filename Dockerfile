FROM alpine:3.8

RUN find / -xdev -type f -perm /u+s -exec chmod --changes u-s {} \; \
    && find / -xdev -type f -perm /g+s -exec chmod --changes g-s {} \;

# $ readelf -l /tmp/go-ipfs/ipfs | grep 'program interpreter'
#   [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
RUN apk add libc6-compat

RUN wget -O- https://dist.ipfs.io/go-ipfs/v0.4.17/go-ipfs_v0.4.17_linux-amd64.tar.gz \
        | tar -xz -C /tmp \
    && mv /tmp/go-ipfs/ipfs /usr/local/bin \
    && rm -r /tmp/go-ipfs

RUN adduser -S ipfs
USER ipfs
EXPOSE 4001/tcp
CMD ["ipfs", "daemon", "--init", "--init-profile", "server"]
