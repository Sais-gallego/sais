<div align="center">

# 🐳 DevOps with Docker — University of Helsinki

[![Verify Exercises](https://github.com/Sais-gallego/sais/actions/workflows/tests.yml/badge.svg)](https://github.com/Sais-gallego/sais/actions/workflows/tests.yml)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat-square&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat-square&logo=github-actions&logoColor=white)

Repositorio oficial de soluciones y automatización para el curso **DevOps with Docker** de la Universidad de Helsinki ([MOOC.fi](https://courses.mooc.fi)). Incluye todos los ejercicios prácticos de las Partes 1, 2 y 3 verificados automáticamente mediante GitHub Actions.

</div>

---

## 📦 Contenido por Módulos

### 🔹 Parte 1: Docker Basics (`1_07` – `1_16`)
Creación de imágenes personalizadas, configuración de puertos, variables de entorno, persistencia con volúmenes y empaquetado de servicios frontend y backend:
- **`1_07` – `1_08`**: Contenedorización de scripts y servidores web con `Dockerfile` (`ENTRYPOINT` / `CMD`).
- **`1_09` – `1_10`**: Uso de *bind mounts* y publicación de puertos en contenedores.
- **`1_11` (Spring)**, **`1_12` (Frontend React)**, **`1_13` (Backend Go)** y **`1_14` (Full Stack Environment)**: Construcción y comunicación entre frontend y backend.
- **`1_15` – `1_16`**: Publicación de imágenes en Docker Hub y despliegue en la nube.

---

### 🔹 Parte 2: Docker Compose (`2_01` – `2_11` & `example-app`)
Orquestación declarativa de arquitecturas multi-contenedor, redes internas, bases de datos, caché y *reverse proxy*:
- **`2_01` – `2_02`**: Definición de servicios y volúmenes con `docker-compose.yml`.
- **`2_03-10` & `example-app`**: Arquitectura completa con:
  - **Frontend** (React / Serve)
  - **Backend** (Golang REST API)
  - **Redis** (Caché en memoria)
  - **PostgreSQL** (Persistencia relacional con volúmenes)
  - **Nginx Reverse Proxy** (Punto de entrada unificado en el puerto `80` enrutando `/` y `/api/`)
- **`2_11`**: Entorno de desarrollo contenedorizado con *hot-reloading*.

---

### 🔹 Parte 3: Security & Optimization (`3_1` – `3_11` & `code`)
Pipelines CI/CD, seguridad en contenedores y optimización avanzada del tamaño de imágenes:
- **`3_1` – `3_2`**: Despliegue continuo y construcción automatizada de imágenes con GitHub Actions y Watchtower.
- **`3_3` – `3_4`**: Automatización de builds mediante scripts y Docker socket.
- **`3_5` (`code/`)**: ejecución segura mediante usuarios **no-root (`appuser`)**.
- **`3_6` – `3_7`**: Optimización de capas (`RUN` consolidados) y migración a imágenes base **Alpine Linux**.
- **`3_8` – `3_9` (`3_89/`)**: **Multi-stage builds** para frontend estático (servido desde `nginx:alpine`) y binario compilado en Go ejecutándose sobre una imagen mínima **`FROM scratch`**.
- **`3_10` – `3_11`**: Optimización de seguridad y diagramación de arquitectura en Kubernetes / Docker.

---

## ✅ Verificación Automatizada (CI/CD)

Cada commit ejecuta el workflow [`.github/workflows/tests.yml`](.github/workflows/tests.yml), el cual valida los **25 tests oficiales** de los 3 módulos del curso construyendo las imágenes y comprobando los servicios en tiempo real.
