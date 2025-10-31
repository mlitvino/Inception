all: build run

build:
	mkdir -p data/db data/web
	docker compose -f srcs/docker-compose.yml build --parallel

run:
	docker compose -f srcs/docker-compose.yml up -d

stop:
	docker compose -f srcs/docker-compose.yml stop

restart: stop run

down:
	docker compose -f srcs/docker-compose.yml down

clean:
	docker compose -f srcs/docker-compose.yml down --rmi all --volumes
	docker network prune -f
	sudo rm -rf data/db data/web

re: clean all

.PHONY: all build run stop restart down clean re
