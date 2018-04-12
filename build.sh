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

    rproxy )
      docker run --rm "ntweb-${TAG}" nginx -t || return 1
      ;;
  esac

  echo
  echo "Done (${TAG})"
}

main $@
