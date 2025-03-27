# 🔥 Varnish Cache with Dynamic Backend Configuration

This project provides a lightweight, customizable Docker image for [Varnish Cache](https://varnish-cache.org/).  
It supports dynamic configuration via environment variables and automatically adds caching headers for optimized image delivery or API response caching.

---

## 🚀 Features

- Customizable backend host and port via environment variables
- Configurable storage type and cache size
- Adds long-term caching headers for successful responses
- Short TTL and no-cache headers for failed responses
- Easy to plug in behind NGINX or use standalone (HTTP only)

---

## 📦 Environment Variables

| Variable                 | Default     | Description                                  |
|--------------------------|-------------|----------------------------------------------|
| `VARNISH_BACKEND_HOST`   | `localhost` | Hostname of the backend service              |
| `VARNISH_BACKEND_PORT`   | `80`        | Port of the backend service                  |
| `VARNISH_STORAGE`        | `malloc`    | Storage type (`malloc`, `file`, etc.)        |
| `VARNISH_SIZE`           | `256m`      | Cache size (e.g., `256m`, `1G`)              |
| `VARNISH_HTTP_PORT`      | `80`        | Port Varnish will listen on for HTTP         |

---

## 🛠️ How It Works

On container startup, the `entrypoint.sh` script:

1. Reads environment variables
2. Generates the final VCL config from `/etc/varnish/default.vcl.template`
3. Starts `varnishd` with the generated config and specified cache options

---

## 🔧 Example: Run with Docker

```bash
docker run -p 8080:80 \
  -e VARNISH_BACKEND_HOST=imgproxy \
  -e VARNISH_BACKEND_PORT=8080 \
  -e VARNISH_STORAGE=malloc \
  -e VARNISH_SIZE=512m \
  -e VARNISH_HTTP_PORT=80 \
  my-varnish-image
```

## 🐳 Example: docker-compose.yml

```yaml
services:
  varnish:
    image: malevichstudio/varnish
    ports:
      - "8080:80"
    environment:
      VARNISH_BACKEND_HOST: imgproxy
      VARNISH_BACKEND_PORT: 8080
      VARNISH_STORAGE: malloc
      VARNISH_SIZE: 512m
      VARNISH_HTTP_PORT: 80
    depends_on:
      - imgproxy

  imgproxy:
    image: malevichstudio/imgproxy
    ports:
      - "8081:8080"
    volumes:
      - ./images:/mnt/data:ro
```

## 🔐 Notes

- This image does not support HTTPS by itself. To serve over HTTPS, use it behind a reverse proxy like NGINX, HAProxy, or Caddy for TLS termination.
- For best performance, put Varnish in front of heavy backends (e.g., image servers, APIs).
-   Make sure your backend responds to the appropriate Host headers or adjust them in your VCL if needed.

## 📥 License

MIT
