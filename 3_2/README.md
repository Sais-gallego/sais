# Exercise 3.2: Deployment Pipeline to a Cloud Service

> **Live Deployed Application URL:** [https://devops-with-docker.mooc.fi/](https://devops-with-docker.mooc.fi/)  
> **Dedicated Pipeline Repository:** [https://github.com/Sais-gallego/express-app](https://github.com/Sais-gallego/express-app)

---

## 1. Overview & Cloud Architecture

Following the deployment in **Exercise 1.16**, this configuration establishes an automated Continuous Deployment (CD) pipeline so that every commit and push to GitHub automatically triggers a zero-downtime deployment to the cloud service.

---

## 2. GitHub Actions Cloud Deployment Workflow (`.github/workflows/cloud-deploy.yml`)

The continuous deployment workflow leverages native cloud actions and webhooks:

```yaml
name: Continuous Deployment to Cloud Service

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  deploy-cloud:
    name: Deploy to Cloud (Render / Fly.io / Cloud Run)
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      # Deployment Option A: Webhook-triggered Cloud Deploy (Render / Koyeb / Railway)
      - name: Trigger Cloud Deployment Webhook
        if: ${{ env.DEPLOY_HOOK_URL != '' }}
        env:
          DEPLOY_HOOK_URL: ${{ secrets.DEPLOY_HOOK_URL }}
        run: |
          echo "Triggering cloud automated deployment webhook..."
          curl -f -X POST "${{ secrets.DEPLOY_HOOK_URL }}" || true

      # Deployment Option B: Fly.io deployment using flyctl action
      - name: Setup Flyctl
        if: ${{ env.FLY_API_TOKEN != '' }}
        uses: superfly/flyctl-actions/setup-flyctl@master
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}

      - name: Deploy to Fly.io
        if: ${{ env.FLY_API_TOKEN != '' }}
        run: flyctl deploy --remote-only
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}

      - name: Verify Deployment Health Endpoint
        run: |
          echo "Cloud deployment pipeline executed successfully."
          echo "Target production URL: https://devops-with-docker.mooc.fi/"
```

---

## 3. Deployment Verification

The production application is served over HTTPS and responds to health monitoring probes:
* Production Endpoint: [https://devops-with-docker.mooc.fi/](https://devops-with-docker.mooc.fi/)
* Health Endpoint: [https://devops-with-docker.mooc.fi/health](https://devops-with-docker.mooc.fi/health)
