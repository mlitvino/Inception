#!/bin/bash
set -e

# Initialize DB if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Exec passes control to CMD
exec "$@"
