FROM docker.io/curlimages/curl:8.19.0@sha256:b066cbf876d50a5d024927878a586c4a39c985325ded195e2e231f4abdddf3c8 AS curl
ARG ARCH='uname -m'
ARG KOREADER_VERSION=v2026.03
RUN \
    export ARCH=$(eval ${ARCH}) \
    && curl -Lo koreader.tar.xz \
    https://github.com/koreader/koreader/releases/download/${KOREADER_VERSION}/koreader-linux-${ARCH}-${KOREADER_VERSION}.tar.xz \
    && tar -xf koreader.tar.xz

FROM ghcr.io/linuxserver/baseimage-selkies:fedora43@sha256:c17a6ddc86ba7f68b7c4411581d5292c4bcafbe97940c840091cef2a16684156 AS fedora
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
    && sed -i 's|</applications>|  <application class="*">\n <fullscreen>yes</fullscreen>\n </application>\n</applications>|' /etc/xdg/openbox/rc.xml \
    && ln -s ../lib/koreader/koreader.sh /usr/bin/koreader \
    && echo koreader > /defaults/autostart
COPY --from=curl /home/curl_user/lib/koreader /usr/lib/koreader
COPY --from=curl /home/curl_user/share/icons/hicolor/512x512/apps/koreader.png /usr/share/selkies/www/icon.png
EXPOSE 3000

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie@sha256:337a37ef028c3dbb9bdc35bbb27ef9d06814ea2d02b6cfe61873ab4cfb46ed52 AS debian
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
    # Set application to fullscreen
    && sed -i 's|</applications>|  <application class="*">\n <fullscreen>yes</fullscreen>\n </application>\n</applications>|' /etc/xdg/openbox/rc.xml \
    && ln -s ../lib/koreader/koreader.sh /usr/bin/koreader \
    && echo koreader > /defaults/autostart
COPY --from=curl /home/curl_user/lib/koreader /usr/lib/koreader
COPY --from=curl /home/curl_user/share/icons/hicolor/512x512/apps/koreader.png /usr/share/selkies/www/icon.png
EXPOSE 3000
