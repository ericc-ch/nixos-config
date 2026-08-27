# Swap: zswap vs zram for this fleet

Filed from Chris Down (kernel MM), NixOS Wiki, ArchWiki, and live state on `hp240g5` (2026-08-27).

## Verdict

**Prefer disk swap + zswap. Do not stack zram with disk swap.** Only use zram alone when there is no disk swap on purpose (and then pair it with a userspace OOM daemon).

## Sources

- [Debunking zswap and zram myths](https://chrisdown.name/2026/03/24/zswap-vs-zram-when-to-use-what.html) — Chris Down (kernel MM)
- [NixOS Wiki: Swap](https://wiki.nixos.org/wiki/Swap)
- [ArchWiki: Zswap](https://wiki.archlinux.org/title/Zswap)
- [nixpkgs `boot.zswap` module](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/zswap.nix) (defaults: zstd, maxPoolPercent=25, shrinker on)

## Why zswap wins when you have disk swap

| | zswap | zram-as-swap |
|---|---|---|
| Role | Compressed cache in front of disk swap | Compressed RAM block device |
| When full | Evicts cold pages to disk (LRU + shrinkers) | Hard stop; no automatic eviction |
| With disk swap | Correct: hot in RAM cache, cold on disk | **LRU inversion**: cold pages lock in fast zram; hot pages spill to slow disk |
| Incompressible pages | Can reject → disk | Stores anyway (wastes RAM/CPU) |
| Upstream direction | Preferred; diskless zswap being worked on | Maintainers discouraging further block-layer hacks |

Chris Down’s line: if in doubt, use zswap. zram is for diskless/embedded, or deliberate “nothing private on disk” setups (Fedora) that also run `systemd-oomd`.

NixOS Wiki agrees: pick one — disk swap → zswap; no swap → zram.

## Machine recommendations

### `hp240g5` (this host) — already the right architecture

Live (2026-08-27):

- RAM ~11 GiB
- Swap: `/dev/sda3` 8.8 GiB on SSD (`RESCUE05RM22AR24`, rotational=0)
- zswap: enabled, `lz4`, `max_pool_percent=15`, `zsmalloc`, `shrinker_enabled=Y`
- No zram
- `vm.swappiness=60`, `vm.page-cluster=3` (defaults)

Config lives in `machines/hp240g5/default.nix` (kernel params + early `lz4` in initrd).

**Keep this model.** Optional polish only:

1. **`max_pool_percent`**: 15% ≈ 1.6 GiB is a bit tight for an 11 GiB laptop. Kernel default is 20%; nixpkgs `boot.zswap` defaults to 25% for desktops/Nix builds. **20–25** is a reasonable bump; leave shrinker on so the pool does not sit full of cold pages.
2. **Compressor**: `lz4` is the right call for interactive latency. `zstd` saves more RAM per pool byte at higher CPU cost — fine if you do heavy builds and the CPU can take it.
3. **Do not enable `zramSwap`** alongside this.
4. **SSD discard** on the swap device is optional (`options = [ "discard" ]` or `discard=once` in the swap entry) — wear is not a strong argument against disk-backed swap on modern SSDs (Down: zram can increase *file-cache* I/O under pressure).
5. **Swappiness**: leave at 60 unless you measure a problem; with zswap, early anonymous reclaim is often desirable so cold heap does not crush page cache.

### `gl503ge` — zram-only today

`machines/gl503ge/default.nix` has `zramSwap.enable` at 25% RAM and `hardware.nix` has `swapDevices = [ ]`.

That matches Fedora’s diskless model, **not** Down’s preferred path. If the machine has usable SSD space for a swap partition/file:

1. Add disk swap
2. Enable zswap (same shape as hp240g5)
3. Remove `zramSwap`

If you keep zram-only, enable `systemd.oomd` (or earlyoom). Without a userspace OOM agent, zram’s hard limit can hang reclaim for a long time before the kernel OOM killer fires.

## Suggested hp240g5 knobs (if tuning)

```nix
boot.kernelParams = [
  "zswap.enabled=1"
  "zswap.compressor=lz4"
  "zswap.max_pool_percent=20" # was 15; ~2.2 GiB on 11 GiB RAM
  "zswap.zpool=zsmalloc"
  "zswap.shrinker_enabled=1"
];
```

When available on the channel, prefer `boot.zswap = { ... }` over raw `kernelParams` (nixpkgs module; same knobs, clearer defaults).

## What not to do

- zram + disk swap (priority stacking) → LRU inversion
- zswap + zram → double compression / overlapping roles
- zram alone without oomd on a desktop under real pressure
- Disabling disk swap “to save the SSD” as the main reason to pick zram
