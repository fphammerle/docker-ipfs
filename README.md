# docker: ipfs 🐳

golang-implementation of the [interplanetary file system (ipfs)](https://ipfs.io/) daemon

docker hub: https://hub.docker.com/r/fphammerle/ipfs/

signed docker image digests: https://github.com/fphammerle/docker-ipfs/tags

ipfs config:
[guide](https://docs.ipfs.io/guides/examples/config/) &
[docs](https://github.com/ipfs/go-ipfs/blob/master/docs/config.md)

```sh
docker run --name ipfs fphammerle/ipfs
```

or after cloning the repository:

```sh
docker-compose up
```

## restart automatically

```sh
docker run --name ipfs \
    --cap-drop=all --security-opt=no-new-privileges \
    --detach --restart=unless-stopped \
    fphammerle/ipfs:latest
```

## change swarm listener ports

```sh
docker run --name ipfs \
    --env IPFS_SWARM_ADDRS="/ip4/0.0.0.0/tcp/4021 /ip6/::/tcp/4021" \
    fphammerle/ipfs:latest
```

## disable swarm listener

```sh
docker run --name ipfs \
    --env IPFS_SWARM_ADDRS="" \
    fphammerle/ipfs:latest
```

## add bootstrap peers

```sh
docker run --name ipfs \
    --env IPFS_BOOTSTRAP_ADD='/dnsaddr/ipfs1.net/tcp/4001/QmPeerId /dnsaddr/ipfs2.net/tcp/4001/QmPeerId' \
    fphammerle/ipfs:latest
```

## disable api access from host

```sh
docker run -e IPFS_API_ADDR=/ip4/127.0.0.1/tcp/5001 …
```

## publish clipboard

```sh
xsel -b | sudo docker exec -i ipfs ipfs add -
```
