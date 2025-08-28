FROM debian:bookworm

WORKDIR /app

RUN apt update -y \
    && apt upgrade -y \
    && apt install -y mariadb-server mariadb-client

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY ./init.sh .
RUN chmod +x init.sh

RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

EXPOSE 3306

ENTRYPOINT ["./init.sh"]
