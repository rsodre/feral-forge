import { useMemo } from 'react';
import { Link, useNavigate } from 'react-router';
import { Code, Flex, Heading, Separator, Strong, Text } from '@radix-ui/themes'
import { useAccount } from '@starknet-react/core';
import { useTotalSupply } from '../hooks/useTotalSupply';
import { ConnectButton } from '../components/ConnectButton';
import { MenuButton } from '../components/Buttons';
import { TopMenu } from '../components/TopMenu';
import App from '../components/App';

export default function AboutPage() {
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

          <Separator my="2" style={{ opacity: 0 }} />

          <Text size="2">
            Developed by <Strong>Mataleone</Strong>
            <br />
            <Strong>Underware Games</Strong>
            <br />
            <Code size="2">
              <a className="Anchor" href="https://x.com/matalecode">@matalecode</a>
            </Code>
            {' | '}
            <Code size="2">
              <a className="Anchor" href="https://x.com/underware_gg">@underware_gg</a>
            </Code>
          </Text>

          <Text size="1">
            Made with <Strong>Dojo</Strong>
            <br />
            <Code size="2">
              <a className="Anchor" href="https://x.com/ohayo_dojo">@ohayo_dojo</a>
            </Code>
          </Text>

          <Text size="1">
            Beasts from <Strong>Loot Survivor</Strong>
            <br />
            <Code size="2">
              <a className="Anchor" href="https://x.com/LootSurvivor">@LootSurvivor</a>
            </Code>
          </Text>

          <Text size="1">
            Deployed on
            <br />
            <Strong>Starknet</Strong> Sepolia
            <br />
            <Code size="2">
              <a className="Anchor" href="https://x.com/starknet">@Starknet</a>
            </Code>
          </Text>

          <Separator my="2" style={{ opacity: 0 }} />

          <MenuButton onClick={() => navigate('/')}>Back</MenuButton>

        </Flex>
      </Flex>
    </App>
  )
}
