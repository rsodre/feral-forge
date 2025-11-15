import { useCallback, useEffect, useMemo, useState } from 'react';
import { useNavigate } from 'react-router';
import { useAccount } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { useWaitForMint } from '../hooks/useWaitForMint';
import { SchemaType } from '../generated/models.gen';
import { MenuButton } from './Buttons';
import { ConnectButton } from './ConnectButton';

export function MintGameButton({
  onMint,
  disabled,
  children,
}: {
  onMint: (gameId: string) => void;
  disabled?: boolean;
  children: string;
}) {
  const navigate = useNavigate();
  const { client , config } = useDojoSDK<() => any, SchemaType>();
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

  // const { data } = useDojoEvent('game_token', 'Transfer', minting || minted);
  const { mintedGameId } = useWaitForMint(minting || minted);
  useEffect(() => {
    if (minted && mintedGameId) {
      navigate(`/play/${mintedGameId}`);
    }
  }, [minted, mintedGameId, navigate]);

  const label = useMemo(() => {
    if (minting) {
      return "Minting...";
    }
    if (minted) {
      return "Confirming...";
    }
    return children;
  }, [minting, minted, children]);

  if (!isConnected) {
    return <ConnectButton>{label}</ConnectButton>
  }

  return (
    <MenuButton onClick={_mint} disabled={disabled || !isConnected || minting || minted}>{label}</MenuButton>
  )
}
