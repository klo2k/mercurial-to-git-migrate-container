#!/bin/bash

# Run as development mode if 1st paramter == 'development'
if [ "$1" == 'development' ]; then
    export DEVELOPMENT_MODE=1
fi

# Exit on error (e), error on undefined variable (u), show command to debug (x)
set -eux

# Go to directory of this script
cd "$(dirname $0)"

# Build image
docker build \
    --tag "klo2k/mercurial-to-git-migrate:latest" \
    .

# Start app
docker-compose up --force-recreate --remove-orphans
