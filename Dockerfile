
##
## deploy
##
FROM openresty/openresty
WORKDIR /usr/local/openresty/nginx

COPY ./luaSrc       /usr/local/openresty/nginx/conf/luaSrc
COPY *.conf         /usr/local/openresty/nginx/conf


EXPOSE 80 443
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
