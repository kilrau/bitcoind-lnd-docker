#!/bin/bash
set -euo pipefail
set -m
. /wait-file.sh

SCRIPT_PATH=$(dirname "$0")
cd "$SCRIPT_PATH" || exit 1

LND_DIR="/root/.lnd"
mkdir -p $LND_DIR

if [[ ! -e $LND_DIR/lnd.conf ]]; then
  cp /root/lnd.conf $LND_DIR/lnd.conf
fi

set -e

LND_HOSTNAME="$HOME/.lnd/tor/hostname"
echo "Waiting for lnd onion address..."

wait_file "$LND_HOSTNAME" && {
	LND_ONION_ADDRESS=$(cat "$LND_HOSTNAME")
	echo "Onion address for lnd is $LND_ONION_ADDRESS"
  # mark lnd as locked before starting
  touch "$HOME/.lnd/wallet.lock"
  # notify peers.sh to bootstrap peers
  touch "$HOME/.lnd/peers.lock"

	PORT=9735

     lnd --bitcoin.mainnet --lnddir=$LND_DIR --externalip="$LND_ONION_ADDRESS:$PORT" --listen="0.0.0.0:$PORT"

} || exit 1
