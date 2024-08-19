[![Latest](https://ghcr-badge.egpl.dev/zephyros-dev/koreader/latest_tag?color=%2344cc11&ignore=latest&label=latest&trim=)](https://github.com/zephyros-dev/docker-koreader/pkgs/container/koreader)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/zephyros-dev/docker-koreader/.github%2Fworkflows%2Fbuild.yaml)
[![Tags](https://ghcr-badge.egpl.dev/zephyros-dev/koreader/tags?color=%2344cc11&ignore=latest&n=3&label=tags&trim=)](https://github.com/zephyros-dev/docker-koreader/pkgs/container/koreader)

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

- The image is based on [linuxserver/baseimage-kasmvnc](https://github.com/linuxserver/docker-baseimage-kasmvnc). Checkout the base image for extra configurations.
- The koreader configurations can be found in `/config/.config/koreader` inside the container.

## Renovate autoupdate

- For user with that use renovate for autoupdate, add this to the renovate configuration for the autoupdate to work:

```
{
    "extends": ["github>zephyros-dev/docker-koreader"],
}
```

- Then use the specific version of koreader as the tag in the image specification. .e.g: `v2023.06.1`
