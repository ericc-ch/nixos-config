#!/usr/bin/env -S deno run --allow-net --allow-write

import * as path from "@std/path";
import * as encoding from "@std/encoding";
import { pipe } from "effect";

const HASHES_FILE = path.join(path.dirname(import.meta.url), "metadata.json");
const ASSET_NAME = "opencode-linux-x64.tar.gz";

interface ReleaseAsset {
  name: string;
  digest?: string;
}

interface Release {
  tag_name: string;
  assets: ReleaseAsset[];
}

const res = await fetch(
  "https://api.github.com/repos/anomalyco/opencode/releases/latest",
);
if (!res.ok) throw new Error(`GitHub API error: ${res.status}`);

const release: Release = await res.json();
const version = release.tag_name.replace(/^v/, "");

const asset = release.assets.find((a) => a.name === ASSET_NAME);
if (!asset?.digest) {
  throw new Error(`Asset ${ASSET_NAME} not found or missing digest`);
}

const [method, hash] = asset.digest.split(":");

const base64 = pipe(
  encoding.decodeHex(hash),
  (decoded) => encoding.encodeBase64(decoded),
);
const finalHash = `${method}-${base64}`;

const hashResult = {
  version,
  hash: finalHash,
};

console.log(`Version: ${version}`);

await Deno.writeTextFile(
  HASHES_FILE,
  JSON.stringify(hashResult, null, 2) + "\n",
);
console.log("metadata.json updated");
