import { useMemo } from 'react';
import { GameState } from '../generated/models.gen';

export type ParsedGameState = {
  game_id: number;
  seed: bigint;
  free_tiles: number;
  move_count: number;
  finished: boolean;
  score: number;
  beasts: number[];
  originalGameState: GameState | undefined;
}

export function useParsedGameState(gameState: GameState | undefined) {

  const beasts = useMemo(() => ([
    Number(gameState?.matrix?.b_1_1 ?? 0),
    Number(gameState?.matrix?.b_1_2 ?? 0),
    Number(gameState?.matrix?.b_1_3 ?? 0),
    Number(gameState?.matrix?.b_1_4 ?? 0),
    Number(gameState?.matrix?.b_2_1 ?? 0),
    Number(gameState?.matrix?.b_2_2 ?? 0),
    Number(gameState?.matrix?.b_2_3 ?? 0),
    Number(gameState?.matrix?.b_2_4 ?? 0),
    Number(gameState?.matrix?.b_3_1 ?? 0),
    Number(gameState?.matrix?.b_3_2 ?? 0),
    Number(gameState?.matrix?.b_3_3 ?? 0),
    Number(gameState?.matrix?.b_3_4 ?? 0),
    Number(gameState?.matrix?.b_4_1 ?? 0),
    Number(gameState?.matrix?.b_4_2 ?? 0),
    Number(gameState?.matrix?.b_4_3 ?? 0),
    Number(gameState?.matrix?.b_4_4 ?? 0),
  ]), [gameState]);

  const result = useMemo(() => ({
    game_id: Number(gameState?.game_id ?? 0),
    seed: BigInt(gameState?.seed ?? 0),
    free_tiles: Number(gameState?.free_tiles ?? 0),
    move_count: Number(gameState?.move_count ?? 0),
    finished: gameState?.finished ?? false,
    score: Number(gameState?.score ?? 0),
    beasts,
    originalGameState: gameState,
  }), [gameState]);

  return result;
}
