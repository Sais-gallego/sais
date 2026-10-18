# Exercise 3.1: Deployment Pipeline (GitHub Actions + Watchtower)

## GitHub Actions Workflow (`.github/workflows/main.yml`)

```yaml
name: Release Node.js app

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ${{ secrets.DOCKERHUB_USERNAME }}/express-app:latest
```

## `docker-compose.yml` (Express App + Watchtower)

```yaml
services:
  express-app:
    image: saisgallego/express-app:latest
    ports:
      - 8080:8080
    container_name: express-app

  watchtower:
    image: containrrr/watchtower
    environment:
      - WATCHTOWER_POLL_INTERVAL=60
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    container_name: watchtower
```
