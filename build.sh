#!/bin/bash
docker build \
    --build-arg USERNAME="$USER" \
    --build-arg HOST_UID="$(id -u)" \
    --build-arg HOST_GID="$(id -g)" \
    -t "dcba-$USER" .
