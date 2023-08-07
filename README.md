# Description

- Koreader installed in a docker container, accessible via browser.

# Tags

- `latest`: Latest version built on the main branch
- `Koreader.version`: Specific version of Koreader

# Installation

1. Create a `docker-compose.yaml`

```
services:
  koreader:
    image: ghcr.io/zephyros-dev/koreader:latest
    ports:
      - "3000:3000"
    volumes:
      # Persistent storage
      - ./config:/config
```

2. Run the following command to start the container

```
docker-compose up -d
```

3. Open your browser and go to `http://localhost:3000`

# Configurations

- The image is based on [linuxserver/baseimage-kasmvnc](https://github.com/linuxserver/docker-baseimage-kasmvnc). Checkout the original image for extra configurations.
- The koreader configurations can be found in `/config/.config/koreader` inside the container.
