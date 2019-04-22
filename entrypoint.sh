#!/bin/sh

function ipfs_config_jq_edit {
    tmp=$(mktemp)
    (set -x; jq "$@" < "$IPFS_CONFIG_PATH" > "$tmp")
    mv "$tmp" "$IPFS_CONFIG_PATH"
}

if [ ! -e "$IPFS_CONFIG_PATH" ]; then
    (set -x; ipfs init --empty-repo --profile $IPFS_INIT_PROFILE)
fi

if [ "$IPFS_API_ADDR" != "default" ]; then
    ipfs_config_jq_edit '.Addresses.API = $ARGS.positional[0]' --args "$IPFS_API_ADDR"
fi

if [ "$IPFS_SWARM_ADDRS" != "default" ]; then
    # + ipfs config --json Addresses.Swarm '["/ip4/0.0.0.0/tcp/4001"]'
    # Error: api not running
    ipfs_config_jq_edit '.Addresses.Swarm |= $ARGS.positional' --args $IPFS_SWARM_ADDRS
fi

if [ ! -z "$IPFS_BOOTSTRAP_ADD" ]; then
    # + ipfs bootstrap add -- /dnsaddr/...
    # Error: api not running
    ipfs_config_jq_edit '.Bootstrap |= (. + $ARGS.positional | unique)' --args $IPFS_BOOTSTRAP_ADD
fi

(set -x; exec "$@")
