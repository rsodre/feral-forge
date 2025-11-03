import { useEffect, useState } from 'react';
import { useAccount } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { useParsedGameState } from './useParsedGameState';
import { GameState, SchemaType } from '../generated/models.gen';

export function useGameStart(gameId: number) {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const { isConnected } = useAccount();

  const [gameState, setGameState] = useState<GameState>();
  useEffect(() => {
    if (client && isConnected) {
      console.log(">>> useGameStart()...", gameId);
      client.game_token.startGame(gameId).then((gameState: GameState) => {
        setGameState(gameState);
      });
    }
  }, [client, isConnected, gameId]);

  const initialGameState = useParsedGameState(gameState);

  return {
    initialGameState,
  }
}
