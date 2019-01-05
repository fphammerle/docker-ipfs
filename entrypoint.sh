#!/bin/sh

if [ ! -e "$IPFS_PATH/config" ]; then
    (set -x; ipfs init --profile $IPFS_INIT_PROFILE)
fi

exec "$@"
