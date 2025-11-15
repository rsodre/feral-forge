import { useEffect, useState } from 'react';
import { useBlockNumber } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { SchemaType } from '../generated/models.gen';
// import * as torii from "@dojoengine/torii-wasm";
// import { getContractByName } from '@dojoengine/core';
// import manifest from './generated/manifest_dev.json';

export function useTotalSupply(refetchSeconds: number = 10) {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const { data: blockNumber } = useBlockNumber({
    refetchInterval: (refetchSeconds * 1000),
  });

  const [totalSupply, setTotalSupply] = useState(0);
  useEffect(() => {
    if (client) {
      console.log("Getting total supply...");
      client.game_token.totalSupply().then((totalSupply: number) => {
        setTotalSupply(Number(totalSupply));
      });
    }
  }, [client, blockNumber]);

  return {
    totalSupply,
  }
}
