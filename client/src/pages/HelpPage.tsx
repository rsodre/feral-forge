import { useCallback } from 'react';
import { useNavigate } from 'react-router';
import { Flex, Button, Heading, Separator, Text, Strong, Grid } from '@radix-ui/themes'
import { PlusIcon, ArrowRightIcon } from '@radix-ui/react-icons';
import { TopMenu } from '../components/TopMenu';
import BeastImage from '../components/BeastImage';
import App from '../components/App';

const SCORE_PER_TIER = {
  'T5': 1,
  'T4': 3,
  'T3': 10,
  'T2': 30,
  'T1': 100,
  'S5': 50,
  'S4': 100,
  'S3': 150,
  'S2': 200,
  'S1': 250,
}

const _score = (tier: keyof typeof SCORE_PER_TIER) => (`${SCORE_PER_TIER[tier]} pts`)

export default function HelpPage() {
  const navigate = useNavigate()

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

          <Grid columns={{ initial: '1', sm: '2' }} gapY="4" gapX="6">
            <Flex align="center" justify="center">
              <BeastImage beastId={21} size='small' label={_score('T5')} displayTier />
              <PlusIcon />
              <BeastImage beastId={22} size='small' label={_score('T5')} displayTier />
              <ArrowRightIcon />
              <BeastImage beastId={16} size='small' label={_score('T4')} displayTier />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={17} size='small' label={_score('T4')} displayTier />
              <PlusIcon />
              <BeastImage beastId={16} size='small' label={_score('T4')} displayTier />
              <ArrowRightIcon />
              <BeastImage beastId={11} size='small' label={_score('T3')} displayTier />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={11} size='small' label={_score('T3')} displayTier />
              <PlusIcon />
              <BeastImage beastId={12} size='small' label={_score('T3')} displayTier />
              <ArrowRightIcon />
              <BeastImage beastId={6} size='small' label={_score('T2')} displayTier />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={6} size='small' label={_score('T2')} displayTier />
              <PlusIcon />
              <BeastImage beastId={7} size='small' label={_score('T2')} displayTier />
              <ArrowRightIcon />
              <BeastImage beastId={1} size='small' label={_score('T1')} displayTier />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={16} size='small' label={_score('T4')} displayTier />
              <PlusIcon />
              <BeastImage beastId={16} size='small' label={_score('T4')}  displayTier />
              <ArrowRightIcon />
              <BeastImage beastId={116} size='small' label={_score('S4')} displayTier />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={15} size='small' label={_score('T3')} displayTier />
              <PlusIcon />
              <BeastImage beastId={15} size='small' label={_score('T3')} displayTier />
              <ArrowRightIcon />
              <BeastImage beastId={115} size='small' label={_score('S3')} displayTier />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={6} size='small' label={_score('T2')} displayTier />
              <PlusIcon />
              <BeastImage beastId={6} size='small' label={_score('T2')} displayTier />
              <ArrowRightIcon />
              <BeastImage beastId={106} size='small' label={_score('S2')} displayTier />
            </Flex>

            <Flex align="center" justify="center">
              <BeastImage beastId={1} size='small' label={_score('T1')} displayTier />
              <PlusIcon />
              <BeastImage beastId={1} size='small' label={_score('T1')} displayTier />
              <ArrowRightIcon />
              <BeastImage beastId={101} size='small' label={_score('S1')} displayTier />
            </Flex>
          </Grid>

          <Separator my="1" style={{ opacity: 0 }} />

          <Text size="3">
            <Strong>Higher Tiers</Strong> score more points
            <br />
            <Strong>Shinies</Strong> score even more!
          </Text>

          <Button size="3" onClick={() => navigate('/')}>Back</Button>
        </Flex>
      </Flex>
    </App>
  )
}
