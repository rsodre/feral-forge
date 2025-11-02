#!/bin/bash
set -euo pipefail
source scripts/setup.sh

if [ $# -ge 2 ]; then
  export TOKEN_ID=$2
else
  # export PROFILE="dev"
  echo "usage: $0 <PROFILE> <TOKEN_ID>"
  exit 1
fi

# move down to /dojo
pushd $(dirname "$0")/..

# sozo execute --world <WORLD_ADDRESS> <CONTRACT> <ENTRYPOINT>
echo "> token_uri($TOKEN_ID)..."
sozo -P $PROFILE call feral-game --world $WORLD_ADDRESS token_uri -v u256:$TOKEN_ID
