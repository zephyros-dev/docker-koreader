FROM docker.io/curlimages/curl:8.13.0@sha256:d43bdb28bae0be0998f3be83199bfb2b81e0a30b034b6d7586ce7e05de34c3fd AS curl
ARG ARCH='uname -m'
ARG KOREADER_VERSION=v2025.04
RUN \
    export ARCH=$(eval ${ARCH}) \
    && curl -Lo koreader.tar.xz \
    https://github.com/koreader/koreader/releases/download/${KOREADER_VERSION}/koreader-linux-${ARCH}-${KOREADER_VERSION}.tar.xz \
    && tar -xf koreader.tar.xz

FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm@sha256:95f38d7a3e4b3fff3ceffca10029b5f227c26c49e2ad9d6d9ea0cf1abb93f8f4 AS base
ENV \
    TITLE="Koreader" \
    START_DOCKER=false
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update \
    && apt install -y \
    # For network connectivity
    iputils-ping \
    libsdl2-dev \
    # Set application to fullscreen
    && sed -i 's|</applications>|  <application class="*">\n <fullscreen>yes</fullscreen>\n </application>\n</applications>|' /etc/xdg/openbox/rc.xml
COPY --from=curl /home/curl_user/bin/koreader /usr/bin/koreader
COPY --from=curl /home/curl_user/lib/koreader /usr/lib/koreader
COPY --from=curl /home/curl_user/share/pixmaps/koreader.png /kclient/public/favicon.ico
RUN mkdir -p /root/defaults/ && echo koreader > /root/defaults/autostart
EXPOSE 3000
