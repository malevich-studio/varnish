#!/bin/sh
set -e

: "${VARNISH_BACKEND_HOST:=localhost}"
: "${VARNISH_BACKEND_PORT:=80}"
: "${VARNISH_STORAGE:=malloc}"
: "${VARNISH_SIZE:=256m}"
: "${VARNISH_HTTP_PORT:=80}"

envsubst < /etc/varnish/default.vcl.template > /etc/varnish/default.vcl

exec varnishd \
  -a :${VARNISH_HTTP_PORT} \
  -f /etc/varnish/default.vcl \
  -s "${VARNISH_STORAGE},${VARNISH_SIZE}" \
