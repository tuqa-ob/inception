all:
	sudo mkdir -p /home/tobaidat/data/mariadb
	sudo mkdir -p /home/tobaidat/data/wordpress
	docker compose -f srcs/docker-compose.yml up -d --build

build:
	docker compose -f srcs/docker-compose.yml build

down:
	docker compose -f srcs/docker-compose.yml down

re:
	docker compose -f srcs/docker-compose.yml down
	docker compose -f srcs/docker-compose.yml up -d --build

.PHONY: all build down clean fclean re
