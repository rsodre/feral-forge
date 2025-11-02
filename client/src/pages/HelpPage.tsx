import { useCallback } from 'react';
import { useNavigate } from 'react-router';
import { Flex, Button, Heading, Separator, Text, Strong, Grid } from '@radix-ui/themes'
import { PlusIcon, ArrowRightIcon } from '@radix-ui/react-icons';
import BeastImage from '../components/BeastImage';
import App from '../components/App';

export default function HelpPage() {
  const navigate = useNavigate()

  const _home = useCallback(() => {
    navigate('/');
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
          <Heading size="6" weight="bold" className='Accent11'>
            How To Play
          </Heading>

          <Text size="3">
            <Strong>Slide</Strong> the Grid
            <br />
            Up, Down, Left or Right
          </Text>

          <Text size="3">
            <Strong>Forge</Strong> Beasts of the same <Strong>Tier</Strong>
            <br />
            to <Strong>upgrade</Strong> to a higher Tier
          </Text>

          <Text size="3">
            <Strong>Forge</Strong> Beasts with the same <Strong>Name</Strong>
            <br />
            to <Strong>upgrade</Strong> to a <Strong>Shiny</Strong> Beast
          </Text>

          <Grid columns="2" gapY="4" gapX="6">
            <Flex align="center" justify="center">
              <BeastImage beastId={21} size='small' label='T5' />
              <PlusIcon />
              <BeastImage beastId={22} size='small' label='T5' />
              <ArrowRightIcon />
              <BeastImage beastId={16} size='small' label='T4' />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={17} size='small' label='T4' />
              <PlusIcon />
              <BeastImage beastId={16} size='small' label='T4' />
              <ArrowRightIcon />
              <BeastImage beastId={11} size='small' label='T3' />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={11} size='small' label='T3' />
              <PlusIcon />
              <BeastImage beastId={12} size='small' label='T3' />
              <ArrowRightIcon />
              <BeastImage beastId={6} size='small' label='T2' />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={6} size='small' label='T2' />
              <PlusIcon />
              <BeastImage beastId={7} size='small' label='T2' />
              <ArrowRightIcon />
              <BeastImage beastId={1} size='small' label='T1' />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={121} size='small' label='T5' />
              <PlusIcon />
              <BeastImage beastId={122} size='small' label='T5' />
              <ArrowRightIcon />
              <BeastImage beastId={116} size='small' label='T4' />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={117} size='small' label='T4' />
              <PlusIcon />
              <BeastImage beastId={116} size='small' label='T4' />
              <ArrowRightIcon />
              <BeastImage beastId={111} size='small' label='T3' />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={111} size='small' label='T3' />
              <PlusIcon />
              <BeastImage beastId={112} size='small' label='T3' />
              <ArrowRightIcon />
              <BeastImage beastId={106} size='small' label='T2' />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={106} size='small' label='T2' />
              <PlusIcon />
              <BeastImage beastId={107} size='small' label='T2' />
              <ArrowRightIcon />
              <BeastImage beastId={101} size='small' label='T1' />
            </Flex>
          </Grid>

          <Separator my="1" style={{ opacity: 0 }} />

          <Text size="3">
            <Strong>Lower Tiers</Strong> score more points
            <br />
            <Strong>Shinies</Strong> score even more!
          </Text>

          <Button size="3" onClick={_home}>Back</Button>
        </Flex>
      </Flex>
    </App>
  )
}
