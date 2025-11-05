import { useCallback } from 'react';
import { useAccount, useConnect } from '@starknet-react/core';
import { useConnectedController } from '../hooks/useController';
import { MenuButton } from './Buttons';

export function ConnectButton({
  size = '3',
}: {
  size?: '1' | '2' | '3';
}) {
  const { account, address, isConnected } = useAccount();
  const { connectAsync, connectors } = useConnect();

  const _connect = useCallback(async () => {
    await connectAsync({ connector: connectors[0] });
  }, [connectAsync, connectors]);

  const { openProfile, username, icon } = useConnectedController();
  const _openController = useCallback(() => {
    openProfile();
  }, [openProfile]);

  if (isConnected) {
    return (
      <MenuButton size={size} onClick={_openController} disabled={!isConnected}>
        <img src={(icon as string) ?? ''} style={{ width: '20px', height: '20px' }} />
        {' '}
        {username}
      </MenuButton>
    )
  }

  return (
    <MenuButton size={size} onClick={_connect} disabled={isConnected}>Connect</MenuButton>
  )
}
