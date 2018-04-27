#!/bin/sh

main() {
  if [ -n "$1" ]; then
    IMG="$1" build
  else
    IMAGES="$(find . -name Dockerfile -exec dirname {} \;)"

    for IMG in ${IMAGES}; do
      IMG="$(echo ${IMG} | sed -e "s/\.\///")"

      build "${IMG}" || return 1
    done
  fi
}

build() {
  IMG=${1:-${IMG}}
  cd "${IMG}"
  IMG="$(basename "${IMG}")"

  echo
  echo "Building ${IMG}.."
  echo
  docker build -t "ntweb/intranet:${IMG}" . || return 1

  case ${IMG} in
    dns )
      docker run --rm "ntweb/intranet:${IMG}" named-checkconf -z || return 1
      ;;
  esac

  if docker service ls 2> /dev/null | grep -q "ntweb-intranet_${IMG}"; then
    docker service update --force "ntweb-intranet_${IMG}" || return 1
  fi

  echo
  echo "Done (${IMG})"
  cd -
}

main $@

