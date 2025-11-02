import '@radix-ui/themes/styles.css';
import './global.css'
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { Theme } from '@radix-ui/themes';
import { DojoSdkProvider } from "@dojoengine/sdk/react";
import { setupWorld } from "./generated/contracts.gen.ts";
import { dojoConfig, createDojoSdk } from "./dojo/dojoConfig.ts";
import StarknetProvider from "./dojo/starknet-provider.tsx";
import App from './App.tsx';

const sdk = await createDojoSdk();

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <DojoSdkProvider
      sdk={sdk}
      dojoConfig={dojoConfig}
      clientFn={setupWorld}
    >
      <StarknetProvider>
        <Theme accentColor='red' appearance='dark'>
          <App />
        </Theme>
      </StarknetProvider>
    </DojoSdkProvider>
  </StrictMode>,
)
