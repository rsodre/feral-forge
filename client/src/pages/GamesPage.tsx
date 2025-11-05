import React, { useCallback, useMemo } from 'react';
import { useNavigate } from 'react-router';
import { Flex, Button, Heading, Text, Strong, Grid, Spinner } from '@radix-ui/themes'
import { useTotalSupply } from '../hooks/useTotalSupply';
import { useGameInfo } from '../hooks/useGameInfo';
import { useControllerUsername } from '../hooks/useControllerUsername';
import { MintGameButton } from '../components/MintGameButton';
import { TopMenu } from '../components/TopMenu';
import { MenuButton } from '../components/Buttons';
import App from '../components/App';

export default function GamesPage() {
  const navigate = useNavigate()
  const { totalSupply } = useTotalSupply(2);

  const items = useMemo(() => {
    return new Array(totalSupply).fill(0).map((_, index) => (
      <GameRow key={index} gameId={index + 1} />
    ));
  }, [totalSupply]);

  const _minted = useCallback((gameId: string) => {
    navigate(`/play/${gameId}`);
  }, []);

  return (
    <App bg='home'>
      <TopMenu />
      <Flex
        direction="column"
        align="center"
        justify="center"
        gap="4"
        style={{
          minHeight: '100vh',
          padding: '0',
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

          <Grid columns="5" gap="2" align="center" justify="center">
            <Text><Strong>Game</Strong></Text>
            <Text><Strong>Forger</Strong></Text>
            <Text><Strong>Holder</Strong></Text>
            <Text><Strong>Score</Strong></Text>
            <Text></Text>
            {items}
          </Grid>

          <MintGameButton onMint={_minted}>Forge a New Game</MintGameButton>

          <MenuButton onClick={() => navigate('/')}>Back</MenuButton>
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
  const { username: forgerName } = useControllerUsername(gameInfo?.minter_address ?? '');
  const { username: topPlayerName } = useControllerUsername(gameInfo?.top_score_address ?? '');

  const _play = useCallback(() => {
    navigate(`/play/${gameId}`);
  }, []);

  return (
    <React.Fragment>
      <Text size="1">Forge #{gameId}</Text>
      <Text size="1">{forgerName || <Spinner />}</Text>
      <Text size="1">{topPlayerName || <Spinner />}</Text>
      <Text size="1">{Number(gameInfo?.top_score ?? 0)}</Text>
      <Button size="1" onClick={_play}>Play</Button>
    </React.Fragment>
  )
}
