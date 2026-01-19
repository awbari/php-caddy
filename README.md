# PHP for Kirby CMS

A php-fpm container for kirby cms with caddy as web server.

## Usage

```yml
services:
  app: 
    image: ghcr.io/primalebenundstereo/kirby:latest
    volumes:
      - ./:/app
    ports: 
      - 2337:1337
```
