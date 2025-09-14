#!/bin/sh
set -e

# wait for DB to be available (if using service 'db')
if [ -n "$POSTGRES_DB" ]; then
  echo "Waiting for Postgres at ${DATABASE_HOST:-db}:${DATABASE_PORT:-5432}..."
  until nc -z ${DATABASE_HOST:-db} ${DATABASE_PORT:-5432}; do
    sleep 1
  done
fi

# migrate, collectstatic, then start gunicorn
python manage.py migrate --noinput
python manage.py collectstatic --noinput || true
exec gunicorn todo.wsgi:application --bind 0.0.0.0:8080 --workers 3
