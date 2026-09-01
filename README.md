*This activity has been created as part of
the 42 curriculum by tobaidat*

# inception


## Description

Inception is a system administration project that builds a secure web infrastructure using **Docker Compose** inside a virtual machine.

The infrastructure contains three dedicated containers:

* **NGINX** – HTTPS web server using SSL/TLS.
* **WordPress + PHP-FPM** – web application.
* **MariaDB** – database.

Docker Compose manages the services, a custom Docker network handles internal communication, volumes provide persistent storage, and Docker Secrets protect sensitive credentials.

## Main Design Choices

* **Custom Docker network:** Allows NGINX, WordPress, and MariaDB to communicate internally without exposing unnecessary ports.
* **Persistent volumes:** Keep WordPress and MariaDB data after containers are recreated.
* **Docker Secrets:** Store passwords separately from the application configuration.
* **NGINX as entry point:** Only NGINX is exposed to the host and handles HTTPS traffic.

### Comparisons

**Virtual Machines vs Docker**

* VMs virtualize a complete OS and use more resources.
* Docker containers share the host kernel and are lighter and faster.

**Secrets vs Environment Variables**

* Secrets are used for sensitive information such as passwords.
* Environment variables are used for normal configuration.

**Docker Network vs Host Network**

* Docker Network provides isolated container-to-container communication.
* Host Network uses the host's network directly and provides less isolation.

**Docker Volumes vs Bind Mounts**

* Volumes are managed by Docker and provide persistent storage.
* Bind mounts directly map a host directory to a container.

## Instructions

1. Clone the repository and navigate to the project root.
2. Make sure Docker and Docker Compose are installed.
3. Configure the required environment variables in the `.env` file.
4. Add the required credentials to the `secrets/` directory.
5. Run the application using the Makefile:

```bash
make
```

6. The Makefile builds the required Docker images and starts all services using Docker Compose.
7. Access the WordPress website through the configured domain over HTTPS.

To stop the infrastructure:

```bash
make down
```

To rebuild the project from scratch:

```bash
make re
```


## Resources

- https://docs.docker.com/reference/compose-file/volumes/?utm_source=chatgpt.com
- https://circleci-com.translate.goog/blog/what-is-yaml-a-beginner-s-guide/?_x_tr_sl=en&_x_tr_tl=ar&_x_tr_hl=ar&_x_tr_pto=sge
- https://developer.wordpress.org/advanced-administration/before-install/howto-install/
- https://medium.com/@mgonzalezbaile/demystifying-nginx-and-php-fpm-for-php-developers-bba548dd38f9

### AI Usage
- chatGPT to explain the new topics and edit any error in the script
- Gemini AI to give me examples on each case and how every command in the script affects the work
