# Exercise 3.10: .dockerignore and Security / Privacy in Docker Images

> **Course:** DevOps with Docker (Fall 2026) — University of Helsinki / MOOC.fi  
> **Student:** Sergio Andrés Ipuz Saavedra ([@Sais-gallego](https://github.com/Sais-gallego))  
> **Target Image / Repo:** `devopsdockeruh/dockerignore_exercise` / `https://github.com/docker-hy/exercise-dockerignore`

---

## 📋 Comprehensive Answer for Exercise 3.10 Submission

### 1. Files and directories from the repository that MUST be added to `.dockerignore`:

Based on the exploration of `devopsdockeruh/dockerignore_exercise` and the repository contents:

1. **`.git` (Critical Privacy & Size):**
   * **Reason:** The `.git` directory contains the complete commit history, tree objects, author names, email addresses, and past commits. If developers ever accidentally committed credentials, private repository URLs, or internal branch names in past commits, anyone pulling the public Docker image can inspect them (`git log`, `git checkout`). Furthermore, the `.git` directory continually grows and adds tens of megabytes of unnecessary build context to the final image.
2. **`.env` and `.env.*` (Critical Security):**
   * **Reason:** Environment configuration files contain high-value production/development secrets such as database connection strings, JWT private keys, API secrets, and OAuth credentials. If `COPY . .` is used without ignoring `.env`, these plaintext secrets become permanently baked into the image layers.
3. **`backup/` (Data Breach Risk & Size):**
   * **Reason:** Contains local database dumps or mock client data. Baking database backups into a container image creates severe data leak vulnerabilities (GDPR violations) and needlessly inflates the image size.
4. **`node_modules/` (Size & Cross-Platform Incompatibility):**
   * **Reason:** Local `node_modules` might contain dependencies compiled for the host OS/architecture (e.g., Windows/macOS instead of Linux) and devDependencies. Copying local `node_modules` drastically slows down build context transfer and causes native module compilation failures. Dependencies should always be cleanly installed inside the container via `npm ci`.
5. **`documentation/` (e.g., `possibleContent.md`) & `README.md` (Image Size & Information Disclosure):**
   * **Reason:** Internal documentation, roadmaps, architecture guides, and user manuals are completely irrelevant for the runtime execution of the application and bloat the image size.
6. **`tests/` & Test Configurations (`.oxlintrc.json`):**
   * **Reason:** Unit tests, mock payloads, and linter configs are only required during CI/test phases, not inside the final production container.
7. **`logs/` and `*.log` (e.g., `npm-debug.log*`):**
   * **Reason:** Logs take up unnecessary disk space and might leak internal stack traces or IP addresses.
8. **`.github/`:**
   * **Reason:** CI/CD workflows and action metadata are not needed at runtime.
9. **Editor/OS files (`.vscode/`, `.idea/`, `.DS_Store`, `Thumbs.db`):**
   * **Reason:** Clutter and platform-specific artifacts.

---

### 2. What else should be added to `.dockerignore` by default? (Best Practices)

In general industry container engineering, the following should be added to `.dockerignore` by default:

1. **Cryptographic Keys and Certificates:**
   * `*.pem`, `*.key`, `*.crt`, `*.pfx`, `id_rsa*`, `known_hosts`.
2. **Cloud Provider and Tool Credentials:**
   * `.aws/`, `.gcp/`, `gcp-key.json`, `.azure/`, `.docker/config.json`, `.kube/config`.
3. **Temporary and Build Directories:**
   * `dist/`, `build/`, `target/`, `out/`, `*.tmp`, `*.swp`.
4. **Package Manager Caches:**
   * `.npm/`, `.yarn/cache`, `.pnpm-store/`, `.cache/`.
5. **Docker Infrastructure Files:**
   * `Dockerfile*`, `docker-compose*.yml`, `.dockerignore`.
6. **The "Default Deny" (Allowlist) Inverted Pattern:**
   * For maximum security in production, many teams employ an **inverted allowlist pattern**:
     ```dockerignore
     # Ignore everything by default
     *
     # Whitelist only strictly necessary runtime source files
     !package.json
     !package-lock.json
     !src/
     !public/
     !index.html
     !vite.config.ts
     ```
     This ensures that any newly created sensitive file, dump, or test folder is automatically excluded unless deliberately allowed.
