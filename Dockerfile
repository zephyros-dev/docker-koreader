FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm@sha256:4e0b31ff203f6d28a9bfff98f215f4e5c3a22f393f13bf19a4810f62417d5ba0
ARG KOREADER_VERSION="2023.06.1"
ARG ARCH='dpkg --print-architecture'
ENV \
    TITLE="Koreader" \
    START_DOCKER=false
RUN curl -Lo koreader.deb \
    https://github.com/koreader/koreader/releases/download/v${KOREADER_VERSION}/koreader-${KOREADER_VERSION}-$(eval ${ARCH}).deb
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
