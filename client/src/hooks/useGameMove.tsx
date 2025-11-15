import { useCallback, useEffect, useState } from 'react';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { GameState, SchemaType } from '../generated/models.gen';
import { directionToCairoCustomEnum, MoveDirection } from '../data/types';
import { useParsedGameState } from './useParsedGameState';

export function useGameMove(gameId: number) {
  const { client } = useDojoSDK<() => any, SchemaType>();

  const [gameState, setGameState] = useState<GameState>();
  const [isMoving, setIsMoving] = useState<boolean>(false);

  const move = useCallback((previousGameState: GameState, direction: MoveDirection) => {
    if (client && !isMoving) {
      console.log(">>> useGameMove()...", gameId);
      setIsMoving(true);
      client.game_token.move(previousGameState, directionToCairoCustomEnum(direction)).then((newGameState: GameState) => {
        setGameState(newGameState);
        setIsMoving(false);
      });
    }
  }, [client, gameState]);

  const movedGameState = useParsedGameState(gameState);

  return {
    move,
    isMoving,
    movedGameState,
  }
}
