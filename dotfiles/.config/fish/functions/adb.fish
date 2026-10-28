function adb --description 'adb with auto-connect to this phone over wireless debugging'
    set -l passthrough pair connect disconnect kill-server start-server version devices mdns help
    if not contains -- $argv[1] $passthrough
        if command -q adbw; and not command adb devices | string match -qr '^\S+\s+device$'
            command adbw >/dev/null 2>&1
        end
    end
    command adb $argv
end
