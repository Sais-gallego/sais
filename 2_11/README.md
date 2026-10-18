# Exercise 2.11: Containerized Development Environment

For this exercise, I containerized the development environment of my Node.js and PostgreSQL web application using Docker and Docker Compose (`docker-compose.yml` and `Dockerfile.dev`). Now any developer only needs Git and Docker installed to start developing.

## What I did

1. **Containerized the Node.js Backend (`Dockerfile.dev`)**:
   - Used `node:20` as the base image.
   - Configured `nodemon` via `npm start` so the server automatically restarts whenever source files change.
   - Mounted the project source directory (`./:/usr/src/app`) as a bind mount so local edits in the code editor are immediately reflected inside the container.
   - Added a named volume (`node_modules:/usr/src/app/node_modules`) so the dependencies installed in the container image are preserved and isolated from the host machine.

2. **Containerized the Database Service (`docker-compose.yml`)**:
   - Added a `postgres:16-alpine` service with a persistent volume (`pgdata`) and exposed port `5432` for local development.

## Files

### `Dockerfile`
```dockerfile
FROM node:20

WORKDIR /usr/src/app

COPY package* ./

RUN npm install
```

### `docker-compose.yml`
```yaml
services:
  node-dev-env:
    build: .
    command: npm start
    ports:
      - 3000:3000
    volumes:
      - ./:/usr/src/app
      - node_modules:/usr/src/app/node_modules
    container_name: node-dev-env
    depends_on:
      - db

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=devdb
    ports:
      - 5432:5432
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  node_modules:
  pgdata:
```
