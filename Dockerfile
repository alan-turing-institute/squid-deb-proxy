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

# Set all files in /app/allowlists as allowed domains
RUN mkdir -p /app/allowlists && \
    rm -rf /etc/squid-deb-proxy/mirror-dstdomain.acl.d && \
    ln -sf /app/allowlists /etc/squid-deb-proxy/mirror-dstdomain.acl.d

EXPOSE 8000/tcp

ENTRYPOINT ["/app/entrypoint.sh"]