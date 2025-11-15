import { useMemo } from 'react';
import { useNavigate } from 'react-router';
import { Flex, Heading, Separator } from '@radix-ui/themes'
import { useAccount } from '@starknet-react/core';
import { useTotalSupply } from '../hooks/useTotalSupply';
import { ConnectButton } from '../components/ConnectButton';
import { MenuButton } from '../components/Buttons';
import { TopMenu } from '../components/TopMenu';
import App from '../components/App';

export default function MainPage() {
  const navigate = useNavigate()
  const { account, address, isConnected } = useAccount();
  const { totalSupply } = useTotalSupply();

  const randomGameId = useMemo(() => Math.floor(Math.random() * (totalSupply - 1)) + 1, [totalSupply]);

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

          <MenuButton onClick={() => navigate(`/play/${randomGameId}`)} disabled={!isConnected}>Quick Game</MenuButton>
          <MenuButton onClick={() => navigate('/games/1')} disabled={!isConnected}>Select Level</MenuButton>
          <ConnectButton /> 
          <MenuButton onClick={() => navigate('/help')}>How to Play</MenuButton>
        </Flex>
      </Flex>
    </App>
  )
}
