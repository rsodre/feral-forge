import { Chain, mainnet, NativeCurrency, sepolia } from "@starknet-react/chains";
import { createDojoConfig, KATANA_ETH_CONTRACT_ADDRESS } from "@dojoengine/core";
import { init, SDK } from "@dojoengine/sdk";
import { type SchemaType } from "../generated/models.gen.ts";
import { stringToFelt } from "../utils/starknet.ts";
import manifest_dev from "../generated/manifest_dev.json";
import manifest_sepolia from "../generated/manifest_sepolia.json";
// import manifest_mainnet from "../generated/manifest_mainnet.json";

const PROFILE = 'sepolia';

const ETH_KATANA: NativeCurrency = {
  address: KATANA_ETH_CONTRACT_ADDRESS,
  name: 'Ether',
  symbol: 'ETH',
  decimals: 18,
}

const katanaRpcUrl = "http://127.0.0.1:5050";
const katanaChain: Chain = {
  id: BigInt(stringToFelt("KATANA_LOCAL")),
  name: "KATANA_LOCAL",
  network: 'katana',
  testnet: true,
  nativeCurrency: ETH_KATANA,
  rpcUrls: {
    default: { http: [katanaRpcUrl] },
    public: { http: [] },
  },
  paymasterRpcUrls: {
    default: { http: [katanaRpcUrl] },
    public: { http: [katanaRpcUrl] },
    avnu: { http: [katanaRpcUrl] },
  },
  // explorers: [cartridge],
};

export type ProfileConfig = {
  manifest: any;
  chain: Chain;
  chainId: bigint;
  chainName: string;
  rpcUrl: string;
  toriiUrl: string | undefined;
  slotName: string | undefined;
};

const profiles: Record<string, ProfileConfig> = {
  dev: {
    manifest: manifest_dev,
    chain: katanaChain,
    chainId: katanaChain.id,
    chainName: katanaChain.name,
    rpcUrl: katanaRpcUrl,
    toriiUrl: undefined,
    slotName: undefined,
  },
  sepolia: {
    manifest: manifest_sepolia,
    chain: sepolia,
    chainId: sepolia.id,
    chainName: "SN_SEPOLIA",
    rpcUrl: "https://api.cartridge.gg/x/starknet/sepolia/rpc/v0_9",
    toriiUrl: undefined,
    slotName: 'kode-sepolia',
  },
  mainnet: {
    manifest: {},
    chain: mainnet,
    chainId: mainnet.id,
    chainName: "SN_MAIN",
    rpcUrl: "https://api.cartridge.gg/x/starknet/mainnet/rpc/v0_9",
    toriiUrl: undefined,
    slotName: 'kode-mainnet',
  },
}

export const profileConfig = profiles[PROFILE];

export const dojoConfig = createDojoConfig({
  manifest: profileConfig.manifest,
  rpcUrl: profileConfig.rpcUrl,
  toriiUrl: profileConfig.toriiUrl,
});

export const createDojoSdk = async (): Promise<SDK<SchemaType>> => {
  return await init<SchemaType>({
    client: {
      worldAddress: dojoConfig.manifest.world.address,
    },
    domain: {
      name: "FERAL_FORGE",
      version: "1.0",
      chainId: profileConfig.chainName,
      revision: "1",
    },
  });
};
