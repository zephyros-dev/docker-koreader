FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm@sha256:fbdd2964ec128a2956856f3775ab652ff89da96422858bf156a3c5d7094f5a50
ARG ARCH='dpkg --print-architecture'
ARG KOREADER_VERSION=v2024.03.1
ARG KOREADER_VERSION_CONVERT="echo $KOREADER_VERSION | sed 's/v//'"
ENV \
    TITLE="Koreader" \
    START_DOCKER=false
RUN export KOREADER_VERSION=$(eval ${KOREADER_VERSION_CONVERT}) \
    && export ARCH=$(eval ${ARCH}) \
    && curl -Lo koreader.deb \
    https://github.com/koreader/koreader/releases/download/v${KOREADER_VERSION}/koreader-${KOREADER_VERSION}-${ARCH}.deb
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update \
    && apt install -y \
    # For network connectivity
    iputils-ping \
    # For dealing with SDL logs complaint in koreader
    libsdl2-dev \
    && apt install -y -f ./koreader.deb \
    && rm -r koreader.deb \
    # Set application to fullscreen
    && sed -i 's|</applications>|  <application class="*">\n <fullscreen>yes</fullscreen>\n </application>\n</applications>|' /etc/xdg/openbox/rc.xml
COPY /root /
EXPOSE 3000
