FROM mcr.microsoft.com/devcontainers/go:1.22-bookworm@sha256:1ffefcec50ecc5e6322aada65814419a7c826fd51df1f3f1cc8a2db0c57279a5

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

ENV AQUA_VERSION=v2.23.1
ENV PATH=/home/${USERNAME}/.local/share/aquaproj-aqua/bin:/home/${USERNAME}/node_modules/.bin:$PATH
