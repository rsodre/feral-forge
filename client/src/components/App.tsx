import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { Flex, Text, Button, Grid, Box, Inset, Card, AspectRatio, Link, Heading, Spinner } from '@radix-ui/themes'
import { useAccount, useBlockNumber } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { WalletAccount } from '../dojo/wallet-account';
import { SchemaType } from '../generated/models.gen';
// import * as torii from "@dojoengine/torii-wasm";
// import { getContractByName } from '@dojoengine/core';
// import manifest from './generated/manifest_dev.json';

export default function App({
  bg,
  children,
}: {
  bg: 'home' | 'game' | undefined;
  children: React.ReactNode;
}) {
  const classNames = useMemo(() => ([
    bg == 'game' ? 'AppGame' : 'AppHome',
  ]), [bg]);

  return (
    <div className={classNames.join(' ')}>
      {children}
    </div>
  )
}
