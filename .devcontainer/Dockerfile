FROM mcr.microsoft.com/devcontainers/go:1.21-bookworm@sha256:4e6efe76688c0a3a35dc7c3f74492a3bb72f54a403de4d97fdebd26ec339064c

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update \
    && apt install -y --no-install-recommends \
    fish \
    pipx

ARG USERNAME
ARG UID=1000

USER ${USERNAME}
RUN mkdir -p \
    ~/.cache/pip \
    ~/.config/sops/age \
    ~/.local/share/aquaproj-aqua/bin \
    ~/.local/share/aquaproj-aqua/pkgs \
    ~/.local/share/aquaproj-aqua/registries \
    ~/.local/share/fish \
    ~/.ssh

ENV AQUA_VERSION=v2.17.0
ENV PATH=/home/${USERNAME}/.local/share/aquaproj-aqua/bin:/home/${USERNAME}/node_modules/.bin:$PATH
