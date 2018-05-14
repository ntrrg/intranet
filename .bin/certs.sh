#!/bin/sh

DOMAIN="nt.web.ve"
ADMIN="ntrrgx@gmail.com"

main() {
  ROOT="$1"

  mkdir -p "${ROOT}"

  echo "Requesting certificates.."

  if [ -n "$2" ]; then
    _$2
    return $?
  fi

  _home || return $?
  _site || return $?
  _test || return $?
}

certbot() {
  local subdomains=""
  local sub=""

  for sub in $@; do
    if [ "${sub}" = "@" ]; then
      sub=""
    else
      sub="${sub}."
    fi
  
    subdomains="$subdomains -d ${sub}${DOMAIN}"
  done
  
  echo "  Subdomains: ${subdomains}"

  docker run --rm -it \
    -p 80:80 -p 443:443 \
    -v "${ROOT}":/etc/letsencrypt \
  certbot/certbot certonly --standalone --expand \
    -nm "${ADMIN}" --agree-tos \
    ${subdomains}

  return $?
}

# Services

_home() {
  certbot home ci docker git mirrors registry status storage

  return $?
}

_site() {
  certbot @ blog www

  return $?
}

_test() {
  certbot test

  return $?
}

main $@

