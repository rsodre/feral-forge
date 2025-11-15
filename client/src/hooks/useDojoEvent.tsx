import { useEffect, useMemo, useState } from 'react';
import { useBlockNumber, useEvents } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { SchemaType } from '../generated/models.gen';
import { BlockTag } from 'starknet';
import { getContractByName } from '@dojoengine/core';
import { bigintToAddress, isPositiveBigint } from '../utils/types';

export const useDojoEvent = (contractName: string, eventName: string, enabled: boolean) => {
  const { config } = useDojoSDK<() => any, SchemaType>();

  // get start block when hook is enabled
  const [startBlock, setStartBlock] = useState<number>(0);
  const { data: blockNumber } = useBlockNumber({ enabled });
  useEffect(() => {
    if (enabled && blockNumber && startBlock === 0) {
      setStartBlock(blockNumber);
    }
  }, [enabled, blockNumber, startBlock]);

  const contractAddress = useMemo(() => getContractByName(config.manifest, 'feral', contractName), [config.manifest])
  const { data, error } = useEvents({
    address: startBlock && isPositiveBigint(contractAddress) ? bigintToAddress(contractAddress) : undefined,
    eventName,
    fromBlock: startBlock,
    toBlock: BlockTag.LATEST,
    pageSize: 10,
  });
  console.log(`>>> EVENT (${contractName}:${eventName})`, startBlock, data, error);

  return {
    data,
    error,
  }
}
