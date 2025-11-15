import { useEffect, useMemo, useState } from 'react';
import { useAccount } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { GameInfo, SchemaType } from '../generated/models.gen';
import { useFetchControllerUsernames } from '../stores/controllerNameStore';


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

  const accounts = useMemo(() => (
    [gameInfo?.top_score_address, gameInfo?.minter_address].filter(Boolean) as string[]
  ), [gameInfo]);
  useFetchControllerUsernames(accounts);

  return {
    gameInfo,
  }
}

export function useGamesInfo(gameId: number, count: number) {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const { isConnected } = useAccount();

  const [gamesInfo, setGamesInfo] = useState<GameInfo[]>();
  useEffect(() => {
    if (client && isConnected) {
      // console.log('gamesInfo...', gameId, count);
      if (gameId > 0 && count > 0) {
        client.game_token.getGamesInfo(gameId, count).then((gamesInfo: GameInfo[]) => {
          setGamesInfo(gamesInfo);
          // console.log('gamesInfo >>>', gamesInfo);
        });
      } else {
        setGamesInfo([]);
      }
    }
  }, [client, isConnected, gameId, count]);

  const accounts = useMemo(() => (
    gamesInfo?.reduce((acc, gameInfo) => [...acc, gameInfo.top_score_address, gameInfo.minter_address], [] as string[]).filter(Boolean) ?? []
  ), [gamesInfo]);
  useFetchControllerUsernames(accounts);

  return {
    gamesInfo,
  }
}
