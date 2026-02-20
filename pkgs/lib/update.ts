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
  getAssetName: (version: string) => string;
  getVersion: (tag: string) => string;
  metadataFile: URL;
}

export async function updatePackage(config: UpdateConfig): Promise<void> {
  const res = await fetch(
    `https://api.github.com/repos/${config.repo}/releases/latest`,
  );
  if (!res.ok) throw new Error(`GitHub API error: ${res.status}`);

  const release: Release = await res.json();
  const version = config.getVersion(release.tag_name);

  const assetName = config.getAssetName(version);
  const asset = release.assets.find((a) => a.name === assetName);
  if (!asset?.digest) {
    throw new Error(`Asset ${assetName} not found or missing digest`);
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

  console.log(config.repo, version);

  await Deno.writeTextFile(
    config.metadataFile,
    JSON.stringify(hashResult, null, 2) + "\n",
  );
}
