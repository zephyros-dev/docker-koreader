FROM docker.io/curlimages/curl:8.20.0@sha256:b3f1fb2a51d923260350d21b8654bbc607164a987e2f7c84a0ac199a67df812a AS curl
ARG ARCH='uname -m'
ARG KOREADER_VERSION=v2026.03
RUN \
    export ARCH=$(eval ${ARCH}) \
    && curl -Lo koreader.tar.xz \
    https://github.com/koreader/koreader/releases/download/${KOREADER_VERSION}/koreader-linux-${ARCH}-${KOREADER_VERSION}.tar.xz \
    && tar -xf koreader.tar.xz

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie@sha256:302c030eac215f033a5aa8baabc9d46b460108f25d49727869b481af21c52491
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
# Set application to fullscreen
RUN sed -i 's|</applications>|  <application class="*">\n <fullscreen>yes</fullscreen>\n </application>\n</applications>|' /etc/xdg/openbox/rc.xml \
    && ln -s ../lib/koreader/koreader.sh /usr/bin/koreader \
    && echo koreader > /defaults/autostart
COPY --from=curl /home/curl_user/lib/koreader /usr/lib/koreader
COPY --from=curl /home/curl_user/share/icons/hicolor/512x512/apps/koreader.png /usr/share/selkies/www/icon.png
EXPOSE 3000
