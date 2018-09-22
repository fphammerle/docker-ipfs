# docker container: ipfs daemon

docker hub: https://hub.docker.com/r/fphammerle/ipfs/

```sh
sudo docker run --detach \
    --cap-drop=all --security-opt=no-new-privileges \
    --restart=unless-stopped \
    --name ipfs \
    fphammerle/ipfs:0.4.17-amd64
```
