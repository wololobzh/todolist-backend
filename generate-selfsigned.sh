#!/usr/bin/env bash
set -euo pipefail
mkdir -p nginx/certs-selfsigned

echo "➡️ Génération d'un certificat auto-signé pour 51.254.205.63 (valable 365 jours)"
openssl req -x509 -nodes -days 365 -newkey rsa:2048       -keyout nginx/certs-selfsigned/selfsigned.key       -out nginx/certs-selfsigned/selfsigned.crt       -subj "/CN=51.254.205.63"
echo "✅ Certificat auto-signé généré : nginx/certs-selfsigned/selfsigned.crt"
