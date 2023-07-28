
##
## deploy
##
FROM openresty/openresty
WORKDIR /usr/local/openresty/nginx
CMD mkdir -p /usr/local/openresty/so

COPY ./luaSrc       /usr/local/openresty/nginx/conf/luaSrc
COPY ./go/*.so      /usr/local/openresty/so
COPY *.conf         /usr/local/openresty/nginx/conf


EXPOSE 80 443
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
