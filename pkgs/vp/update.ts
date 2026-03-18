#!/usr/bin/env -S deno run --allow-net --allow-write
import { updateNpmPackage } from "../lib/update-npm.ts";

const NPM_PACKAGE = "vite-plus";

await updateNpmPackage({
  packageName: NPM_PACKAGE,
  metadataFile: new URL("./metadata.json", import.meta.url),
  getPlatformAssetName: (_version, platform) =>
    `@voidzero-dev/vite-plus-cli-${platform}`,
});