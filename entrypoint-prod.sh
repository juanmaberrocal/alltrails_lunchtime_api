#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /usr/src/app/tmp/pids/server.pid

# Wait for database to be ready
until nc -z -v -w30 $DATABASE_HOST $DATABASE_PORT; do
 echo 'Waiting for PostgreSQL...'
 sleep 1
done
echo "PostgreSQL is up and running!"

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
