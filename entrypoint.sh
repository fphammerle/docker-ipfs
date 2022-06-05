#!/bin/sh
set -eu

# "sponge" also writes to /tmp
# https://salsa.debian.org/nsc/moreutils/-/blob/debian/0.62-1/sponge.c#L262
ipfs_config_jq_edit() {
    tmp=$(mktemp)
    (set -x; jq "$@" < "$IPFS_CONFIG_PATH" > "$tmp")
    #diff -u "$IPFS_CONFIG_PATH" "$tmp" || true
    mv "$tmp" "$IPFS_CONFIG_PATH"
}

if [ ! -e "$IPFS_CONFIG_PATH" ]; then
    (set -x; ipfs init --empty-repo --profile $IPFS_INIT_PROFILE)
fi

if [ "$IPFS_API_ADDR" != "default" ]; then
    ipfs_config_jq_edit '.Addresses.API = $ARGS.positional[0]' --args "$IPFS_API_ADDR"
fi

# compare `Addresses.AppendAnnounce (new in go-ipfs v0.11.0)
# https://github.com/ipfs/go-ipfs/blob/v0.11.0/docs/config.md#addressesappendannounce
if [ "$IPFS_SWARM_ADDRS" != "default" ]; then
    # + ipfs config --json Addresses.Swarm '["/ip4/0.0.0.0/tcp/4001"]'
    # Error: api not running
    ipfs_config_jq_edit '.Addresses.Swarm |= $ARGS.positional' --args $IPFS_SWARM_ADDRS
fi

if [ "$IPFS_GATEWAY_ADDR" != "default" ]; then
    ipfs_config_jq_edit '.Addresses.Gateway = $ARGS.positional[0]' --args "$IPFS_GATEWAY_ADDR"
fi

# compare https://github.com/ipfs/go-ipfs/blob/v0.11.0/docs/config.md#peering
if [ ! -z "$IPFS_BOOTSTRAP_ADD" ]; then
    # + ipfs bootstrap add -- /dnsaddr/...
    # Error: api not running
    ipfs_config_jq_edit '.Bootstrap |= (. + $ARGS.positional | unique)' --args $IPFS_BOOTSTRAP_ADD
fi

(set -x; exec "$@")
