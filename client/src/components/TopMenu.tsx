'use client';
import { useMemo } from 'react';
import { Box, Flex, IconButton, DropdownMenu, Button } from '@radix-ui/themes';
import { HamburgerMenuIcon, HomeIcon } from '@radix-ui/react-icons';
import { ConnectButton } from './ConnectButton';
import { useNavigate } from 'react-router';

export function TopMenu() {
  const navigate = useNavigate()

  const items = useMemo(() => [
    <Button onClick={() => navigate('/')}>
      Home
    </Button>,
    <Button onClick={() => navigate('/games')}>
      Play Now
    </Button>,
    <Button onClick={() => navigate('/help')}>
      How To Play
    </Button>,
    <ConnectButton />,
  ], []);

  return (
    <Flex align='center' gap='2' justify='end' wrap='nowrap' p="4"
      style={{ position: 'absolute', top: '0', right: '0' }}
    >

      <DropdownMenu.Root>
        <DropdownMenu.Trigger>
          <IconButton variant='soft' size='3'>
            <HamburgerMenuIcon />
          </IconButton>
        </DropdownMenu.Trigger>

        <DropdownMenu.Content>
          {items.map((item, index) => (
            <DropdownMenu.Item key={index} style={{ marginBottom: '10px' }}>
              <Box style={{ width: '100%', textAlign: 'right' }}>
                {item}
              </Box>
            </DropdownMenu.Item>
          ))}
        </DropdownMenu.Content>
      </DropdownMenu.Root>

    </Flex>
  );
}
