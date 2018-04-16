#!/bin/sh

main() {
  if [ -n "$1" ]; then
    TAG="$1" build
  else
    TAGS="$(find . -name Dockerfile -exec dirname {} \;)"

    for TAG in ${TAGS}; do
      TAG="$(echo ${TAG} | sed -e "s/\\.\\///")"

      build "${TAG}" || return 1
    done
  fi
}

build() {
  TAG=${1:-${TAG}}

  echo
  echo "Building ${TAG}.."
  echo
  docker build -t "ntweb-${TAG}" "${TAG}" || return 1

  case ${TAG} in
    dns )
      docker run --rm "ntweb-${TAG}" named-checkconf -z || return 1
      ;;
  esac

  if docker service ls | grep -q "ntweb-intranet_${TAG}"; then
    docker service update --force "ntweb-intranet_${TAG}" || return 1
  fi

  echo
  echo "Done (${TAG})"
}

main $@
