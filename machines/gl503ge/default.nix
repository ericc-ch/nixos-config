{ pkgs, ... }:

let
  t3Update = pkgs.writeShellApplication {
    name = "t3-update";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      libnotify
      procps
      systemd
    ];
    text = ''
      t3="${pkgs.t3}/bin/t3"
      service="t3.service"
      url="http://127.0.0.1:3773/"

      notify() {
        notify-send -a "T3 update" "$1" "$2" 2>/dev/null || true
      }

      if ! curl -sS -m 10 -o /dev/null -I https://github.com/; then
        echo "github unreachable; skipping t3 update"
        exit 0
      fi

      if ! "$t3" update --channel nightly -y; then
        notify "T3 update failed" "t3 update exited non-zero; see journalctl --user -u t3-update"
        exit 1
      fi

      version="$("$t3" --version)"
      installed="''${version##* }"
      installed="''${installed#v}"

      main_pid="$(systemctl --user show -p MainPID --value "$service")"
      running=""
      if [ -n "$main_pid" ] && [ "$main_pid" != "0" ]; then
        cmdline="$(ps -o args= -p "$main_pid" 2>/dev/null || true)"
        case "$cmdline" in
          */runtime/versions/*)
            running="''${cmdline#*/runtime/versions/}"
            running="''${running%%/*}"
            ;;
        esac
      fi

      if [ "$installed" = "$running" ]; then
        echo "t3 $installed is already running"
        exit 0
      fi

      if ! systemctl --user restart "$service"; then
        notify "T3 restart failed" "''${running:-unknown} -> $installed; see journalctl --user -u t3"
        exit 1
      fi

      for _ in {1..90}; do
        if curl -fsS -m 2 -o /dev/null "$url"; then
          echo "t3 updated: ''${running:-unknown} -> $installed"
          exit 0
        fi
        sleep 1
      done

      notify "T3 update failed" "t3.service did not answer on $url after ''${running:-unknown} -> $installed; see journalctl --user -u t3"
      exit 1
    '';
  };
in
{
  imports = [ ./hardware.nix ];

  networking.hostName = "gl503ge";

  security.pki.certificateFiles = [
    ./mitmproxy-ca-cert.pem
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      # PyTorch XPU / Level Zero need the loader + IGC at runtime
      level-zero
      intel-graphics-compiler
      vpl-gpu-rt
    ];
  };

  hardware.enableRedistributableFirmware = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    # List form: NixOS joins with ":" (see environment.sessionVariables docs).
    # Same pattern the old hardware.opengl.setLdLibraryPath option used.
    LD_LIBRARY_PATH = [ "/run/opengl-driver/lib" ];
  };

  # relatime, not noatime: mbx decides which build units and store objects
  # nothing has used from access times, so noatime makes it skip that
  # collection. relatime only writes an atime when it is older than the mtime
  # or a day, which is negligible on the SSD.
  fileSystems."/mnt/ssd".options = [
    "nofail"
    "relatime"
  ];
  fileSystems."/mnt/hdd".options = [
    "nofail"
    "noatime"
  ];

  # zswap needs a real swap device for slots and cold-page writeback.
  # Keep this in default.nix, not hardware.nix (regenerable).
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # MiB
    }
  ];

  # Load lz4 early in initrd (before zswap tries to use it)
  # See: https://discourse.nixos.org/t/lz4-zswap-compression-type-not-loaded-at-boot/64684
  boot.initrd.kernelModules = [ "lz4" ];

  # See: https://wiki.nixos.org/wiki/Swap#Zswap_swap_cache
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=lz4"
    "zswap.max_pool_percent=25" # ~8GB max for 32GB RAM
    "zswap.shrinker_enabled=1"
  ];

  services.xserver.videoDrivers = [ "modesetting" ];
  services.pipewire.alsa.support32Bit = true;
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };

  # Tailscale Serve routes for the user services declared below:
  #   :3773 -> 127.0.0.1:3773 (T3 Code)
  #   :4096 -> 127.0.0.1:4096 (OpenCode)
  systemd.services.tailscale-serve-routes = {
    description = "Tailscale Serve routes for T3 Code and OpenCode";
    after = [ "tailscaled.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.tailscale}/bin/tailscale serve --https=3773 --bg http://127.0.0.1:3773"
        "${pkgs.tailscale}/bin/tailscale serve --https=4096 --bg http://127.0.0.1:4096"
      ];
    };
    wantedBy = [ "multi-user.target" ];
  };

  services.sunshine = {
    enable = false;
    openFirewall = true;
    capSysAdmin = true;
  };

  home-manager.users.erickc = { config, ... }: {
    imports = [ ../../home/shared.nix ];

    # Keep cargo builds off the small root partition. gl503ge-only: /mnt/ssd
    # does not exist on the other machines. Same out-of-store link as
    # home/shared.nix's `link` helper, so the file stays editable in the repo.
    home.file.".cargo/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/.cargo/config.toml";

    # mbx keeps its store and managed targets on /mnt/ssd (cache_dir here).
    home.file.".config/mbx/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/.config/mbx/config.toml";

    # T3 Code server. Tailscale Serve route is published by
    # systemd.services.tailscale-serve-routes in this file.
    systemd.user.services.t3 = {
      Unit = {
        Description = "T3 Code server";
        StartLimitIntervalSec = 300;
        StartLimitBurst = 5;
      };
      Service = {
        WorkingDirectory = "%h";
        Environment = [
          "T3CODE_HOME=${config.home.homeDirectory}/.t3"
          "T3CODE_HOST=127.0.0.1"
          "T3CODE_PORT=3773"
        ];
        ExecStart = "${pkgs.t3}/bin/t3 serve";
        Restart = "always";
        RestartSec = "5s";
      };
      Install.WantedBy = [ "default.target" ];
    };

    systemd.user.services.t3-update = {
      Unit.Description = "Update T3 Code nightly and restart the server";
      Service = {
        Type = "oneshot";
        Environment = [
          "T3CODE_HOME=${config.home.homeDirectory}/.t3"
          "DBUS_SESSION_BUS_ADDRESS=unix:path=%t/bus"
        ];
        ExecStart = "${t3Update}/bin/t3-update";
        TimeoutStartSec = "20min";
      };
    };

    systemd.user.timers.t3-update = {
      Unit.Description = "Daily T3 Code nightly update";
      Timer.OnCalendar = "*-*-* 05:00:00";
      Install.WantedBy = [ "timers.target" ];
    };

    # OpenCode API server. Uses the same service.json (loopback :4096 +
    # password) that the desktop app and phone client already use.
    systemd.user.services.opencode-serve = {
      Unit.Description = "OpenCode API server";
      Service = {
        ExecStart = "%h/.local/share/mise/shims/opencode serve --service";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      Install.WantedBy = [ "default.target" ];
    };

    home.packages = with pkgs; [
      krita
      google-chrome-dev
      firefox-bin
      librewolf-bin
    ];
  };
}
