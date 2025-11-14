import { useEffect, useState } from 'react';
import { useAccount, useBlockNumber } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { GameInfo, SchemaType } from '../generated/models.gen';
// import * as torii from "@dojoengine/torii-wasm";
// import { getContractByName } from '@dojoengine/core';
// import manifest from './generated/manifest_dev.json';

export function useGameInfo(gameId: number) {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const { isConnected } = useAccount();

  const [gameInfo, setGameInfo] = useState<GameInfo>();
  useEffect(() => {
    if (client && isConnected && gameId > 0) {
      client.game_token.getGameInfo(gameId).then((gameInfo: GameInfo) => {
        setGameInfo(gameInfo);
      });
    }
  }, [client, isConnected, gameId]);

  return {
    gameInfo,
  }
}

export function useGamesInfo(gameId: number, count: number) {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const { isConnected } = useAccount();

  const [gamesInfo, setGamesInfo] = useState<GameInfo[]>();
  useEffect(() => {
    if (client && isConnected && gameId > 0) {
      // console.log('gamesInfo...', gameId, count);
      client.game_token.getGamesInfo(gameId, count).then((gamesInfo: GameInfo[]) => {
        setGamesInfo(gamesInfo);
        // console.log('gamesInfo >>>', gamesInfo);
      });
    }
  }, [client, isConnected, gameId, count]);


  return {
    gamesInfo,
  }
}
