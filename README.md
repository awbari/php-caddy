# PHP for Kirby CMS

A php-fpm container for kirby cms with caddy as web server.

## Build

```sh
docker build --build-arg VERSION=8.3 -t php-caddy . 
```

## Usage

```yml
services:
  app: 
    image: ghcr.io/awbari/php-caddy:latest
    volumes:
      - ./:/app
    ports: 
      - 2337:1337
```
