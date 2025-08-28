all:
	mkdir -p /home/mlitvino/data/db /home/mlitvino/data/web
	docker compose -f srcs/docker-compose.yml create

run: all
	docker compose -f srcs/docker-compose.yml up -d

stop:
	docker compose -f srcs/docker-compose.yml stop

clean:
	docker compose -f srcs/docker-compose.yml down --rmi all --volumes --remove-orphans
	rm -rf /home/mlitvino/data/db /home/mlitvino/data/web

re: clean all

.PHONY: all clean re