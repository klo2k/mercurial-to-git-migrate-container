#!/bin/bash

set -eu

# Check if container is running - exit with error message if not
docker ps --filter name=mercurial_to_git_migrate --format '{{.Names}}'|grep mercurial_to_git_migrate > /dev/null|| \
  (echo "ERROR: mercurial_to_git_migrate container must be running - start with 'run-hg-git-migrationdebug-app.sh'" && exit 1)

# Get an interactive bash shell into the "mystudyplan_debug" container (must be running)
docker exec -it mercurial_to_git_migrate bash
