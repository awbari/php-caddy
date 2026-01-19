# PHP & Caddy

A php-fpm container with caddy as web server.

## Build

```sh
docker build --build-arg VERSION=8.3 -t php-caddy . 
```

## Usage

Entrypoint is `/app/public/index.php`

```yml
services:
  app: 
    image: ghcr.io/awbari/php-caddy:latest
    volumes:
      - ./:/app
    ports: 
      - 2337:1337
```
