import { useCallback, useEffect, useMemo, useState } from 'react';
import { useNavigate } from 'react-router';
import { Flex, Button, Heading, Separator, Grid, Box, Text, Strong, Spinner } from '@radix-ui/themes'
import { DoubleArrowDownIcon, DoubleArrowLeftIcon, DoubleArrowRightIcon, DoubleArrowUpIcon } from '@radix-ui/react-icons';
import { useControllerUsername } from '../stores/controllerNameStore';
import { useRouteSlugs } from '../hooks/useRoute';
import { useGameInfo } from '../hooks/useGameInfo';
import { useGameStart } from '../hooks/useGameStart';
import { useGameMove } from '../hooks/useGameMove';
import { GameBoard } from '../components/GameBoard';
import { SubmitScoreButton } from '../components/SubmitScoreButton';
import { GameScore } from '../components/GameScore';
import { TopMenu } from '../components/TopMenu';
import { type ParsedGameState } from '../hooks/useParsedGameState';
import { MoveDirection } from '../data/types';
import { MenuButton } from '../components/Buttons';
import App from '../components/App';

export default function PlayPage() {
  const navigate = useNavigate()
  const { game_id } = useRouteSlugs()
  const gameId = useMemo(() => Number(game_id ?? 0), [game_id]);

  const { gameInfo } = useGameInfo(gameId);
  const { username: topScoreUsername } = useControllerUsername(gameInfo?.top_score_address ?? '');
  const { username: minterUsername } = useControllerUsername(gameInfo?.minter_address ?? '');

  const [currentGameState, setCurrentGameState] = useState<ParsedGameState>();
  const { initialGameState } = useGameStart(gameId);
  useEffect(() => {
    if (initialGameState) {
      setCurrentGameState(initialGameState);
    }
  }, [initialGameState]);

  const [movesHistory, setMovesHistory] = useState<MoveDirection[]>([]);
  const { move, isMoving, movedGameState } = useGameMove(gameId);
  useEffect(() => {
    if (movedGameState) {
      setCurrentGameState(movedGameState);
    }
  }, [movedGameState]);

  const canMove = useMemo(() => (
    gameId &&
    !isMoving &&
    initialGameState &&
    currentGameState?.originalGameState
  ), [isMoving, initialGameState, gameId, currentGameState]);

  const _move = useCallback((direction: MoveDirection) => {
    if (canMove && currentGameState?.originalGameState) {
      setMovesHistory(prev => [...prev, direction]);
      move(currentGameState.originalGameState, direction);
    }
  }, [move, canMove, currentGameState]);

  useEffect(() => {
    console.log(">>> movesHistory:", movesHistory);
  }, [movesHistory]);

  const [submitted, setSubmitted] = useState<boolean>(false);
  const _submitted = useCallback((gameId: number) => {
    setSubmitted(true);
  }, []);

  const { finishedGame, isNewTopScore } = useMemo(() => {
    const finishedGame = Boolean(currentGameState?.finished);
    const scoreDiff = Number(currentGameState?.score ?? 0) - Number(gameInfo?.top_score ?? 0);
    const movesDiff = Number(currentGameState?.move_count ?? 0) - Number(gameInfo?.top_score_move_count ?? 0);
    const isNewTopScore = finishedGame && (
      (scoreDiff > 0) || (scoreDiff == 0 && movesDiff < 0)
    );
    return {
      finishedGame,
      isNewTopScore,
    }
  }, [currentGameState, gameInfo]);

  return (
    <App bg='game'>
      <TopMenu />
      <Flex
        direction="column"
        align="center"
        justify="center"
        gapY="4"
        p="0"
        style={{
          minHeight: '100vh',
          padding: '2rem',
        }}
      >
        <Flex direction="column" align="center" gap="4" style={{
          width: '100%',
          textAlign: 'center',
        }}>
          <Heading size="8" weight="bold" className='Accent11'>
            Feral Forge
          </Heading>

          <Heading size="4" weight="bold">
            Forge #{game_id ?? '??'}
          </Heading>

          {gameInfo && (
            BigInt(gameInfo?.top_score) > 0n ?
              <Text size="1">
                High Score: <Strong>{gameInfo?.top_score ?? '...'}</Strong> by <Strong>{topScoreUsername ?? '...'}</Strong>
              </Text>
              : <Text size="1">
                Forged by <Strong>{minterUsername ?? '...'}</Strong>
              </Text>
          )}

          <GameBoard gameState={currentGameState} />

          <Flex direction="row" align="center" gapX="4">
            <Text size="3">
              Moves: <Strong>{currentGameState?.move_count ?? 0}</Strong>
            </Text>
            <Text size="3">
              Score: <Strong>{currentGameState?.score ?? 0}</Strong>
            </Text>
          </Flex>

          {/* <Separator my="2" style={{ opacity: 0 }} /> */}

          {!finishedGame &&
            <Grid columns="3" gap="1" width="200px" height="200px">
              <Box />
              <Button className='FillParent' disabled={!canMove} onClick={() => _move(MoveDirection.Up)} >
                <DoubleArrowUpIcon />
              </Button>
              <Box />

              <Button className='FillParent' disabled={!canMove} onClick={() => _move(MoveDirection.Left)} >
                <DoubleArrowLeftIcon />

              </Button>
              <Box />
              <Button className='FillParent' disabled={!canMove} onClick={() => _move(MoveDirection.Right)} >
                <DoubleArrowRightIcon />
              </Button>

              <Box />
              <Button className='FillParent' disabled={!canMove} onClick={() => _move(MoveDirection.Down)} >
                <DoubleArrowDownIcon />
              </Button>
              <Box />
            </Grid>
          }

          {finishedGame && !submitted &&
            <>
              <Heading size="4" weight="bold">
                {isNewTopScore ? 'New High Score!' : 'Game Over!'}
              </Heading>
              {isNewTopScore ?
                <SubmitScoreButton gameId={gameId} movesHistory={movesHistory} onSubmitted={_submitted} />
                : <MenuButton onClick={() => window.location.reload()}>Replay level</MenuButton>
              }
              <MenuButton onClick={() => navigate('/')}>Back</MenuButton>
            </>
          }

          {submitted &&
            <>
              <GameScore gameId={gameId} />
              <MenuButton onClick={() => window.location.reload()}>Replay level</MenuButton>
              <MenuButton onClick={() => navigate('/')}>Back</MenuButton>
            </>
          }

        </Flex>
      </Flex>
    </App>
  )
}
