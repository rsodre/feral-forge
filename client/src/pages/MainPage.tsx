import { useMemo } from 'react';
import { useNavigate } from 'react-router';
import { Box, Code, Flex, Heading, Separator, Text } from '@radix-ui/themes'
import { useAccount } from '@starknet-react/core';
import { useTotalSupply } from '../hooks/useTotalSupply';
import { ConnectButton } from '../components/ConnectButton';
import { MenuButton } from '../components/Buttons';
import { TopMenu } from '../components/TopMenu';
import { PACKAGE_VERSION } from '../data/constants';
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

          <Separator my="3" style={{ opacity: 0 }} />

          <MenuButton onClick={() => navigate(`/play/${randomGameId}`)} >Quick Game</MenuButton>
          <MenuButton onClick={() => navigate('/games/1')}>Select Level</MenuButton>
          <MenuButton onClick={() => navigate('/help')}>How to Play</MenuButton>
          <MenuButton onClick={() => navigate('/about')}>About</MenuButton>
          <ConnectButton />

          <Separator my="1" style={{ opacity: 0 }} />

          <Box>
            <Code size="2">
              <a className="Code Anchor" href="https://x.com/matalecode">@matalecode</a>
            </Code>
            {' | '}
            <Code size="2">
              <a className="Code Anchor" href="https://x.com/underware_gg">@underware_gg</a>
            </Code>
            <br />
            <Code size="1" variant='ghost' color='gray'>
              v{PACKAGE_VERSION}
            </Code>
          </Box>

        </Flex>
      </Flex>
    </App>
  )
}
