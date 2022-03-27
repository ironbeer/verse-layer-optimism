#!/bin/sh

set -xe

RETRIES=${RETRIES:-10000}

envSet () {
  VAR=$1
  export $VAR=$(jq -r .$2 /assets/addresses.json)
}

envSet CTC_ADDRESS CanonicalTransactionChain
envSet SCC_ADDRESS StateCommitmentChain

# waits for l2geth to be up
curl --fail \
    --show-error \
    --silent \
    --retry $RETRIES \
    --retry-all-errors \
    --retry-delay 3 \
    --output /dev/null \
    $L2_ETH_RPC

# go
exec batch-submitter "$@"
