import { useCallback } from 'react';
import { Button } from '@radix-ui/themes'
import { useAccount, useConnect } from '@starknet-react/core';
import { useConnectedController } from '../hooks/useController';

export function ConnectButton() {
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
      <Button size="3" onClick={_openController} disabled={!isConnected}>
        <img src={(icon as string) ?? ''} style={{ width: '20px', height: '20px' }} />
        {' '}
        {username}
      </Button>
    )
  }

  return (
    <Button size="3" onClick={_connect} disabled={isConnected}>Connect</Button>
  )
}
