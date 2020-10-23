#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Docker Build Container
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni (@zeroc0d3)
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

export IMAGE="zeroc0d3labdevops/mariadb"
export TAG="10.4.12"

echo " Build Image => $IMAGE:$TAG"
docker build . -t $IMAGE:$TAG