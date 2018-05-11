#!/bin/sh

NODE="$(hostname)"

if [ "$1" = "-n" -o "$1" = "--node" ]; then
  NODE=$2
  shift; shift
fi

case $1 in
  list | ls | l )
    docker node inspect --pretty "${NODE}" | grep "^ -"
    ;;

  add | a )
    docker node update --label-add "$2" "${NODE}"
    ;;

  rm | r )
    docker node update --label-rm "$2" "${NODE}"
    ;;

  * )
    docker node update \
      --label-add service-ci-builder=true \
      --label-add service-ci-server=true \
      --label-add service-git=true \
      --label-add service-mirrors=true \
      --label-add service-registry=true \
      --label-add service-docker-registry=true \
      --label-add service-site=true \
    "${NODE}"
    ;;
esac 

