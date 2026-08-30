FROM debian:bookworm

RUN apt-get update -y && \
    apt-get install -y nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/ssl /etc/nginx/ssl
RUN chmod 600 /etc/nginx/ssl/server.key && \
    chmod 644 /etc/nginx/ssl/server.crt

CMD [ "nginx", "-g", "daemon off;" ]
