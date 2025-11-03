import '@radix-ui/themes/styles.css';
import './styles/global.css'
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { createBrowserRouter, RouterProvider } from 'react-router'
import { Theme, ThemePanel } from '@radix-ui/themes';
import { DojoSdkProvider } from "@dojoengine/sdk/react";
import { setupWorld } from "./generated/contracts.gen.ts";
import { dojoConfig, createDojoSdk } from "./dojo/dojoConfig.ts";
import StarknetProvider from "./dojo/StarknetProvider.tsx";
import MintTestPage from './pages/tests/MintTestPage.tsx';
import BeastsTestPage from './pages/tests/BeastsTestPage.tsx';
import ErrorPage from './pages/ErrorPage.tsx';
import MainPage from './pages/MainPage.tsx';
import GamesPage from './pages/GamesPage.tsx';
import HelpPage from './pages/HelpPage.tsx';
import PlayPage from './pages/PlayPage.tsx';

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
      { path: "/help", element: <HelpPage /> },
      { path: "/games", element: <GamesPage /> },
      { path: "/play/:game_id", element: <PlayPage /> },
    ],
    errorElement: <ErrorPage />,
  },
  // test pages
  {
    path: '/tests',
    children: [
      { path: "mint", element: <MintTestPage /> },
      { path: "beasts", element: <BeastsTestPage /> },
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
