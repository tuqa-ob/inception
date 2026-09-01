# User Documentation

## Services

The infrastructure provides three services:

* **NGINX:** Web server and HTTPS entry point.
* **WordPress:** Website and content management system.
* **MariaDB:** Database used by WordPress.

Each service runs in its own Docker container.

## Start and Stop

From the project root, start the infrastructure with:

```bash
make
```

To stop the services:

```bash
make down
```

To rebuild and restart the infrastructure:

```bash
make re
```

## Website Access

The website is available through the configured domain:

```text
https://tob a idat.42.fr
```

The WordPress administration panel is available at:

```text
https://tobaidat.42.fr/wp-admin
```

Log in using the WordPress administrator credentials.

## Credentials

Sensitive credentials are stored in the `secrets/` directory and are not included directly in the Docker Compose configuration.

The secrets include credentials for:

* MariaDB root user.
* MariaDB WordPress user.
* WordPress administrator.
* WordPress regular user.

Do not commit secret files or passwords to Git.

## Checking the Services

To check whether all containers are running:

```bash
docker compose -f srcs/docker-compose.yml ps
```

The expected services are:

```text
mariadb
wordpress
nginx
```

To check the logs of a specific service:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```

A service is considered healthy when its container is running and its logs do not show critical errors.

To verify WordPress is installed:

```bash
docker exec wordpress wp --allow-root --path=/var/www/html core is-installed
```

A successful installation returns:

```text
Success: WordPress is installed.
```

