import react from "@vitejs/plugin-react";
import { defineConfig, type UserConfig } from "vite";
import { VitePWA } from 'vite-plugin-pwa'
import topLevelAwait from "vite-plugin-top-level-await";
import wasm from "vite-plugin-wasm";

// PWA config based on:
// https://saroj-dev.hashnode.dev/how-i-turned-my-vite-web-app-into-a-pwa-progressive-web-app
// https://www.npmjs.com/package/vite-plugin-pwa

// https://vitejs.dev/config/
export const config: UserConfig = {
  plugins: [
    react(),
    wasm(),
    topLevelAwait(),
    VitePWA({
      registerType: 'autoUpdate',
      includeAssets: [
        'favicon.ico',
        'robots.txt',
        'apple-touch-icon.png',
      ],
      workbox: {
        maximumFileSizeToCacheInBytes: 3000000
      },
      manifest: {
        name: 'Feral Forge',
        short_name: 'Feral Forge',
        description: 'In the depths of Death Mountain lies the Feral Forge, a vicious playground where newborn beasts get prepared to rise for battle!',
        theme_color: '#FFD60A', // radix-ui Amber
        background_color: '#0d0704',
        display: 'standalone',
        start_url: '/',
        icons: [
          {
            src: '/assets/icon-pwa-192x192.png',
            sizes: '192x192',
            type: 'image/png'
          },
          {
            src: '/assets/icon-pwa-512x512.png',
            sizes: '512x512',
            type: 'image/png'
          },
          {
            src: '/assets/icon-pwa-512x512.png',
            sizes: '512x512',
            type: 'image/png',
            purpose: 'any maskable'
          }
        ]
      }
    })
  ],
};

export default defineConfig(config);
