# Exercise 3.2: Deployment Pipeline to a Cloud Service

Deployed application URL: https://devops-with-docker.mooc.fi/

## GitHub Actions Cloud Deployment Workflow (`.github/workflows/deploy.yml`)

```yaml
name: Deploy to Render / Fly.io

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Flyctl
        uses: superfly/flyctl-actions/setup-flyctl@master

      - name: Deploy to Cloud
        run: flyctl deploy --remote-only
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
```
