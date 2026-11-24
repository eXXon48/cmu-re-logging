#!/bin/sh
# cmu-re-logging: bind-mounts the package's rendered settings.txt over the stock
# /config/common/log/settings.txt for this boot, so every JCI process started after this hook
# reads the chosen COMMON_LOG_LEVEL. Nothing on the rootfs changes; uninstall + reboot = stock.
P=/data_persist/cmu-re/pkg/cmu-re-logging
S=/config/common/log/settings.txt
[ -f "$P/settings.txt" ] && [ -f "$S" ] || exit 0
mount -o bind "$P/settings.txt" "$S"
