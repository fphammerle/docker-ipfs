#!/bin/sh

if [ ! -e "$IPFS_PATH/config" ]; then
    (set -x; ipfs init --profile $IPFS_INIT_PROFILE)
fi

if [ "$IPFS_SWARM_ADDRS" != "default" ]; then
    addrs_json=$(jq --null-input --compact-output '$ARGS.positional' --args $IPFS_SWARM_ADDRS)
    (set -x; ipfs config --json Addresses.Swarm "$addrs_json")
fi

if [ ! -z "$IPFS_BOOTSTRAP_ADD" ]; then
    (set -x; ipfs bootstrap add -- $IPFS_BOOTSTRAP_ADD)
fi

(set -x; exec "$@")
