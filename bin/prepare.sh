#!/bin/sh

set -e

# shellcheck disable=SC1091
. ./config.env

DST="$IN_ROOT/var/server"

main() {
  rm -rf "$DST"
  mkdir "$DST"
  cp -rf services/ docker-swarm.yml "$DST"
  replaceVars
}

escapeRE() {
  # shellcheck disable=SC1117  disable=SC2005
  echo "$(
    echo "$1" |
    sed -re "s/\//\\\\\//g" |
    sed -re "s/(\\\\)?\/$//g"
  )"
}

replaceVars() {
  FILES="$(find "$DST" -type f ! -name Dockerfile)"

  for FILE in $FILES; do
    FILE="$(echo "$FILE" | sed -e "s/\\.\\///")"
    setValue "ROOT"             "$IN_ROOT"             "$FILE"
    setValue "ORG"              "$IN_ORG"              "$FILE"
    setValue "DOMAIN"           "$IN_DOMAIN"           "$FILE"
    setValue "USER"             "$IN_USER"             "$FILE"
    setValue "PASSWORD"         "$IN_PASSWORD"         "$FILE"
    setValue "DNS_ADDR"         "$IN_DNS_ADDR"         "$FILE"
    setValue "DNS_ADDR_INV"     "$IN_DNS_ADDR_INV"     "$FILE"
    setValue "DNS_REVERSE_ZONE" "$IN_DNS_REVERSE_ZONE" "$FILE"
    setValue "DNS_WHITELIST"    "$IN_DNS_WHITELIST"    "$FILE"
    setValue "DNS_SERIAL"       "$IN_DNS_SERIAL"       "$FILE"
    setValue "DRONE_SECRET"     "$IN_DRONE_SECRET"     "$FILE"
    setValue "SITE_IMAGE"       "$IN_SITE_IMAGE"       "$FILE"
  done
}

setValue() {
  KEY="$1"
  VALUE="$2"
  TARGET="${3:-.}"

  # shellcheck disable=SC1117
  sed -re "s/\{\{ $KEY \}\}/$(escapeRE "$VALUE")/g" -i "$TARGET"
}

# shellcheck disable=SC2068
main $@

