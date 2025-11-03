import React, { useCallback, useMemo } from 'react';
import { useNavigate } from 'react-router';
import { Flex, Button, Heading, Separator, Text, Strong, Grid } from '@radix-ui/themes'
import { useTotalSupply } from '../hooks/useTotalSupply';
import { MintGameButton } from '../components/MintGameButton';
import App from '../components/App';
import { useGameInfo } from '../hooks/useGameInfo';
import { useControllerUsername } from '../hooks/useControllerUsername';

export default function GamesPage() {
  const navigate = useNavigate()
  const { totalSupply } = useTotalSupply(2);

  const items = useMemo(() => {
    return new Array(totalSupply).fill(0).map((_, index) => (
      <GameRow key={index} gameId={index + 1} />
    ));
  }, [totalSupply]);

  const _home = useCallback(() => {
    navigate('/');
  }, []);

  const _minted = useCallback((gameId: string) => {
    navigate(`/play/${gameId}`);
  }, []);

  return (
    <App bg='home'>
      <Flex
        direction="column"
        align="center"
        justify="center"
        gap="4"
        style={{
          minHeight: '100vh',
          padding: '2rem',
        }}
      >
        <Flex direction="column" align="center" gap="4" style={{
          width: '100%',
          textAlign: 'center',
          padding: '2rem',
        }}>
          <Heading size="6" weight="bold" className='Accent11'>
            Select a Game
          </Heading>

          <Text size="3">
            <Strong>Select a Game</Strong> to play
            <br />
            <Strong>Top Players</Strong> own the games!
          </Text>

          <Grid columns="4" gap="2">
            <Text><Strong>Game</Strong></Text>
            <Text><Strong>Player</Strong></Text>
            <Text><Strong>Score</Strong></Text>
            <Text></Text>
            {items}
          </Grid>

          <MintGameButton onMint={_minted}>Forge a New Game</MintGameButton>

          <Button size="3" onClick={_home}>Back</Button>
        </Flex>
      </Flex>
    </App>
  )
}

function GameRow({
  gameId,
}: {
  gameId: number;
}) {
  const navigate = useNavigate()
  const { gameInfo } = useGameInfo(gameId);
  const { username } = useControllerUsername(gameInfo?.top_score_address ?? '');

  const _play = useCallback(() => {
    navigate(`/play/${gameId}`);
  }, []);

  return (
    <React.Fragment>
      <Text size="1">Forge #{gameId}</Text>
      <Text size="1">{username}</Text>
      <Text size="1">{Number(gameInfo?.top_score ?? 0)}</Text>
      <Button size="1" onClick={_play}>Play</Button>
    </React.Fragment>
  )
}
