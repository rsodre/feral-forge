import type { PropsWithChildren } from "react";
import { cartridge, cartridgeProvider, jsonRpcProvider, StarknetConfig } from "@starknet-react/core";
import { Chain } from "@starknet-react/chains";
import { profileConfig } from "./dojoConfig";
import { SessionPolicies } from '@cartridge/presets';
import { ControllerConnector } from "@cartridge/connector";
import { bigintToHex } from "../utils/types";

const policies: SessionPolicies = {
};

const controller = new ControllerConnector({
  policies,
  defaultChainId: bigintToHex(profileConfig.chainId),
  slot: profileConfig.slotName,
  // preset: "karat",
  chains: [{
    rpcUrl: profileConfig.rpcUrl,
  }],
});
console.log(`--- Controller options:`, controller);

function rpc(chain: Chain) {
  const nodeUrl = chain.rpcUrls.default.http[0] ?? profileConfig.rpcUrl;
  return {
    nodeUrl,
  }
}
const provider = jsonRpcProvider({ rpc })

export default function StarknetProvider({ children }: PropsWithChildren) {

  return (
    <StarknetConfig
      chains={[profileConfig.chain]}
      provider={provider}
      connectors={[controller]}
      explorer={cartridge}
      autoConnect
    >
      {children}
    </StarknetConfig>
  );
}
