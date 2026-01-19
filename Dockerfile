ARG VERSION
FROM php:$VERSION-fpm-alpine

RUN apk add --update --no-cache \
	openssh-client \
	freetype-dev \
	libwebp-dev \
	libzip-dev \
	zlib \
	git \
	sqlite \
	libjpeg-turbo-dev \
	bash \
	libpng-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install -j$(nproc) gd exif zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl --output /usr/local/bin/caddy "https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com%2Fbaldinof%2Fcaddy-supervisor" \
  && chmod +x /usr/local/bin/caddy

COPY ./php.ini /usr/local/etc/php/conf.d/settings.ini
COPY ./Caddyfile /etc/Caddyfile

RUN addgroup app \ 
	&& adduser -S -u 1000 -s /bin/bash app -G app \
	&& mkdir -p /app && chown app:app -R /app

USER app
WORKDIR /app

CMD ["caddy", "run", "--config", "/etc/Caddyfile"]

EXPOSE 1337
