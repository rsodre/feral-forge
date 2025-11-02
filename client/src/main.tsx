import '@radix-ui/themes/styles.css';
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { Theme } from '@radix-ui/themes';
import { init } from "@dojoengine/sdk";
import { DojoSdkProvider } from "@dojoengine/sdk/react";
import { setupWorld } from "./generated/typescript/contracts.gen.ts";
import { type SchemaType } from "./generated/typescript/models.gen.ts";
import StarknetProvider from "./starknet-provider.tsx";
import { dojoConfig } from "./dojoConfig.ts";
import App from './App.tsx'

const sdk = await init<SchemaType>({
  client: {
    worldAddress: dojoConfig.manifest.world.address,
  },
  domain: {
    name: "WORLD_NAME",
    version: "1.0",
    chainId: "KATANA",
    revision: "1",
  },
});

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <DojoSdkProvider
      sdk={sdk}
      dojoConfig={dojoConfig}
      clientFn={setupWorld}
    >
      <StarknetProvider>
        <Theme accentColor='violet' appearance='dark'>
          <App />
        </Theme>
      </StarknetProvider>
    </DojoSdkProvider>
  </StrictMode>,
)
