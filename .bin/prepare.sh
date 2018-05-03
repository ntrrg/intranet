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
  "${SERVER}/srv/registry" \
  "${SERVER}/srv/storage"

echo
echo "Generating secrets.."
echo

mkdir -p "${SERVER}/etc/letsencrypt"

docker run --rm -it -p 80:80 -p 443:443 \
  -v "${SERVER}/etc/letsencrypt":/etc/letsencrypt \
certbot/certbot certonly --standalone --expand \
  -nm ntrrgx@gmail.com --agree-tos \
  -d nt.web.ve \
  -d blog.nt.web.ve \
  -d ci.nt.web.ve \
  -d docker.nt.web.ve \
  -d git.nt.web.ve \
  -d mirrors.nt.web.ve \
  -d registry.nt.web.ve \
  -d status.nt.web.ve \
  -d storage.nt.web.ve \
  -d www.nt.web.ve

if [ ! -f "${SERVER}/etc/htpasswd" ]; then
  docker run --rm \
    --entrypoint htpasswd \
  registry:2 -bnB ntrrg 1234 \
    > "${SERVER}/etc/htpasswd"
fi

