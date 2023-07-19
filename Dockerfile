FROM docker.io/curlimages/curl:latest AS build
ARG ARCH='dpkg --print-architecture'
RUN curl -Lo koreader.deb \
    https://github.com/koreader/koreader/releases/download/v2023.06.1/koreader-2023.06.1-${ARCH}.deb
FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm AS app
ENV \
    TITLE="Koreader" \
    START_DOCKER=false
COPY --from=build /home/curl_user/koreader.deb /koreader.deb
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
    # Set application to fullscreen
    && sed -i 's|</applications>|  <application class="*">\n <fullscreen>yes</fullscreen>\n </application>\n</applications>|' /etc/xdg/openbox/rc.xml
COPY /root /
EXPOSE 3000
