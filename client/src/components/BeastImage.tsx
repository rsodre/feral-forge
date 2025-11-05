import { useMemo } from "react";
import { Box, Code, Strong, Text, Tooltip } from "@radix-ui/themes";
import { BEAST_NAMES } from "../data/BeastData";

export const TIER_COLORS = {
  1: '#FF8800', // orange
  2: '#8D00BF', // purple
  3: '#0800FF', // blue
  4: '#00FF00', // green
  5: '#FFFFFF', // white
}

export const SCORE_PER_TIER = {
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

export function BeastImage({
  beastId,
  size = 'small',
  label,
  displayTier,
}: {
  beastId: number,
  size?: 'small' | 'medium' | 'large',
  label?: string | React.ReactNode,
  displayTier?: boolean,
}) {
  const _shiny = useMemo(() => (beastId > 100), [beastId]);
  const _id = useMemo(() => (beastId > 100 ? beastId - 100 : beastId), [beastId]);
  const type = useMemo(() => (_shiny ? 'shiny' : 'regular'), [_shiny]);
  const tier = useMemo(() => Math.floor(((((_id - 1) / 5) % 5) + 1)), [_id]);
  const tierName = useMemo(() => (`${_shiny ? 'S' : 'T'}${tier}`), [_shiny, tier]);
  const beastName = useMemo(() => {
    return (BEAST_NAMES[_id as keyof typeof BEAST_NAMES] as string)?.toLowerCase() ?? '_unknown';
  }, [_id]);
  const px = useMemo(() => (size === 'small' ? 64 : size === 'medium' ? 128 : 256), [size]);
  const border = useMemo(() => (_shiny ? `2px solid ${TIER_COLORS[tier as keyof typeof TIER_COLORS]}` : undefined), [_shiny, tier]);
  // console.log(`BEAST:`, beastId, _id, _shiny, tier);
  return (
    <Box style={{
      width: `${px}px`,
      height: `${px}px`,
      padding: '4px',
      position: 'relative',
    }}>
      <Tooltip style={{ display: _id > 0 ? 'block' : 'none' }} content={
        <Strong>{`${tierName} ${beastName} / ${SCORE_PER_TIER[tierName as keyof typeof SCORE_PER_TIER]} pts`}</Strong>
      }>
        <img
          className='BeastImage'
          src={`/beasts/static/${type}/${beastName}.png`}
          alt={`Beast ${beastId}`}
          style={{
            border,
          }}
        />
      </Tooltip>
      {displayTier && _id > 0 &&
        <Box style={{ position: 'absolute', bottom: '-0.2em', right: '0' }}>
          <Code size="1" weight="bold" style={{ color: 'white' }}>{tierName}</Code>
        </Box>
      }
      {label &&
        <Box my="-0.8em">
          <Text size="1">{label}</Text>
        </Box>
      }
    </Box>
  );
}