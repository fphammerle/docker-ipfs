#!/bin/sh
set -eu

ipfs_config_jq_edit() {
    tmp=$(mktemp)
    (set -x; jq "$@" < "$IPFS_CONFIG_PATH" > "$tmp")
    mv "$tmp" "$IPFS_CONFIG_PATH"
}

# --args available in jq >= 1.6
# https://github.com/stedolan/jq/commit/66fb962a6608805f4d7667d39ad0d88158bd1262
# compare fphammerle/docker-ipfs v0.2.0
args_to_json_array() {
    if [ -z "$@" ]; then
        printf '[]\n'
    else
        printf '%s\n' "$@" | jq -R . | jq -sc .
    fi
}

if [ ! -e "$IPFS_CONFIG_PATH" ]; then
    (set -x; ipfs init --empty-repo --profile $IPFS_INIT_PROFILE)
fi

if [ "$IPFS_API_ADDR" != "default" ]; then
    ipfs_config_jq_edit '.Addresses.API = $ARGS[0]' --argjson ARGS "$(args_to_json_array "$IPFS_API_ADDR")"
fi

if [ "$IPFS_SWARM_ADDRS" != "default" ]; then
    # + ipfs config --json Addresses.Swarm '["/ip4/0.0.0.0/tcp/4001"]'
    # Error: api not running
    ipfs_config_jq_edit '.Addresses.Swarm |= $ARGS' --argjson ARGS "$(args_to_json_array $IPFS_SWARM_ADDRS)"
fi

if [ ! -z "$IPFS_BOOTSTRAP_ADD" ]; then
    # + ipfs bootstrap add -- /dnsaddr/...
    # Error: api not running
    ipfs_config_jq_edit '.Bootstrap |= (. + $ARGS | unique)' --argjson ARGS "$(args_to_json_array $IPFS_BOOTSTRAP_ADD)"
fi

(set -x; exec "$@")
