import { useCallback } from 'react';
import { useNavigate } from 'react-router';
import { Flex, Heading } from '@radix-ui/themes'
import { useGameInfo } from '../hooks/useGameInfo';
import { useControllerUsername } from '../hooks/useControllerUsername';

export function GameScore({
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
    <Flex direction="column" align="center" gap="1">
      <Heading size="4" weight="bold">Top Score</Heading>
      <Heading size="3" className='Accent11'>{username}</Heading>
      <Heading size="1">Score: {Number(gameInfo?.top_score ?? 0)}</Heading>
      <Heading size="1">Moves: {Number(gameInfo?.top_score_move_count ?? 0)}</Heading>
    </Flex>
  )
}
