# Description

[![Build](https://github.com/zephyros-dev/docker-koreader/actions/workflows/build.yaml/badge.svg?branch=main)](https://github.com/zephyros-dev/docker-koreader/actions/workflows/build.yaml)
[![Latest](https://ghcr-badge.egpl.dev/zephyros-dev/koreader/latest_tag?color=%2344cc11&ignore=latest&label=Latest&trim=)](https://github.com/zephyros-dev/docker-koreader/pkgs/container/koreader)
[![Tags](https://ghcr-badge.egpl.dev/zephyros-dev/koreader/tags?color=%2344cc11&ignore=latest&n=3&label=Tags&trim=)](https://github.com/zephyros-dev/docker-koreader/pkgs/container/koreader)

Koreader installed in a docker container, accessible via browser.

## Tags

The image name is `ghcr.io/zephyros-dev/koreader`. The following tags are supported:

- `latest`: Latest version built on the main branch
- `Koreader.version`: Specific version of Koreader. e.g: `v2023.06.1`
- `Koreader.version-distro`: Version of Koreader along with distro:

  - Debian example: `v2025.04-debianbookworm`
  - Fedora example: `v2025.04-fedora42`

## Installation

1. Create a `docker-compose.yaml`. Checkout the [docker-compose.yaml](docker-compose.yaml) for example.

2. Run the following command to start the container

   ```bash
   docker-compose up -d
   ```

3. Open your browser and go to `http://localhost:3000`

## Configurations

- The image is based on [linuxserver/baseimage-selkies](https://github.com/linuxserver/docker-baseimage-selkies). See the base image for more configurations options.
- The koreader configurations can be found in `/config/.config/koreader` inside the container.
- For user with Fedora native distro and Nvidia GPU, you will need to use the fedora image tag for the NVENC to work.

### Renovate autoupdate

- For [renovate user](https://github.com/renovatebot/renovate), add this to the renovate configuration for the tags auto-update:

  ```json
  {
    "extends": ["github>zephyros-dev/docker-koreader"],
  }
  ```
