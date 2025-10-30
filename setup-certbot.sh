#!/usr/bin/env bash
set -euo pipefail

if [ -z "${DOMAIN:-}" ]; then
  echo "❌ Vous devez fournir un domaine via la variable d'environnement DOMAIN (ex: DOMAIN=todolist.example.com)"
  exit 1
fi

if [ -z "${EMAIL:-}" ]; then
  echo "❌ Vous devez fournir un email via la variable d'environnement EMAIL (ex: EMAIL=you@example.com)"
  exit 1
fi

echo "➡️ Génération du certificat Let's Encrypt pour ${DOMAIN}"
docker compose -f docker-compose.yml -f docker-compose.letsencrypt.yml run --rm certbot certonly --webroot       -w /var/www/certbot -d "${DOMAIN}" --agree-tos -m "${EMAIL}" --no-eff-email

echo "🔁 Redémarrage du proxy Nginx avec la config Let's Encrypt"
docker compose -f docker-compose.yml -f docker-compose.letsencrypt.yml up -d nginx
