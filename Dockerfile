FROM ubuntu:focal

LABEL org.opencontainers.image.revision="-"
LABEL org.opencontainers.image.source="https://github.com/klo2k/mercurial-to-git-migrate-container"

RUN \
    apt update && \
    apt install -y git mercurial && \
    apt clean

RUN \
    git config --global user.name 'hg-git-migrate' && \
    git config --global user.email '-' && \
    git config --global core.autocrlf false

RUN git clone --depth 1 --branch v210917 https://github.com/frej/fast-export.git /opt/hg-fast-export

# Add files into image
ADD docker/root/ /root/

# If set halt execution so we can get shell into container to develop with
ENV DEVELOPMENT_MODE="0"
# Main branch to push to git repo (e.g. "main" / "master")
ENV GIT_MAIN_BRANCH=""
# Push to git repo - set to 1 to push to remote repo, 0 to allow preview result
ENV GIT_PUSH_TO_REMOTE="0"
# Git SSH repository URL
# e.g. git@github.com:klo2k/mercurial-to-git-migrate-container.git
ENV GIT_REPO_URL=""
# Custom mercurial configs to go into ~/.hgrc
ENV HG_CONFIGS=""
# Mercurial repository URL, with username + password
# e.g. http://[username]:[passord]@hg.example.com/example-project/
ENV HG_REPO_URL=""
# SSH known hosts - will go into container's ~/.ssh/known_hosts
ENV SSH_KNOWN_HOSTS=""

WORKDIR /root
CMD ["/root/run_migrate.sh"]
