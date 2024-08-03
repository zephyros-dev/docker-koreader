FROM docker.io/curlimages/curl:8.9.1@sha256:8addc281f0ea517409209f76832b6ddc2cabc3264feb1ebbec2a2521ffad24e4 as curl
ARG ARCH='uname -m'
ARG KOREADER_VERSION=v2024.07
RUN \
    export ARCH=$(eval ${ARCH}) \
    && curl -Lo koreader.tar.xz \
    https://github.com/koreader/koreader/releases/download/${KOREADER_VERSION}/koreader-linux-${ARCH}-${KOREADER_VERSION}.tar.xz \
    && tar -xf koreader.tar.xz

FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm@sha256:cdecf0f544052c6b57e7f3b487373e6aff81e6e19c4545d65ba48204e8165bd1 as base
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
COPY /root /
EXPOSE 3000
