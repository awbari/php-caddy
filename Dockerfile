ARG VERSION=8.3.36
FROM php:$VERSION-fpm-alpine

RUN php -r 'if (PHP_MAJOR_VERSION !== 8 || PHP_MINOR_VERSION !== 3 || PHP_VERSION_ID < 80336) { fwrite(STDERR, "Expected PHP 8.3.36 or newer, got " . PHP_VERSION . PHP_EOL); exit(1); }'

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS imagemagick-dev && \
		apk add --update --no-cache \
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
			icu-dev \
			imagemagick \
			tidyhtml-dev \
			&& \
		docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
		docker-php-ext-install -j$(nproc) gd exif zip tidy intl && \
		pecl install imagick && \
		docker-php-ext-enable imagick && \
		apk del .build-deps

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
