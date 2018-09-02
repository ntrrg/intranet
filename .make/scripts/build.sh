#!/bin/sh

set -e

main() {
  if [ -n "$1" ]; then
    build "$1"
  else
    FILES="$(find . -name "*Dockerfile")"

    for FILE in $FILES; do
      FILE="$(echo "$FILE" | sed -e "s/\\.\\///")"
      build "$FILE"
    done
  fi
}

build() {
  FILE="$1"
  CTX="$(dirname "$FILE")"
  IMAGE="$(basename "$CTX")"

  docker build -t "intranet-$IMAGE" -f "$FILE" "$CTX"

  case "$IMAGE" in
    dns )
      docker run --rm intranet-dns named-checkconf -z
      ;;
  esac

  if docker service ls 2> /dev/null | grep -q "intranet_$IMAGE"; then
    docker service update --force "intranet_$IMAGE"
  fi
}

# shellcheck disable=SC2068
main $@

