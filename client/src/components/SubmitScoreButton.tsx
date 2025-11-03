import { useCallback, useMemo, useState } from 'react';
import { Button } from '@radix-ui/themes'
import { useAccount } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { SchemaType } from '../generated/models.gen';
import { directionToCairoCustomEnum, MoveDirection } from '../data/types';

export function SubmitScoreButton({
  gameId,
  movesHistory,
  onSubmitted,
  disabled,
}: {
  gameId: number;
  movesHistory: MoveDirection[];
  onSubmitted: (gameId: number) => void;
  disabled?: boolean;
}) {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const { account, address, isConnected } = useAccount();

  const [submitting, setSubmitting] = useState<boolean>(false);
  const [submitted, setSubmitted] = useState<boolean>(false);

  const _submit = useCallback(() => {
    if (client && account) {
      console.log("Submitting...");
      setSubmitting(true);
      client.game_token.submitGame(account, gameId, movesHistory.map(direction => directionToCairoCustomEnum(direction))).then(() => {
        console.log("Submitted!");
        setSubmitted(true);
        setSubmitting(false);
        onSubmitted(gameId);
      });
    }
  }, [client, account, gameId, movesHistory]);

  return (
    <Button size="3" onClick={_submit} disabled={disabled || !isConnected || submitting || submitted}>Submit your Score!!!</Button>
  )
}
