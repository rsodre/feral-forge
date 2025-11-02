#!/bin/bash
set -euo pipefail
source scripts/setup.sh

if [ $# -ge 2 ]; then
  export PAUSED=$2
else
  # export PROFILE="dev"
  echo "usage: $0 <PROFILE> <PAUSED>"
  exit 1
fi

# move down to /dojo
pushd $(dirname "$0")/..

# sozo execute --world <WORLD_ADDRESS> <CONTRACT> <ENTRYPOINT>
echo "> new paused: $PAUSED"
sozo -P $PROFILE execute feral-game --world $WORLD_ADDRESS --wait set_paused $PAUSED
# sozo -P $PROFILE model get feral-GameInfo $TOKEN_ADDRESS
