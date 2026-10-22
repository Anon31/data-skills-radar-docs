# 🚀 Guide de Démarrage - Data Skills Radar API

Ce document détaille la procédure de déploiement local de l'API backend (NestJS/ESM) et de son infrastructure conteneurisée.

## 1. Prérequis et Infrastructure Locale

L'environnement de développement s'appuie sur Docker pour garantir l'iso-parité avec la production. Le socle nécessite l'exécution du fichier `docker-compose.yml` situé à la racine.

```yaml
version: '3.8'
services:
  db:
    image: postgres:15-alpine
    container_name: dsr-postgres
    restart: always
    environment:
      POSTGRES_USER: dsr_admin
      POSTGRES_PASSWORD: dsr_password
      POSTGRES_DB: data_skills_radar_db
    ports:
      - "5432:5432"
    volumes:
      - dsr-postgres-data:/var/lib/postgresql/data

  pgadmin:
    image: dpage/pgadmin4
    container_name: dsr-pgadmin
    restart: always
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@dataskillsradar.com
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "5050:80"
    depends_on:
      - db

  vault:
    image: hashicorp/vault:latest
    container_name: dsr-vault
    restart: always
    ports:
      - "8200:8200"
    environment:
      VAULT_DEV_ROOT_TOKEN_ID: "root"
      VAULT_DEV_LISTEN_ADDRESS: "0.0.0.0:8200"
    cap_add:
      - IPC_LOCK

volumes:
  dsr-postgres-data:
```

**Démarrer l'infrastructure :**
```bash
docker compose up -d
```

## 2. Configuration de l'Application

Créez un fichier `.env` à la racine en vous basant sur le `.env.example`. En environnement local, ces variables assurent le fonctionnement en mode dégradé si Vault n'est pas accessible.

```env
DATABASE_URL="postgresql://dsr_admin:dsr_password@localhost:5432/data_skills_radar_db?schema=public"
JWT_SECRET="votre_cle_secrete_locale"
VAULT_ADDR="[http://127.0.0.1:8200](http://127.0.0.1:8200)"
```

## 3. Installation et Lancement

Le projet utilise les modules ECMAScript (ESM) natifs et Node.js 24+.

```bash
# Installation des dépendances
npm install

# Lancement en mode développement avec Hot-Reload
npm run start:dev
```

## 4. Tests et Documentation Interactive

L'API intègre une documentation OpenAPI 3.0 générée dynamiquement, ainsi qu'une collection d'environnement Postman préconfigurée.

*   **Swagger UI (Local) :** [http://localhost:3000/api/v1](http://localhost:3000/api/v1)
*   **Collection Postman :** Configurez la variable d'environnement `{{base_url}}` sur `http://localhost:3000/api/v1`. Un script de test est intégré sur la route `POST /auth/login` pour capturer automatiquement le `access_token` et l'injecter dans la variable globale `jwt_token`, déverrouillant ainsi les routes protégées par rôle (ADMIN, USER).