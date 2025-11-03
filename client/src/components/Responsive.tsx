'use client';
import { Box } from '@radix-ui/themes';

// from Box display props
const displayValues = ['none', 'inline', 'inline-block', 'block', 'contents'] as const;

export function DesktopOnly({
  display = 'inline',
  children
}: {
  display?: (typeof displayValues)[number]
  children: React.ReactNode
}) {
  return (
    <Box display={{
      initial: 'none',
      xs: display,
    }}>
      {children}
    </Box>
  );
}

export function MobileOnly({
  display = 'inline',
  children
}: {
  display?: (typeof displayValues)[number]
  children: React.ReactNode
}) {
  return (
    <Box display={{
      initial: display,
      xs: 'none',
    }}>
      {children}
    </Box>
  );
}
