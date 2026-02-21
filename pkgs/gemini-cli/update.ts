#!/usr/bin/env -S deno run --allow-net --allow-write

import { updatePackage } from "../lib/update.ts";

await updatePackage({
  repo: "google-gemini/gemini-cli",
  getAssetName: () => `gemini.js`,
  getVersion: async () => {
    const res = await fetch(
      "https://registry.npmjs.org/@google/gemini-cli/latest",
    );
    const data = await res.json();
    return data.version;
  },
  metadataFile: new URL("./metadata.json", import.meta.url),
});
