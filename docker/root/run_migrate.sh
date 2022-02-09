#!/bin/bash

# Abort on error, echo commands are they are run
set -ex

# Ensure all required parameters are present - exit if not
if [[ \
        "${DEVELOPMENT_MODE}" == "" || \
        "${GIT_MAIN_BRANCH}" == "" || \
        "${GIT_PUSH_TO_REMOTE}" == "" || \
        "${GIT_REPO_URL}" == "" || \
        "${HG_REPO_URL}" == "" || \
        "${SSH_KNOWN_HOSTS}" == ""
    ]]; then
    cat <<EOT
ERROR: A required variable is missing - check "docker-compose.yml":
- DEVELOPMENT_MODE: ${DEVELOPMENT_MODE:=** MISSING **}
- GIT_MAIN_BRANCH: ${GIT_MAIN_BRANCH:=** MISSING **}
- GIT_PUSH_TO_REMOTE: ${GIT_PUSH_TO_REMOTE:=** MISSING **}
- GIT_REPO_URL: ${GIT_REPO_URL:=** MISSING **}
- HG_REPO_URL: ${HG_REPO_URL:=** MISSING **}
- SSH_KNOWN_HOSTS: ${SSH_KNOWN_HOSTS:=** MISSING **}
EOT
    exit 1
fi

# Ensure SSH keys are present - exit if not
if [[ ! -f /run/secrets/ssh_id || ! -f /run/secrets/ssh_id_pub ]]; then
    echo 'ERROR: SSH private or public key is missing - check "secrets" in docker-compose.yml'
    exit 1
fi

# Abort on error / empty variable
set -eu

# Setup SSH configs
# Copy provided SSH key for use in container
cp --verbose "/run/secrets/ssh_id" /root/.ssh/id
cp --verbose "/run/secrets/ssh_id_pub" /root/.ssh/id.pub
chmod 600 /root/.ssh/id /root/.ssh/id.pub
# Setup SSH known_hosts
echo "${SSH_KNOWN_HOSTS}" > /root/.ssh/known_hosts

# Set mercurial configs
echo "${HG_CONFIGS}" > /root/.hgrc

# If developer mode, stop execution (so we can jump into container and develop)
if [ "${DEVELOPMENT_MODE}" == "1" ]; then
    cat <<EOT
INFO: Running in development mode.
INFO: Now get shell into container with "bash_shell-hg-git-migration.sh" script
INFO: Ctrl+C to exit
EOT
    tail -f /dev/null
    exit 0
fi




# Clone hg remote
hg clone "${HG_REPO_URL}" /tmp/hg-repo

# Init local git repo
mkdir /tmp/git-repo
cd /tmp/git-repo
git init

# Convert hg to git repo
/opt/hg-fast-export/hg-fast-export.sh -r /tmp/hg-repo
git checkout HEAD
# Set git default branch name
git branch --move "${GIT_MAIN_BRANCH}"

# Add git remote
git remote add origin "${GIT_REPO_URL}"

# Push to git remote if enabled
if [ "${GIT_PUSH_TO_REMOTE}" == "1" ]; then
    # Push everything
    git push --all --force --set-upstream origin

    # Echo success message
    cat <<EOT
SUCCESS: Migration complete!
INFO: You may clone with "git clone ${GIT_REPO_URL}"
EOT
fi
