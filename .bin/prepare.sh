#!/bin/sh

SERVER=${SERVER:-/}

echo
echo "Getting/updating the required images.."
echo

.bin/build.sh && .bin/pull.sh

echo
echo "Assigning labels.."
echo

.bin/labels.sh

echo
echo "Creating server structure.."
echo

mkdir -p \
  "${SERVER}/srv/docker-registry" \
  "${SERVER}/srv/drone" \
  "${SERVER}/srv/gogs" \
  "${SERVER}/srv/mirrors" \
  "${SERVER}/srv/registry" \
  "${SERVER}/srv/storage"

echo
echo "Generating secrets.."
echo

CERTS_ROOT="${SERVER}/etc/letsencrypt"
mkdir -p "${CERTS_ROOT}"
.bin/certs.sh "${CERTS_ROOT}"

if [ ! -f "${SERVER}/etc/htpasswd" ]; then
  docker run --rm \
    --entrypoint htpasswd \
  registry:2 -bnB ntrrg 1234 \
    > "${SERVER}/etc/htpasswd"
fi

