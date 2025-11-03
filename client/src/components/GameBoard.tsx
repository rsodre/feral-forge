import { useCallback, useEffect, useMemo, useState } from 'react';
import { Box, Button, Grid, Spinner } from '@radix-ui/themes'
import { GameState } from '../generated/models.gen';
import { ParsedGameState } from '../hooks/useParsedGameState';
import BeastImage from './BeastImage';

export function GameBoard({
  gameState,
}: {
  gameState: ParsedGameState | undefined;
}) {

  useEffect(() => {
    console.log(`>>>> GameBoard:`, gameState);
  }, [gameState]);

  const isLoading = useMemo(() => (!gameState || gameState.game_id === 0), [gameState]);

  return (
    <Box width="300px" height="300px" p="2"
      style={{
        maxWidth: '100%',
        border: '1px solid red',
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        justifyContent: 'center',
        justifyItems: 'center',
        alignItems: 'center',
        display: 'flex',
      }}>
      {isLoading && <Spinner size="3" />}
      {!isLoading && gameState != null && (
        <Grid columns="4" gap="1">
          {gameState.beasts.map((beast, index) => (
            <BeastImage key={index} beastId={beast} displayTier />
          ))}
        </Grid>
      )}
    </Box>
  )
}
