import '@radix-ui/themes/styles.css';
import './global.css'
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { createBrowserRouter, RouterProvider } from 'react-router'
import { Theme, ThemePanel } from '@radix-ui/themes';
import { DojoSdkProvider } from "@dojoengine/sdk/react";
import { setupWorld } from "./generated/contracts.gen.ts";
import { dojoConfig, createDojoSdk } from "./dojo/dojoConfig.ts";
import StarknetProvider from "./dojo/starknet-provider.tsx";
import TestsMintPage from './pages/TestsMintPage.tsx';
import ErrorPage from './pages/ErrorPage.tsx';
import MainPage from './pages/MainPage.tsx';

//
// REF:
// https://reactrouter.com/6.28.1/routers/create-browser-router
// https://api.reactrouter.com/v7/functions/react_router.createBrowserRouter.html
//
const router = createBrowserRouter([
  {
    path: '/',
    children: [
      { path: "", element: <MainPage /> },
      // { path: "/play", element: <PlayPage /> },
    ],
    errorElement: <ErrorPage />,
  },
  // test pages
  {
    path: '/tests',
    children: [
      { path: "mint", element: <TestsMintPage /> },
    ],
  },
]);


const sdk = await createDojoSdk();

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <DojoSdkProvider
      sdk={sdk}
      dojoConfig={dojoConfig}
      clientFn={setupWorld}
    >
      <StarknetProvider>
        <Theme accentColor='amber' appearance='dark'>
          {/* <ThemePanel defaultOpen={true} /> */}
          <RouterProvider router={router} />
        </Theme>
      </StarknetProvider>
    </DojoSdkProvider>
  </StrictMode>,
)
