import * as encoding from "@std/encoding";
import { pipe } from "effect";

interface ReleaseAsset {
  name: string;
  digest?: string;
}

interface Release {
  tag_name: string;
  assets: ReleaseAsset[];
}

export interface UpdateConfig {
  repo: string;
  release?: string;
  getAssetName: (version: string) => string | Promise<string>;
  getVersion: (tag: string) => string | Promise<string>;
  metadataFile: URL;
}

export async function updatePackage(config: UpdateConfig): Promise<void> {
  const release = config.release ?? "latest";

  const res = await fetch(`https://api.github.com/repos/${config.repo}/releases/${release}`);
  if (!res.ok) throw new Error(`GitHub API error: ${res.status}`);

  const response: Release = await res.json();
  const version = await config.getVersion(response.tag_name);

  const assetName = await config.getAssetName(version);
  const asset = response.assets.find((a) => a.name === assetName);
  if (!asset?.digest) {
    throw new Error(`Asset ${assetName} not found or missing digest`);
  }

  const [method, hash] = asset.digest.split(":");

  const base64 = pipe(encoding.decodeHex(hash), (decoded) => encoding.encodeBase64(decoded));
  const finalHash = `${method}-${base64}`;

  const hashResult = {
    version,
    hash: finalHash,
  };

  console.log(config.repo, version);

  await Deno.writeTextFile(config.metadataFile, JSON.stringify(hashResult, null, 2) + "\n");
}
