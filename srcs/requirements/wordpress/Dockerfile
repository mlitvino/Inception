FROM debian:bookworm

RUN apt update \
	&& apt upgrade \
	&& apt install -y php-fpm php-mysql curl 

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/

COPY init.sh .
RUN chmod +x init.sh

CMD ["./init.sh"]

