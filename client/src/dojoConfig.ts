import { createDojoConfig } from "@dojoengine/core";

// import manifest from "../../dojo/manifest_dev.json";
import manifest from "./generated/manifest_dev.json";

export const dojoConfig = createDojoConfig({
  manifest,
});
