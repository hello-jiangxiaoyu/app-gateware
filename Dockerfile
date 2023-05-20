
##
## deploy
##
FROM openresty/openresty
WORKDIR /usr/local/openresty/nginx

COPY ./luaSrc /usr/local/openresty/nginx/conf/luaSrc
COPY ./script /usr/local/openresty/nginx/conf/script
COPY ./myconf /usr/local/openresty/nginx/conf/myconf
COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
RUN mkdir -p /usr/local/openresty/configuration

EXPOSE 80 443 8888
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
