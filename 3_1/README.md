# Exercise 3.1: Deployment Pipeline (GitHub Actions + Watchtower)

> **Dedicated Pipeline Repository:** [https://github.com/Sais-gallego/express-app](https://github.com/Sais-gallego/express-app)  
> **Docker Hub Image:** [`saisgallego/express-app:latest`](https://hub.docker.com/r/saisgallego/express-app)

---

## 1. GitHub Actions Workflow (`.github/workflows/pipeline.yml`)

The deployment pipeline is configured using the latest official Docker actions:

```yaml
name: Release Node.js app

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  build:
    name: Build and Push Docker Image
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v6
        with:
          context: .
          platforms: linux/amd64,linux/arm64
          push: true
          tags: |
            ${{ secrets.DOCKER_USERNAME }}/express-app:latest
            ${{ secrets.DOCKER_USERNAME }}/express-app:${{ github.sha }}
```

---

## 2. Docker Compose Configuration (`docker-compose.yaml`)

Runs both the Express application and Watchtower for automated container updates:

```yaml
services:
  express-app:
    image: saisgallego/express-app:latest
    build:
      context: .
      dockerfile: Dockerfile
    container_name: express-app
    ports:
      - "8080:8080"
    environment:
      - PORT=8080
      - APP_VERSION=2.1.0
    restart: unless-stopped

  watchtower:
    image: nickfedor/watchtower:latest
    container_name: watchtower
    environment:
      # Poll Docker Hub for new image digests every 60 seconds
      - WATCHTOWER_POLL_INTERVAL=60
      # Prune outdated images after container update
      - WATCHTOWER_CLEANUP=true
      # Watch all active containers
      - WATCHTOWER_INCLUDE_STOPPED=true
    volumes:
      # Mount host Docker daemon socket so Watchtower can manage container lifecycles
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped
```

---

## 3. How to Verify

1. Run `docker compose up -d`.
2. Check [http://localhost:8080](http://localhost:8080) in the browser.
3. Make a change in `index.js`, commit, and push to GitHub.
4. Watch the GitHub Actions build finish and push to Docker Hub.
5. Within 60 seconds, check `docker logs -f watchtower` to see Watchtower gracefully restart `express-app` with the new version.
