# docker: ipfs 🐳

golang-implementation of the [interplanetary file system (ipfs)](https://ipfs.io/) daemon

__DEPRECATED__ since the [official image](https://web.archive.org/web/20220611212303/https://github.com/ipfs/go-ipfs/blob/v0.13.0/Dockerfile)
now supports configuration via [/container-init.d](https://web.archive.org/web/20220611212212/https://github.com/ipfs/go-ipfs/pull/6577)
([docs](https://web.archive.org/web/20220611212603/https://docs.ipfs.io/how-to/run-ipfs-inside-docker/#customizing-your-node),
[commit](https://github.com/ipfs/go-ipfs/commit/63b00256642c6ddcb35eecd95ea4e23a6bba21f3))

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

## Restart Automatically

```sh
docker run --name ipfs \
    --cap-drop=all --security-opt=no-new-privileges \
    --detach --restart=unless-stopped \
    fphammerle/ipfs:latest
```

## Publish [HTTP Gateway](https://github.com/ipfs/go-ipfs/blob/v0.12.2/docs/config.md#addressesgateway)

```sh
docker run -e IPFS_GATEWAY_ADDR=/ip4/0.0.0.0/tcp/8080 -p 8080:8080 …
```

## Change [Swarm Listener Ports](https://github.com/ipfs/go-ipfs/blob/v0.8.0/docs/config.md#addressesswarm)

```sh
docker run -e IPFS_SWARM_ADDRS="/ip4/0.0.0.0/tcp/4021 /ip6/::/tcp/4021" …
```

## Disable Swarm Listener

```sh
docker run -e IPFS_SWARM_ADDRS="" …
```

## Add [Bootstrap Nodes / Peers](https://github.com/ipfs/go-ipfs/blob/v0.8.0/docs/config.md#bootstrap)

```sh
docker run -e IPFS_BOOTSTRAP_ADD='/dnsaddr/ipfs1.net/tcp/4001/QmPeerId /dnsaddr/ipfs2.net/tcp/4001/QmPeerId' …
```

## Disable API Access From Host

```sh
docker run -e IPFS_API_ADDR=/ip4/127.0.0.1/tcp/5001 …
```

## Publish Clipboard

```sh
xsel -b | sudo docker exec -i ipfs ipfs add -
```
