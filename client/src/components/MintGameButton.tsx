import { useCallback, useMemo, useState } from 'react';
import { useAccount } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { SchemaType } from '../generated/models.gen';
import { MenuButton } from './Buttons';

export function MintGameButton({
  onMint,
  disabled,
  children,
}: {
  onMint: (gameId: string) => void;
  disabled?: boolean;
  children: string;
}) {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const { account, address, isConnected } = useAccount();

  const [minting, setMinting] = useState<boolean>(false);
  const [minted, setMinted] = useState<boolean>(false);
  const [gameId, setGameId] = useState<number>();

  const _mint = useCallback(() => {
    if (client && account) {
      console.log("Minting...");
      setMinting(true);
      client.game_token.mint(account, address).then(() => {
        console.log("Minted!");
        setMinted(true);
        setMinting(false);
      });
    }
  }, [client, account]);

  const label = useMemo(() => {
    if (minting) {
      return "Minting...";
    }
    if (minted) {
      return "Minted! (see above)";
    }
    return children;
  }, [minting, minted, children]);

  return (
    <MenuButton onClick={_mint} disabled={disabled || !isConnected || minting || minted}>{label}</MenuButton>
  )
}
