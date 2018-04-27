#!/bin/sh

.bin/build.sh && \
docker pull certbot/certbot && \
docker pull dockersamples/visualizer && \
docker pull drone/agent && \
docker pull drone/cli && \
docker pull drone/drone && \
docker pull gogs/gogs && \
docker pull registry:2

