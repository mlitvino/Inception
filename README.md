## Inception (42 Project)

Lightweight local Kubernetes-like environment using Docker Compose for the 42 Inception project.

This repository builds a small WordPress stack with MariaDB and an Nginx front-end. It uses local bind-mounted volumes for persistent data and Docker secrets for sensitive values.

## Quick summary

- Orchestrator: Docker Compose file at `srcs/docker-compose.yml`.
- Service images are built from `srcs/requirements/*` (nginx, wordpress, mariadb).
- Makefile at the repo root provides convenient commands to build and run the stack.

## Requirements

- Docker and Docker Compose (v2) installed and available to your user.
- Make (for the convenience targets in the `Makefile`).

## Build & run (via Makefile)

From the repository root:

- Build images:

```bash
make build
```

- Start the stack in detached mode:

```bash
make run
```

- Stop containers:

```bash
make stop
```

- Tear down (remove containers, but keep images/volumes):

```bash
make down
```

- Full cleanup (remove images, volumes, and host data directories):

```bash
make clean
```

Note: `make all` runs `build` then `run`.

## How the features are implemented

The compose file (`srcs/docker-compose.yml`) defines three services: `nginx`, `wordpress`, and `mariadb`:

- nginx
  - Built from `srcs/requirements/nginx`.
  - Exposes port 443 on the host (mapped in `docker-compose.yml`).
  - Serves files from the `web` volume mounted at `/var/www/html`.

- wordpress (container name `wp-php`)
  - Built from `srcs/requirements/wordpress`.
  - Uses an `.env` file (path configured via `env_file`) for environment variables.
  - Uses Docker secrets for sensitive values: `admin_pass`, `user_pass`, `mysql_user_pass`.
  - Shares the `web` volume with `nginx` for PHP files and static assets.
  - Healthcheck ensures `php-fpm8.2` is running.

- mariadb
  - Built from `srcs/requirements/mariadb` and includes init scripts and a custom `50-server.cnf`.
  - Uses Docker secrets for `mysql_root_pass` and `mysql_user_pass`.
  - Stores data in the `db` volume, which is bind-mounted to the host path defined by `HOST_DB_DIR`.
  - Healthcheck uses `mysqladmin ping`.

Other implementation notes:

- Volumes & host mapping
  - The compose file maps the named volumes `db` and `web` to host directories using `driver_opts.device` and the environment variables `HOST_DB_DIR` and `HOST_WEB_DIR`. This makes the data persist directly on the host.

- Secrets
  - The compose file expects secret files under `${SECRETS_DIR}` and references them as Docker secrets (not committed to Git).

- Healthchecks and service ordering
  - `depends_on` with `condition: service_healthy` is used so `nginx` waits for `wordpress` and `mariadb` to be healthy before starting.

- Customization points
  - `srcs/requirements/wordpress/Dockerfile` and `init.sh` can be used to add PHP extensions or change WordPress configuration.
  - `srcs/requirements/nginx/conf/default` contains the nginx site config.
  - `srcs/requirements/mariadb/init.sh` and `conf/50-server.cnf` contain DB initialization and tuning.
