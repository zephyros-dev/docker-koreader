FROM --platform=$BUILDPLATFORM docker.io/curlimages/curl:8.23.0@sha256:3fb7e13e5d179a845c97d78204f3f1064d1907037f26a3ebf91710571151fd93 AS curl
ARG TARGETARCH
ARG KOREADER_VERSION=v2026.07.1
RUN \
    case "${TARGETARCH}" in \
    amd64) ARCH=x86_64 ;; \
    arm64) ARCH=arm64 ;; \
    *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac \
    && curl -Lo koreader.tar.xz \
    https://github.com/koreader/koreader/releases/download/${KOREADER_VERSION}/koreader-linux-${ARCH}-${KOREADER_VERSION}.tar.xz \
    && tar -xf koreader.tar.xz

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie@sha256:d03d09e9ceb770032db5892dd7caa9b207ef09b55a9b79491a1c4d37842e6c01
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
COPY --from=curl /home/curl_user/share/icons/hicolor/512x512/apps/rocks.koreader.KOReader.png /usr/share/selkies/www/icon.png
EXPOSE 3000
