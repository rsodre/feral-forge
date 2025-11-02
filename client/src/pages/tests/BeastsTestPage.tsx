import { useMemo } from 'react';
import { Flex, Grid} from '@radix-ui/themes'
import BeastImage from '../../components/BeastImage'
import App from '../../components/App'

export default function BeastsTestPage() {

  const beasts = useMemo(() => {
    return new Array(75).fill(0).map((_, index) => <BeastImage key={index} beastId={index + 1} size='small' />);
  }, []);
  const shinies = useMemo(() => {
    return new Array(75).fill(0).map((_, index) => <BeastImage key={index} beastId={index + 101} size='small' />);
  }, []);

  return (
    <App bg='home'>
      <Flex direction='row' gap='2' width='100%' align='center' justify='center'>
        <Grid columns='10' gap='2' width='auto'
        // style={{ width: '50%' }}
        >
          {beasts}
          {shinies}
        </Grid>
      </Flex>
    </App>
  )
}
