FROM nginx:latest

RUN apt-get update -qq && apt-get -y install apache2-utils certbot python3-certbot-nginx

RUN mkdir log

COPY ./ops/script/ssl.sh /usr/bin/ssl
RUN chmod +x /usr/bin/ssl

COPY ops/nginx/reverse-proxy.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
