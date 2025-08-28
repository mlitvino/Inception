FROM debian:bookworm

WORKDIR /app

RUN apt update -y \
	&& apt upgrade -y \
	&& apt install nginx -y \
	&& apt install openssl -y 

RUN openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key  \
	-out /etc/ssl/certs/nginx-selfsigned.crt \ 
	-subj "/C=FI/L=HS/O=HIVE/OU=student/CN=mlitvino.42.fr"

COPY conf/default /etc/nginx/sites-available/

CMD ["nginx", "-g", "daemon off;"]
