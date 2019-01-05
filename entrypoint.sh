#!/bin/sh

if [ ! -e "$IPFS_PATH/config" ]; then
    (set -x; ipfs init --profile $IPFS_INIT_PROFILE)
fi

if [ ! -z "$IPFS_BOOTSTRAP_ADD" ]; then
    (set -x; ipfs bootstrap add -- $IPFS_BOOTSTRAP_ADD)
fi

(set -x; exec "$@")
