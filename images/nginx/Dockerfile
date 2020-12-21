FROM nginx:1.15

COPY sites.conf /etc/nginx/conf.d/
COPY nginx.conf /etc/nginx/nginx.conf

COPY certs /certs
COPY mirrors /etc/apt/sources.list

RUN rm /etc/apt/sources.list.d -r \
    && apt-get update \
    && apt-get install --allow-downgrades --allow-remove-essential libssl1.1 zlib1g=1:1.2.8.dfsg-5 libmcrypt-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev libncurses5=6.0+20161126-1+deb9u2 libncursesw5=6.0+20161126-1+deb9u2 libtinfo5=6.0+20161126-1+deb9u2 procps curl net-tools git -y \
    && apt-get clean