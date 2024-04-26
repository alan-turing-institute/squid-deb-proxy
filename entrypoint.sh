#! /usr/bin/env sh

# Start the proxy
/etc/init.d/squid-deb-proxy restart

# Watch the log
touch /var/log/squid-deb-proxy/access.log
tail -f /var/log/squid-deb-proxy/access.log