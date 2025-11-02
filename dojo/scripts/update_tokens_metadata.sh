#!/bin/bash
set -euo pipefail
source scripts/setup.sh

if [ $# -ge 3 ]; then
  export TOKEN_ID_FROM=$2
  export TOKEN_ID_TO=$3
else
  # export PROFILE="dev"
  echo "usage: $0 <PROFILE> <TOKEN_ID_FROM> <TOKEN_ID_TO>"
  exit 1
fi

# move down to /dojo
pushd $(dirname "$0")/..

# sozo execute --world <WORLD_ADDRESS> <CONTRACT> <ENTRYPOINT>
echo "> update_tokens_metadata($TOKEN_ID_FROM, $TOKEN_ID_TO)..."
sozo -P $PROFILE execute feral-game --world $WORLD_ADDRESS --wait update_tokens_metadata u256:$TOKEN_ID_FROM u256:$TOKEN_ID_TO
