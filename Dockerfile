FROM debian:bullseye-slim

# Set up work directory
WORKDIR /app

# Install squid-deb-proxy then cleanup
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
      squid-deb-proxy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add an entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Start with a blank set of allowed domains
RUN echo "# Default deny all" > /etc/squid-deb-proxy/mirror-dstdomain.acl

# At least one package must be blacklisted or autogeneration will fail
RUN echo "non-existent-package" > /etc/squid-deb-proxy/pkg-blacklist

# Set all files in /app/allowlists as allowed domains
RUN mkdir -p /app/allowlists && \
    rm -rf /etc/squid-deb-proxy/mirror-dstdomain.acl.d && \
    ln -sf /app/allowlists /etc/squid-deb-proxy/mirror-dstdomain.acl.d

# Set correct file permissions
RUN touch /var/log/squid-deb-proxy/access.log && \
    touch /var/log/squid-deb-proxy/cache.log && \
    touch /var/log/squid-deb-proxy/store.log && \
    chown -R proxy:proxy /var/log/squid-deb-proxy

EXPOSE 8000/tcp

ENTRYPOINT ["/app/entrypoint.sh"]