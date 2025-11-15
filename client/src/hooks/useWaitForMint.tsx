import { useEffect, useState } from 'react';
import { useAccount, useBlockNumber } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { SchemaType } from '../generated/models.gen';
import { BigNumberish } from 'starknet';
import { bigintEquals } from '../utils/types';


export function useWaitForMint(enabled: boolean) {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const { data: blockNumber } = useBlockNumber({
    refetchInterval: (enabled ? 2000 : undefined),
  });

  // get current game id before mint
  const [lastTokenId, setLastTokenId] = useState<number>(0);
  useEffect(() => {
    if (client && enabled) {
      client.game_token.lastTokenId().then((tokenId: BigNumberish) => {
        // console.log("START CHECK MINT last id:", tokenId);
        setLastTokenId(Number(tokenId));
      });
    }
  }, [client, enabled]);

  // check supply, trigger by blockNumber
  const { address } = useAccount();
  const [mintedGameId, setMintedGameId] = useState<number>(0);
  useEffect(() => {
    if (client && enabled && lastTokenId && !mintedGameId) {
      // console.log("Check mint...");
      client.game_token.lastTokenId().then((tokenId: BigNumberish) => {
        let newTokenId = Number(tokenId);
        if (newTokenId > lastTokenId) {
          // console.log("NEW MINTED id:", newTokenId);
          client.game_token.ownerOf(newTokenId).then((owner: BigNumberish) => {
            // console.log("MINTED OWNER OF id:", bigintToAddress(owner));
            if (bigintEquals(owner, address as string)) {
              setMintedGameId(newTokenId);
            }
          });
        }
      });
    }
  }, [client, enabled, blockNumber, lastTokenId, mintedGameId]);

  return {
    mintedGameId,
  }
}
