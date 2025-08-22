FROM docker.io/curlimages/curl:8.15.0@sha256:4026b29997dc7c823b51c164b71e2b51e0fd95cce4601f78202c513d97da2922 AS curl
ARG ARCH='uname -m'
ARG KOREADER_VERSION=v2025.08
RUN \
    export ARCH=$(eval ${ARCH}) \
    && curl -Lo koreader.tar.xz \
    https://github.com/koreader/koreader/releases/download/${KOREADER_VERSION}/koreader-linux-${ARCH}-${KOREADER_VERSION}.tar.xz \
    && tar -xf koreader.tar.xz

FROM ghcr.io/linuxserver/baseimage-selkies:fedora42@sha256:84bfa6ba8b5a5a2344573027d24d64ab62b12616f73bf85cb4cb9f0d214c1d0f AS fedora
ENV \
    TITLE="Koreader" \
    START_DOCKER=false \
    NO_GAMEPAD=true
RUN --mount=type=cache,target=/var/cache/libdnf5,sharing=locked \
    dnf install -y \
    iputils \
    && sed -i 's|</applications>|  <application class="*">\n <fullscreen>yes</fullscreen>\n </application>\n</applications>|' /etc/xdg/openbox/rc.xml \
    && echo koreader > /defaults/autostart
COPY --from=curl /home/curl_user/bin/koreader /usr/bin/koreader
COPY --from=curl /home/curl_user/lib/koreader /usr/lib/koreader
COPY --from=curl /home/curl_user/share/pixmaps/koreader.png /usr/share/selkies/www/icon.png
EXPOSE 3000

FROM ghcr.io/linuxserver/baseimage-selkies:debianbookworm@sha256:a3dd03e3b194b2cbd02a72d61a60343824a9ecae039f58e59ed478156d202846 AS debian
ENV \
    TITLE="Koreader" \
    START_DOCKER=false \
    NO_GAMEPAD=true
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update \
    && apt install -y \
    # For network connectivity
    iputils-ping \
    libsdl2-2.0-0 \
    # Set application to fullscreen
    && sed -i 's|</applications>|  <application class="*">\n <fullscreen>yes</fullscreen>\n </application>\n</applications>|' /etc/xdg/openbox/rc.xml \
    && echo koreader > /defaults/autostart
COPY --from=curl /home/curl_user/bin/koreader /usr/bin/koreader
COPY --from=curl /home/curl_user/lib/koreader /usr/lib/koreader
COPY --from=curl /home/curl_user/share/pixmaps/koreader.png /usr/share/selkies/www/icon.png
EXPOSE 3000
