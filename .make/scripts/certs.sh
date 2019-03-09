#!/bin/sh

SUBDOMAINS=""

# shellcheck disable=SC2068
for SUBDOMAIN in $@; do
  if [ "$SUBDOMAIN" = "@" ]; then
    SUBDOMAIN=""
  else
    SUBDOMAIN="$SUBDOMAIN."
  fi

  SUBDOMAINS="$SUBDOMAINS -d ${SUBDOMAIN}${DOMAIN}"
done

docker run --rm -it \
  -p 80:80 -p 443:443 \
  -v "$ROOT":/etc/letsencrypt \
  certbot/certbot certonly --standalone --expand \
    -nm "$EMAIL" --agree-tos \
    $SUBDOMAINS

