FROM docker.io/curlimages/curl:8.17.0@sha256:935d9100e9ba842cdb060de42472c7ca90cfe9a7c96e4dacb55e79e560b3ff40 AS curl
ARG ARCH='uname -m'
ARG KOREADER_VERSION=v2025.10
RUN \
    export ARCH=$(eval ${ARCH}) \
    && curl -Lo koreader.tar.xz \
    https://github.com/koreader/koreader/releases/download/${KOREADER_VERSION}/koreader-linux-${ARCH}-${KOREADER_VERSION}.tar.xz \
    && tar -xf koreader.tar.xz

FROM ghcr.io/linuxserver/baseimage-selkies:fedora42@sha256:ad246110cd3917c26b1a5b77f4307218b172a78de9c01af1d5faa8a8f8966c6d AS fedora
ENV \
    HARDEN_DESKTOP=True \
    HARDEN_OPENBOX=True \
    NO_GAMEPAD=True \
    SELKIES_FILE_TRANSFERS=upload,download \
    SELKIES_GAMEPAD_ENABLED=False \
    SELKIES_GAMEPAD_ENABLED=False \
    SELKIES_UI_SIDEBAR_SHOW_FILES=True \
    SELKIES_UI_SIDEBAR_SHOW_GAMEPADS=False \
    SELKIES_UI_SIDEBAR_SHOW_SHARING=False \
    SELKIES_MICROPHONE_ENABLED=False \
    START_DOCKER=False \
    TITLE="Koreader"
RUN --mount=type=cache,target=/var/cache/libdnf5,sharing=locked \
    dnf install -y \
    iputils \
    # https://github.com/linuxserver/docker-baseimage-selkies/issues/100#issuecomment-3367806288
    && echo -e "\ntrue" >> /etc/s6-overlay/s6-rc.d/init-selkies-config/run \
    && sed -i 's|</applications>|  <application class="*">\n <fullscreen>yes</fullscreen>\n </application>\n</applications>|' /etc/xdg/openbox/rc.xml \
    && echo koreader > /defaults/autostart
COPY --from=curl /home/curl_user/bin/koreader /usr/bin/koreader
COPY --from=curl /home/curl_user/lib/koreader /usr/lib/koreader
COPY --from=curl /home/curl_user/share/pixmaps/koreader.png /usr/share/selkies/www/icon.png
EXPOSE 3000

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie@sha256:5aed5b6d2b365824ddd3d5b38e940d77c84133ed0b61a04302e95640ec48b875 AS debian
ENV \
    HARDEN_DESKTOP=True \
    HARDEN_OPENBOX=True \
    NO_GAMEPAD=True \
    SELKIES_FILE_TRANSFERS=upload,download \
    SELKIES_GAMEPAD_ENABLED=False \
    SELKIES_GAMEPAD_ENABLED=False \
    SELKIES_UI_SIDEBAR_SHOW_FILES=True \
    SELKIES_UI_SIDEBAR_SHOW_GAMEPADS=False \
    SELKIES_UI_SIDEBAR_SHOW_SHARING=False \
    SELKIES_MICROPHONE_ENABLED=False \
    START_DOCKER=False \
    TITLE="Koreader"
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update \
    && apt install -y \
    # For network connectivity
    iputils-ping \
    libsdl2-2.0-0 \
    # https://github.com/linuxserver/docker-baseimage-selkies/issues/100#issuecomment-3367806288
    && echo "\ntrue" >> /etc/s6-overlay/s6-rc.d/init-selkies-config/run \
    # Set application to fullscreen
    && sed -i 's|</applications>|  <application class="*">\n <fullscreen>yes</fullscreen>\n </application>\n</applications>|' /etc/xdg/openbox/rc.xml \
    && echo koreader > /defaults/autostart
COPY --from=curl /home/curl_user/bin/koreader /usr/bin/koreader
COPY --from=curl /home/curl_user/lib/koreader /usr/lib/koreader
COPY --from=curl /home/curl_user/share/pixmaps/koreader.png /usr/share/selkies/www/icon.png
EXPOSE 3000
