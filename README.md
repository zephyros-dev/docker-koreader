[![Build](https://github.com/zephyros-dev/docker-koreader/actions/workflows/build.yaml/badge.svg?branch=main)](https://github.com/zephyros-dev/docker-koreader/actions/workflows/build.yaml)
[![Latest](https://ghcr-badge.egpl.dev/zephyros-dev/koreader/latest_tag?color=%2344cc11&ignore=latest&label=Latest&trim=)](https://github.com/zephyros-dev/docker-koreader/pkgs/container/koreader)
[![Tags](https://ghcr-badge.egpl.dev/zephyros-dev/koreader/tags?color=%2344cc11&ignore=latest&n=3&label=Tags&trim=)](https://github.com/zephyros-dev/docker-koreader/pkgs/container/koreader)

# Description

- Koreader installed in a docker container, accessible via browser.

# Tags

- The image name is `ghcr.io/zephyros-dev/koreader`. The following tags are supported:
- `latest`: Latest version built on the main branch
- `Koreader.version`: Specific version of Koreader. e.g: `v2023.06.1`

# Installation

1. Create a `docker-compose.yaml`. Checkout the [docker-compose.yaml](docker-compose.yaml) for example.

2. Run the following command to start the container

```
docker-compose up -d
```

3. Open your browser and go to `http://localhost:3000`

# Configurations

- The image is based on [linuxserver/baseimage-kasmvnc](https://github.com/linuxserver/docker-baseimage-kasmvnc). See the base image for more configurations options.
- The koreader configurations can be found in `/config/.config/koreader` inside the container.

## Renovate autoupdate

- For [renovate user](https://github.com/renovatebot/renovate), add this to the renovate configuration for the tags auto-update:

```
{
    "extends": ["github>zephyros-dev/docker-koreader"],
}
```
