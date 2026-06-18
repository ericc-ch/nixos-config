#!/usr/bin/env -S deno run --allow-net --allow-write

import { updatePackage } from "../lib/update.ts";

await updatePackage({
  repo: "ggml-org/llama.cpp",
  getAssetName: (version) => `llama-${version}-bin-ubuntu-vulkan-x64.tar.gz`,
  getVersion: (tag) => tag,
  metadataFile: new URL("./metadata.json", import.meta.url),
});
