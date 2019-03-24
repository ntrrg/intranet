#!/bin/sh

set -e

# shellcheck disable=SC1091
. ./config.env

main() {
  genCerts @ www blog
  genCerts home ci docker git mirrors registry s6 status storage
  genCerts test

  docker run --rm \
    ntrrg/htpasswd -bB "$IN_USER" "$IN_PASSWORD" > "$IN_ROOT/etc/htpasswd"
}

genCerts() {
  SUBDOMAINS=""

  # shellcheck disable=SC2068
  for SUBDOMAIN in $@; do
    if [ "$SUBDOMAIN" = "@" ]; then
      SUBDOMAIN=""
    else
      SUBDOMAIN="$SUBDOMAIN."
    fi

    SUBDOMAINS="$SUBDOMAINS -d $SUBDOMAIN$IN_DOMAIN"
  done

  # shellcheck disable=SC2086
  docker run --rm -it \
    -p 80:80 -p 443:443 \
    -v "$IN_ROOT/etc/letsencrypt":/etc/letsencrypt \
    certbot/certbot certonly --standalone --expand \
      -nm "$IN_EMAIL" --agree-tos \
      $SUBDOMAINS
}

# shellcheck disable=SC2068
main $@

