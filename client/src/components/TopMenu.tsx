'use client';
import { useMemo } from 'react';
import { Box, Flex, IconButton, DropdownMenu, Button } from '@radix-ui/themes';
import { HamburgerMenuIcon } from '@radix-ui/react-icons';
import { useNavigate } from 'react-router';
import { ConnectButton } from './ConnectButton';
import { MenuButton } from './Buttons';

export function TopMenu() {
  const navigate = useNavigate()

  const items = useMemo(() => [
    <MenuButton size='2' onClick={() => navigate('/')}>
      Home
    </MenuButton>,
    <MenuButton size='2' onClick={() => navigate('/games/1')}>
      Select Level
    </MenuButton>,
    <MenuButton size='2' onClick={() => navigate('/help')}>
      How To Play
    </MenuButton>,
    <MenuButton size='2' onClick={() => navigate('/about')}>
      About
    </MenuButton>,
    <ConnectButton size='2' />,
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
