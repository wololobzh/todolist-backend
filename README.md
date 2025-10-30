# TodoList - Backend, Nginx & Deploy (Docker Compose)

## Tester le projet en local local

### 🧩 Étape 1 : Lancer le backend (Express)

```bash
cd todolist-backend
npm install
npm run dev
```

➡️ Le serveur tourne sur [http://localhost:4000](http://localhost:4000)
Tu peux tester avec :

```bash
curl http://localhost:4000/api/todos
```

## Tester le projet en local avec Docker

### 🧩 Étape 1 : Lancer le backend (Express)

```bash
cd todolist-backend
npm install
npm run dev
```

➡️ Le serveur tourne sur [http://localhost:4000](http://localhost:4000)
Tu peux tester avec :

```bash
curl http://localhost:4000/api/todos
```

## Présentation de ce projet 

Cette stack déploie :
- `backend` (Node/Express)
- `frontend` (image GHCR `ghcr.io/wololobzh/todolist-frontend:latest`)
- `nginx` (reverse proxy)
- HTTPS par **défaut en auto-signé** (fonctionne de suite sur l'IP, avec avertissement navigateur)
- Profil **Let's Encrypt** prêt à l'emploi (cron toutes les 12h) pour un **domaine**

> ℹ️ Let's Encrypt **n'émet pas de certificats pour les adresses IP**.
> Pour un vrai certificat reconnu, ajoute un domaine (A record) vers `51.254.205.63`,
> puis suis la section **"Activer Let's Encrypt"**.

---

## 🚀 Déploiement initial (HTTP/HTTPS auto-signé)

Sur ton VPS (Ubuntu):
```bash
ssh ubuntu@51.254.205.63
sudo apt update && sudo apt install -y docker.io docker-compose git openssl
sudo mkdir -p /var/www
cd /var/www
sudo git clone https://github.com/wololobzh/todolist-backend.git
cd todolist-backend

# Génère un certificat auto-signé pour l'IP (1ère fois uniquement)
sudo bash generate-selfsigned.sh

# Lance la stack
sudo docker compose up -d
```

Accès:
- Frontend: https://51.254.205.63/
- API: https://51.254.205.63/api/todos

(Le navigateur affichera un avertissement car c'est un certificat auto-signé.)

---

## 🔄 CI/CD automatique (GitHub Actions)

Dans le repo GitHub **todolist-backend**, crée les secrets:
- `SERVER_HOST = 51.254.205.63`
- `SERVER_USER = ubuntu`
- `SSH_PRIVATE_KEY = <ta clé privée>`

À chaque `git push` sur `main`, le workflow déploie automatiquement sur le VPS.

---

## 🔐 Activer Let's Encrypt (avec domaine)

1) Crée un enregistrement DNS **A** de ton domaine (ex: `todolist.example.com`) vers `51.254.205.63`.
2) Modifie `nginx/nginx.conf.letsencrypt` et remplace **YOUR_DOMAIN** par ton domaine.
3) Génére le certificat et bascule la config :
```bash
export DOMAIN=todolist.example.com
export EMAIL=you@example.com
bash setup-certbot.sh
```
4) Démarre/maintien la stack avec le profil Let's Encrypt :
```bash
docker compose -f docker-compose.yml -f docker-compose.letsencrypt.yml up -d
```

Le conteneur `certbot` exécutera un **cron toutes les 12h** pour renouveler le certificat.

---

## 🧱 Architecture des conteneurs

- `backend`: service Express sur 4000
- `frontend`: image GHCR nginx statique
- `nginx`: reverse proxy TLS → route `/` vers frontend, `/api` vers backend
- `certbot` (optionnel): génération/renouvellement Let's Encrypt (profil LE)

---

## 🧪 Commandes utiles

```bash
docker compose logs -f nginx
docker compose ps
docker compose restart nginx
```

---

## ⚠️ Sécurité

- Remplace le certificat auto-signé par un vrai certificat dès que tu disposes d'un domaine.
- Garde ta clé privée SSH en sécurité et utilise des clés fortes.
