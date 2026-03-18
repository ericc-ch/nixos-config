import * as encoding from "@std/encoding";

interface NpmPackageMetadata {
  version: string;
  dist: {
    tarball: string;
    shasum: string;
    integrity?: string;
  };
}

interface NpmPackageIndex {
  "dist-tags": {
    latest: string;
  };
  versions: Record<string, NpmPackageMetadata>;
}

export interface NpmUpdateConfig {
  packageName: string;
  registry?: string;
  metadataFile: URL;
  getPlatformAssetName: (version: string, platform: NpmPlatform) => string | Promise<string>;
  platforms?: NpmPlatform[];
}

export type NpmPlatform =
  | "darwin-x64"
  | "darwin-arm64"
  | "linux-x64-gnu"
  | "linux-arm64-gnu"
  | "win32-x64-msvc";

const DEFAULT_PLATFORMS: NpmPlatform[] = [
  "darwin-x64",
  "darwin-arm64",
  "linux-x64-gnu",
  "linux-arm64-gnu",
  "win32-x64-msvc",
];

export async function fetchLatestVersion(
  packageName: string,
  registry = "https://registry.npmjs.org",
): Promise<string> {
  const res = await fetch(`${registry}/${packageName}/latest`);
  if (!res.ok) {
    throw new Error(`npm registry error: ${res.status} ${res.statusText}`);
  }
  const metadata: NpmPackageMetadata = await res.json();
  return metadata.version;
}

async function computeSriHash(url: string): Promise<string> {
  const res = await fetch(url);
  if (!res.ok) {
    throw new Error(`Failed to fetch ${url}: ${res.status}`);
  }
  const data = await res.arrayBuffer();
  const hashBuffer = await crypto.subtle.digest("SHA-256", data);
  const hashBase64 = encoding.encodeBase64(hashBuffer);
  return `sha256-${hashBase64}`;
}

export interface NpmPackageMetadataResult {
  version: string;
  platforms: Record<NpmPlatform, { hash: string; url: string }>;
}

export async function updateNpmPackage(
  config: NpmUpdateConfig,
): Promise<NpmPackageMetadataResult> {
  const registry = config.registry ?? "https://registry.npmjs.org";
  const platforms = config.platforms ?? DEFAULT_PLATFORMS;

  const version = await fetchLatestVersion(config.packageName, registry);
  console.log(`${config.packageName} ${version}`);

  const platformResults: Record<string, { hash: string; url: string }> = {};

  for (const platform of platforms) {
    const assetName = await config.getPlatformAssetName(version, platform);
    const url = `${registry}/${assetName}/-/vite-plus-cli-${platform}-${version}.tgz`;
    console.log(`  Fetching ${platform}...`);
    const hash = await computeSriHash(url);
    platformResults[platform] = { hash, url };
    console.log(`    ${hash}`);
  }

  const result: NpmPackageMetadataResult = {
    version,
    platforms: platformResults as NpmPackageMetadataResult["platforms"],
  };

  await Deno.writeTextFile(
    config.metadataFile,
    JSON.stringify(result, null, 2) + "\n",
  );

  return result;
}