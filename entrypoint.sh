#!/bin/sh

export IPFS_CONFIG_PATH="$IPFS_PATH/config"

if [ ! -e "$IPFS_CONFIG_PATH" ]; then
    (set -x; ipfs init --empty-repo --profile $IPFS_INIT_PROFILE)
fi

if [ "$IPFS_API_ADDR" != "default" ]; then
    tmp=$(mktemp)
    (set -x; jq '.Addresses.API = $ARGS.positional[0]' --args "$IPFS_API_ADDR" <"$IPFS_CONFIG_PATH" >$tmp)
    mv $tmp "$IPFS_CONFIG_PATH"
fi

if [ "$IPFS_SWARM_ADDRS" != "default" ]; then
    # + ipfs config --json Addresses.Swarm '["/ip4/0.0.0.0/tcp/4001"]'
    # Error: api not running
    tmp=$(mktemp)
    (set -x; jq '.Addresses.Swarm |= $ARGS.positional' --args $IPFS_SWARM_ADDRS <"$IPFS_CONFIG_PATH" >$tmp)
    mv $tmp "$IPFS_CONFIG_PATH"
fi

if [ ! -z "$IPFS_BOOTSTRAP_ADD" ]; then
    # + ipfs bootstrap add -- /dnsaddr/...
    # Error: api not running
    tmp=$(mktemp)
    (set -x; jq '.Bootstrap |= (. + $ARGS.positional | unique)' --args $IPFS_BOOTSTRAP_ADD <"$IPFS_CONFIG_PATH" >$tmp)
    mv $tmp "$IPFS_CONFIG_PATH"
fi

(set -x; exec "$@")
