FROM varnish:7.7.0

USER root
RUN apt-get update && apt-get install -y gettext-base
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER varnish

COPY default.vcl.template /etc/varnish/default.vcl.template
RUN varnishd -C -f /etc/varnish/default.vcl

ENTRYPOINT ["/entrypoint.sh"]
