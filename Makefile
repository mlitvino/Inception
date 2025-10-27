all:
	mkdir -p /home/mlitvino/data/db /home/mlitvino/data/web
	COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1
	docker compose -f srcs/docker-compose.yml build --parallel
	docker compose -f srcs/docker-compose.yml create

run: all
	docker compose -f srcs/docker-compose.yml up -d

stop:
	docker compose -f srcs/docker-compose.yml stop

clean:
	docker compose -f srcs/docker-compose.yml down --rmi all --volumes --remove-orphans
	docker network prune -f
	sudo rm -rf /home/mlitvino/data/db /home/mlitvino/data/web

re: clean all

.PHONY: all clean re