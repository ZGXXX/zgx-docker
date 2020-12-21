FROM php:7.3-fpm
LABEL author="zgx"

COPY mirrors /etc/apt/sources.list

RUN rm /etc/apt/sources.list.d -r \
    && apt-get update \
    && apt-get install --allow-downgrades --allow-remove-essential libssl1.1 zlib1g=1:1.2.8.dfsg-5 libmcrypt-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev libncurses5=6.0+20161126-1+deb9u2 libncursesw5=6.0+20161126-1+deb9u2 libtinfo5=6.0+20161126-1+deb9u2 procps curl net-tools git -y \
    && docker-php-ext-install bcmath pdo_mysql sockets zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && printf "\n" | curl 'http://pecl.php.net/get/redis-5.3.2.tgz' -o redis-5.3.2.tgz \
    && pecl install redis-5.3.2.tgz \
    &&  rm -rf redis-5.3.2.tgz \
    &&  rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
    && apt-get clean

# 安装composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 清除 apt cache
RUN rm -rf /var/lib/apt/lists

RUN apt-get clean \
&& apt-get autoclean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 配置php.ini文件
RUN echo "\
max_execution_time = 6000\n\
memory_limit = 256M\n\
upload_max_filesize = 20M\n\
max_file_uploads = 20\n\
default_charset = \"UTF-8\"\n\
short_open_tag = On\n\
cgi.fix_pathinfo = 0\n\
error_reporting = E_ALL & ~E_STRICT & ~E_DEPRECATED" > /usr/local/etc/php/php.ini