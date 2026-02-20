#!/usr/bin/env -S deno run --allow-net --allow-write

import { updatePackage } from "../lib/update.ts";

await updatePackage({
  repo: "imputnet/helium-linux",
  getAssetName: (version) => `helium-${version}-x86_64.AppImage`,
  getVersion: (tag) => tag,
  metadataFile: new URL("./metadata.json", import.meta.url),
});
