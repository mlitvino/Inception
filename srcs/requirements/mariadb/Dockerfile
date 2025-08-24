FROM debian:12.11

WORKDIR /app

RUN apt update -y \
	&& apt upgrade -y \
	&& apt install -y mariadb-server mariadb-client

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY conf/init.sql /etc/mysql/init.sql

COPY ./init.sh .
RUN chmod +x init.sh

RUN mkdir -p /var/run/mysqld \
	&& chown -R mysql:mysql /var/run/mysqld \
	&& chmod 777 /var/run/mysqld

EXPOSE 3306

#ENTRYPOINT ["./init.sh"]
#CMD ["/usr/bin/mariadbd-safe", "--bind-address=0.0.0.0"]
RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql
CMD ["/usr/bin/mariadbd-safe", "--bind-address=0.0.0.0", "--datadir=/var/lib/mysql"]
