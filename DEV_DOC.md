# Developer Documentation

## Prerequisites

Before starting, make sure the following are installed:

* Linux virtual machine.
* Docker and Docker Compose.
* Git.
* Required system permissions to run Docker commands.

## Environment Setup

Clone the project and enter the project directory:

```bash
git clone <repository-url>
cd <project-directory>
```

The project contains:

```text
Makefile
srcs/
├── docker-compose.yml
└── requirements/
    ├── nginx/
    ├── wordpress/
    └── mariadb/
secrets/
```

Configuration values are defined in the Docker Compose configuration and `.env` where applicable.

Sensitive credentials are stored separately in the `secrets/` directory and should never be committed to Git.

## Build and Launch

From the project root:

```bash
make
```

This builds the Docker images and starts the complete infrastructure using Docker Compose.

To build the images without starting the containers:

```bash
make build
```

To stop the infrastructure:

```bash
make down
```

To rebuild and restart everything:

```bash
make re
```

## Container Management

Check running containers:

```bash
docker compose -f srcs/docker-compose.yml ps
```

View service logs:

```bash
docker compose -f srcs/docker-compose.yml logs <service>
```

Enter a running container:

```bash
docker exec -it <container> bash
```

List Docker images:

```bash
docker images
```

List Docker volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect <volume>
```

## Data Storage and Persistence

The project uses persistent storage for WordPress and MariaDB.

The main data is stored in:

```text
/home/tobaidat/data/wordpress
/home/tobaidat/data/mariadb
```

These directories are used as the backing storage for the Docker volumes.

Therefore, recreating or removing the containers does not remove the application data. WordPress files and MariaDB data remain available when the services are started again.

To remove the containers, network, and images without deleting the persistent data:

```bash
docker compose -f srcs/docker-compose.yml down --rmi all
```

To completely remove the Compose volumes as well, use:

```bash
docker compose -f srcs/docker-compose.yml down -v
```

**Warning:** Removing the volumes deletes the data stored in those Docker volumes.


### Accessing the Database

To access the MariaDB database from inside the container:

```bash
docker exec -it mariadb mariadb -u wpuser -p
```

Enter the database user's password when prompted.

To access the MariaDB server as the root user:

```bash
docker exec -it mariadb mariadb -u root -p
```

To list the available databases:

```sql
SHOW DATABASES;
```

To select the WordPress database:

```sql
USE wordpress;
```

To list its tables:

```sql
SHOW TABLES;
```

To view WordPress users:

```sql
SELECT ID, user_login, user_email FROM wp_users;
```

Exit the MariaDB console with:

```sql
EXIT;
```

