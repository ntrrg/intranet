#!/bin/sh

set -e

PACKAGE="shellcheck-v$RELEASE.linux.x86_64.tar.xz"

wget -cO "/tmp/$PACKAGE" "https://shellcheck.storage.googleapis.com/$PACKAGE"
tar -xJf "/tmp/$PACKAGE" -C /tmp/
cp -f "/tmp/shellcheck-v$RELEASE/shellcheck" "$DEST"
chmod +x "$DEST"

