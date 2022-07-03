FROM nginx:latest
COPY ops/nginx/reverse-proxy.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
