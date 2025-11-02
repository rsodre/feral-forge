import { useMemo } from "react";
import { Box } from "@radix-ui/themes";
import { BEAST_NAMES } from "../data/BeastData";

const TIER_COLORS = {
  1: '#FF8800', // orange
  2: '#8D00BF', // purple
  3: '#0800FF', // blue
  4: '#00FF00', // green
  5: '#FFFFFF', // white
}

export default function BeastImage({
  beastId,
  size,
}: {
  beastId: number,
  size: 'small' | 'medium' | 'large',
}) {
  const _shiny = useMemo(() => (beastId > 100), [beastId]);
  const _id = useMemo(() => (beastId > 100 ? beastId - 100 : beastId), [beastId]);
  const type = useMemo(() => (_shiny ? 'shiny' : 'regular'), [_shiny]);
  const tier = useMemo(() => Math.floor(((((_id - 1) / 5) % 5) + 1)), [_id]);
  const beastName = useMemo(() => {
    return (BEAST_NAMES[_id as keyof typeof BEAST_NAMES] as string)?.toLowerCase() ?? '_unknown';
  }, [_id]);
  const px = useMemo(() => (size === 'small' ? 64 : size === 'medium' ? 128 : 256), [size]);
  const border = useMemo(() => (_shiny ? `2px solid ${TIER_COLORS[tier as keyof typeof TIER_COLORS]}` : undefined), [_shiny, tier]);
  console.log(`BEAST:`, beastId, _id, _shiny, tier);
  return (
    <Box style={{
      width: `${px}px`,
      height: `${px}px`,
      padding: '4px',
    }}>
        <img
          className='BeastImage'
          src={`/beasts/static/${type}/${beastName}.png`}
          alt={`Beast ${beastId}`}
          style={{
            border,
          }}
        />
    </Box>
  );
}