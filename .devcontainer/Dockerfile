FROM mcr.microsoft.com/devcontainers/python:3.13-bookworm@sha256:11690b54090a0a649321728d5f278288b3bab1b45c37218a715ee63f5716e546

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update \
    && apt install -y --no-install-recommends \
    fish \
    podman \
    podman-docker \
    docker-compose

ARG USERNAME
ARG UID=1000

USER ${USERNAME}
RUN mkdir -p \
    ~/.cache/pip \
    ~/.local/share/fish \
    ~/.ssh

COPY --chown=${USERNAME}:${USERNAME} requirements.txt .
RUN \
    --mount=type=cache,uid=${UID},target=/home/${USERNAME}/.cache/pip \
    pip install \
    --no-warn-script-location \
    --requirement requirements.txt \
    --user
