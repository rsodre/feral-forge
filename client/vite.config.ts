import react from "@vitejs/plugin-react";
import { defineConfig, type UserConfig } from "vite";
import topLevelAwait from "vite-plugin-top-level-await";
import wasm from "vite-plugin-wasm";

// https://vitejs.dev/config/
export const config: UserConfig = {
  plugins: [react(), wasm(), topLevelAwait()],
};

export default defineConfig(config);
