import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { Flex, Text, Button, Grid, Box, Inset, Card, AspectRatio, Link, Heading, Spinner } from '@radix-ui/themes'
import { useAccount, useBlockNumber } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { WalletAccount } from './wallet-account';
import { SchemaType } from './generated/typescript/models.gen';
// import * as torii from "@dojoengine/torii-wasm";
// import { getContractByName } from '@dojoengine/core';
// import manifest from './generated/manifest_dev.json';

export default function App() {
  const { sdk, client } = useDojoSDK<() => any, SchemaType>();
  const { account, isConnected } = useAccount();
  const { data: blockNumber } = useBlockNumber({
    refetchInterval: 1000,
  });

  const [totalSupply, setTotalSupply] = useState(0);
  useEffect(() => {
    if (client) {
      console.log("Getting total supply...");
      client.token.totalSupply().then((totalSupply: number) => {
        setTotalSupply(Number(totalSupply));
      });
    }
  }, [client, blockNumber]);

  const _mint = useCallback(() => {
    if (client && account) {
      console.log("Minting...");
      client.minter.mint(account);
    }
  }, [client, account]);

  // useEffect(() => {
  //   if (sdk) {
  //     const contractAddresses = getContractByName(manifest, 'aster', 'token').address;
  //     sdk.getTokens({
  //       contractAddresses: [contractAddresses],
  //     }).then((tokens) => {
  //       console.log(tokens);
  //     });
  //   }
  // }, [sdk]);

  const [tokenId, setTokenId] = useState(0);
  const items = useMemo(() => {
    return new Array(totalSupply).fill(0).map((_, index) => <TokenImage key={index} tokenId={index + 1} setTokenId={setTokenId} />);
  }, [totalSupply]);

  return (
    <Flex direction='row' gap='2' width='100%'>
      <Grid columns='6' gap='2' width='auto' style={{ width: '50%' }}>
        {items}
        <Box width='100%' >
          <Button disabled={!isConnected} onClick={_mint} style={{ width: '100%' }}>Mint</Button>
        </Box>
      </Grid>
      <Box width='50%'>
        <WalletAccount />
        <Text>
          block [{blockNumber}] minted [{totalSupply}]
        </Text>
        {tokenId && <TokenImage tokenId={tokenId} />}
        {!tokenId && <ContractInfo />}
      </Box>
    </Flex>
  )
}




//-----------------------------------
// Token #XX Image
//
const ContractInfo = () => {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const [uri, setUri] = useState<any>({});
  useEffect(() => {
    client?.token.contractUri().then((uri: string) => {
      const json = JSON.parse(uri.replace('data:application/json,', ''));
      setUri(json);
    });
  }, [client]);
  return (
    <Box>
      <Heading>{uri.name} / {uri.symbol}</Heading>
      <Text>{uri.description}</Text>
      <Link href={uri.external_link} target='_blank'>{uri.external_link}</Link>
      <Flex direction='row' gap='2'>
        <Image src={uri.image} label={`IMAGE`} />
        <Image src={uri.banner_image} label={`BANNER`} />
      </Flex>
    </Box>
  );
};



//-----------------------------------
// Token #XX Image
//
const TokenImage = ({
  tokenId,
  setTokenId,
}: {
  tokenId: number,
  setTokenId?: (tokenId: number) => void
}) => {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const [image, setImage] = useState('');
  useEffect(() => {
    client?.token.tokenUri(tokenId).then((uri: string) => {
      const json = JSON.parse(uri.replace('data:application/json,', ''));
      setImage(json.image);
    });
  }, [client, tokenId]);
  if (!image) return <Spinner />;
  return (
    <Image src={image} label={`ASTRAEA#${tokenId}`} tokenId={tokenId} setTokenId={setTokenId} />
  );
};

//-----------------------------------
// Generic Image
//
const Image = ({
  src,
  label,
  tokenId,
  setTokenId,
}: {
  src: string,
  label: string,
  tokenId?: number,
  setTokenId?: (tokenId: number) => void
}) => {
  return (
    <Box>
      <Flex direction='column' gap='2'>
        <AspectRatio ratio={1}>
          <img src={src}
            style={{
              height: "100%",
              width: 'auto',
              backgroundColor: "var(--gray-5)",
              cursor: setTokenId ? "pointer" : "default",
            }}
            onClick={() => setTokenId?.(tokenId ?? 0)}
          />
        </AspectRatio>
        <Text size='1' color='gray'>{label}</Text>
      </Flex>
    </Box>
  );
};