#!/usr/bin/env bash
# Regenerate generated/ from the protocol XMLs.  Run on a workstation;
# no meson needed — the scanner is two C files + expat:
#
#   cd <wayland-1.23.1 source>
#   sed -e 's/@WAYLAND_VERSION_MAJOR@/1/' -e 's/@WAYLAND_VERSION_MINOR@/23/' \
#       -e 's/@WAYLAND_VERSION_MICRO@/1/' -e 's/@WAYLAND_VERSION@/1.23.1/' \
#       src/wayland-version.h.in > src/wayland-version.h
#   gcc -O2 -o wayland-scanner src/scanner.c src/wayland-util.c -Isrc \
#       -DDEFAULT_DTD_FILE='"/dev/null"' -lexpat
set -euo pipefail
cd "$(dirname "$0")"
SCANNER=${SCANNER:-wayland-scanner}
ANDROID_XML=${ANDROID_XML:-../libhybris/hybris/platforms/common/wayland-android.xml}

$SCANNER server-header    protocol/wayland.xml generated/wayland-server-protocol.h
$SCANNER -c server-header protocol/wayland.xml generated/wayland-server-protocol-core.h
$SCANNER client-header    protocol/wayland.xml generated/wayland-client-protocol.h
$SCANNER -c client-header protocol/wayland.xml generated/wayland-client-protocol-core.h
$SCANNER public-code      protocol/wayland.xml generated/wayland-protocol.c

$SCANNER server-header protocol/xdg-shell.xml generated/xdg-shell-server-protocol.h
$SCANNER client-header protocol/xdg-shell.xml generated/xdg-shell-client-protocol.h
$SCANNER private-code  protocol/xdg-shell.xml generated/xdg-shell-protocol.c

$SCANNER server-header "$ANDROID_XML" generated/wayland-android-server-protocol.h
$SCANNER client-header "$ANDROID_XML" generated/wayland-android-client-protocol.h
$SCANNER private-code  "$ANDROID_XML" generated/wayland-android-protocol.c
