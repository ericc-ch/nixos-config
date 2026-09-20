{
  lib,
  scrcpy,
  writeShellScriptBin,
}:

# Streams the phone camera over ADB (scrcpy) into the v4l2loopback device
# that shows up in app camera lists as "HD WebCam".
#
# Uses the main back camera (id 0) with continuous autofocus, which focuses
# much closer than a cheap fixed-focus USB camera.
#
# Override defaults with PHONECAM_CAMERA_ID, PHONECAM_DEVICE, PHONECAM_SIZE,
# PHONECAM_FPS, PHONECAM_SERIAL (adb serial, e.g. 100.100.1.20:5555 when the
# phone is reached over Tailscale). Extra scrcpy flags pass through:
#   phonecam --camera-zoom=2
#   phonecam --v4l2-buffer=200     # smooth jittery wireless links
writeShellScriptBin "phonecam" ''
  sink="''${PHONECAM_DEVICE:-/dev/video3}"
  if [ ! -e "$sink" ]; then
    echo "phonecam: $sink missing (load v4l2loopback: sudo modprobe v4l2loopback)" >&2
    exit 1
  fi

  if [ -n "''${PHONECAM_SERIAL:-}" ]; then
    set -- --serial="''${PHONECAM_SERIAL}" "$@"
  fi

  exec ${scrcpy}/bin/scrcpy \
    --video-source=camera \
    --camera-id="''${PHONECAM_CAMERA_ID:-0}" \
    --camera-size="''${PHONECAM_SIZE:-1920x1080}" \
    --camera-fps="''${PHONECAM_FPS:-30}" \
    --v4l2-sink="$sink" \
    --stay-awake \
    --no-window \
    --no-audio \
    "$@"
''
// {
  meta = with lib; {
    description = "Use the Android phone camera as a webcam";
    platforms = [ "x86_64-linux" ];
    mainProgram = "phonecam";
  };
}
