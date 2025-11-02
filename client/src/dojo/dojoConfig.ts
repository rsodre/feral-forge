import { createDojoConfig } from "@dojoengine/core";
import { init, SDK } from "@dojoengine/sdk";
import { type SchemaType } from "../generated/models.gen.ts";
import manifest_dev from "../generated/manifest_dev.json";

export const profileConfig = {
  manifest: manifest_dev,
  chainId: "KATANA_LOCAL",
};

export const dojoConfig = createDojoConfig({
  manifest: profileConfig.manifest,
});

export const createDojoSdk = async (): Promise<SDK<SchemaType>> => {
  return await init<SchemaType>({
    client: {
      worldAddress: dojoConfig.manifest.world.address,
    },
    domain: {
      name: "FERAL_FORGE",
      version: "1.0",
      chainId: profileConfig.chainId,
      revision: "1",
    },
  });
};
