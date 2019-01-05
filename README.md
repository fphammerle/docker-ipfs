# docker: ipfs 🐳

golang-implementation of the [interplanetary file system (ipfs)](https://ipfs.io/) daemon

docker hub: https://hub.docker.com/r/fphammerle/ipfs/

ipfs config guide: https://docs.ipfs.io/guides/examples/config/

## example: short

```sh
docker run --name ipfs fphammerle/ipfs
```

## example: restart automatically

```sh
docker run --name ipfs \
    --cap-drop=all --security-opt=no-new-privileges \
    --detach --restart=unless-stopped \
    fphammerle/ipfs:latest
```

## example: add bootstrap peers

```sh
docker run --name ipfs \
    --env IPFS_BOOTSTRAP_ADD='/dnsaddr/ipfs1.net/tcp/4001/QmPeerId /dnsaddr/ipfs2.net/tcp/4001/QmPeerId' \
    fphammerle/ipfs:latest
```

## publish clipboard

```sh
xsel -b | sudo docker exec -i ipfs ipfs add -
```
