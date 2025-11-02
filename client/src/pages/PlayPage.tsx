import { useCallback } from 'react';
import { useNavigate } from 'react-router';
import { Flex, Button, Heading, Separator } from '@radix-ui/themes'
import { useAccount } from '@starknet-react/core';
import { ConnectButton } from '../components/ConnectButton';
import App from '../components/App';

export default function PlayPage() {
  const navigate = useNavigate()
  const { account, address, isConnected } = useAccount();
  
  const _play = useCallback(() => {
    window.location.href = '/play';
  }, []);
  const _help = useCallback(() => {
    window.location.href = '/help';
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
          <Heading size="9" weight="bold" className='Accent11'>
            Feral Forge
          </Heading>

          <Separator my="4" style={{ opacity: 0 }} />

          <Button size="3" onClick={_play} disabled={!isConnected}>Play Now</Button>
          <ConnectButton /> 
          <Button size="3" onClick={_help}>How to Play</Button>
        </Flex>
      </Flex>
    </App>
  )
}
