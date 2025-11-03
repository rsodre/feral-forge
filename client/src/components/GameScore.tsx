import { Flex, Heading, Spinner } from '@radix-ui/themes'
import { useGameInfo } from '../hooks/useGameInfo';
import { useControllerUsername } from '../hooks/useControllerUsername';
import { useDelay } from './useDelay';

export function GameScore({
  gameId,
}: {
  gameId: number;
}) {
  const _gameId = useDelay(gameId, 3000);
  const { gameInfo } = useGameInfo(_gameId ?? 0);
  const { username } = useControllerUsername(gameInfo?.top_score_address ?? '');

  if (!gameInfo) {
    return (
      <Flex direction="column" align="center" gap="1">
        <Heading size="4" weight="bold">Loading Top Score...</Heading>
        <Spinner />
      </Flex>
    )
  }

  return (
    <Flex direction="column" align="center" gap="1">
      <Heading size="4" weight="bold">Top Score</Heading>
      <Heading size="3" className='Accent11'>{username}</Heading>
      <Heading size="1">Score: {Number(gameInfo?.top_score ?? 0)}</Heading>
      <Heading size="1">Moves: {Number(gameInfo?.top_score_move_count ?? 0)}</Heading>
    </Flex>
  )
}
