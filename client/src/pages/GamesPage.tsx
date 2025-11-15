import React, { useCallback, useMemo } from 'react';
import { useNavigate } from 'react-router';
import { Flex, Button, Heading, Text, Strong, Spinner, Box } from '@radix-ui/themes'
import { useGamesInfo } from '../hooks/useGameInfo';
import { useRouteSlugs } from '../hooks/useRoute';
import { MintGameButton } from '../components/MintGameButton';
import { TopMenu } from '../components/TopMenu';
import { MenuButton } from '../components/Buttons';
import App from '../components/App';
import { GameInfo } from '../generated/models.gen';
import { useControllerUsername } from '../stores/controllerNameStore';

const PAGE_SIZE = 10;

export default function GamesPage() {
  const navigate = useNavigate()
  const { page_num } = useRouteSlugs()
  // const { totalSupply } = useTotalSupply(2);

  const startGameId = useMemo(() => ((Number(page_num ?? 1) - 1) * PAGE_SIZE + 1), [page_num]);
  const { gamesInfo } = useGamesInfo(startGameId, PAGE_SIZE);
  const items = useMemo(() => {
    return gamesInfo?.map((gameInfo) => (
      <GameRow key={gameInfo.game_id} gameInfo={gameInfo} />
    )) ?? Array.from({ length: PAGE_SIZE }, (_, index) => (
      <GameRow key={index} gameInfo={{
        game_id: startGameId + index,
      } as GameInfo} />
    ));
  }, [gamesInfo]);

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
        <Flex direction="column" align="center" gapX="0" gapY="4" style={{
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

          <Flex direction="column" align="center" gap="2" style={{ width: '100%', maxWidth: '450px' }}>
            <GamesRow>
              <Text><Strong>Game</Strong></Text>
              <Text><Strong>Forger</Strong></Text>
              <Text><Strong>Holder</Strong></Text>
              <Text><Strong>Score</Strong></Text>
              <Text></Text>
            </GamesRow>
            {items}
          </Flex>

          <MintGameButton onMint={_minted}>Forge a New Game</MintGameButton>

          <MenuButton onClick={() => navigate('/')}>Back</MenuButton>
        </Flex>
      </Flex>
    </App>
  )
}

function GameRow({
  gameInfo,
}: {
  gameInfo: GameInfo;
}) {
  const navigate = useNavigate()
  const { username: forgerName } = useControllerUsername(gameInfo?.minter_address ?? '');
  const { username: topPlayerName } = useControllerUsername(gameInfo?.top_score_address ?? '');

  const _play = useCallback(() => {
    navigate(`/play/${Number(gameInfo.game_id)}`);
  }, []);

  return (
    <ButtonRow onClick={_play}>
      <Text size="1">Forge #{Number(gameInfo.game_id) ?? <Spinner />}</Text>
      <Text size="1">{forgerName || <Spinner />}</Text>
      <Text size="1">{topPlayerName || <Spinner />}</Text>
      <Text size="1">{gameInfo ? Number(gameInfo.top_score) : <Spinner />}</Text>
    </ButtonRow>
  )
}


function ButtonRow({
  onClick,
  children,
}: {
  onClick: () => void;
  children: React.ReactNode[];
}) {

  return (
    <Button size="1" variant="soft" onClick={onClick} style={{ width: '100%' }}>
      <GamesRow>
        {children}
      </GamesRow>
    </Button>
  )
}


function GamesRow({
  children,
}: {
  children: React.ReactNode[];
}) {
  const widths = ['30%', '30%', '30%', '15%'];

  return (
    <Flex direction="row" align="center" gap="2" width="100%">
      <Box style={{ flex: '1' }}></Box>
      {children.map((child, index) => (
        <Flex key={index} align="center" justify="center"
          width={widths[index]}
        >
          {child}
        </Flex>
      ))}
      <Box style={{ flex: '1' }}></Box>
    </Flex>
  )
}
{/* <Grid columns="5" gap="2" align="center" justify="center"> */}
