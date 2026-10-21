# 🎯 Data Skills Radar - Documentation Centrale

[![Accès au Portail Web](https://img.shields.io/badge/📖_Portail_Web-Cliquez_ici-181717?style=for-the-badge&logo=github&color=007ec6)](https://anon31.github.io/data-skills-radar-docs/#/)

Welcome to the centralized documentation repository for the Data Skills Radar project.
This repository contains the architecture decisions (ADRs), system designs, and global technical guidelines for the entire Decision Support System (DSS).

> **🇫🇷 Language Policy:** All internal documentation, architectural schemas, and guides are written in French to align with the academic and business context of this project.

## 🏗️ Ecosystem Architecture

The Data Skills Radar project is split into several micro-repositories to ensure clear separation of concerns:

- 🎨 **[Frontend UI (`data-skills-radar-app`)](https://github.com/Anon31/data-skills-radar-app):** Angular application acting as the Business Intelligence dashboard.
- ⚙️ **[Backend API (`data-skills-radar-api`)](https://github.com/Anon31/data-skills-radar-api):** NestJS application implementing Hexagonal Architecture to secure data access and manage users.
- 🐘 **[Data Lakehouse (`data-skills-radar-lakehouse`)](https://github.com/Anon31/data-skills-radar-lakehouse):** Python/PySpark infrastructure for Big Data ingestion and processing.
- 📖 **Documentation (This repository):** Powered by Docsify (Upcoming) to serve as the unified technical portal.

```mermaid
graph TD
%% NOUVELLES COULEURS VIBRANTES
    classDef source fill:#ef4444,stroke:#b91c1c,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef ingest fill:#3b82f6,stroke:#1d4ed8,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef stream fill:#ec4899,stroke:#be185d,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef storage fill:#f59e0b,stroke:#b45309,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef compute fill:#8b5cf6,stroke:#6d28d9,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef serving fill:#10b981,stroke:#047857,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef api fill:#f97316,stroke:#c2410c,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef front fill:#06b6d4,stroke:#0e7490,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef doc fill:#4b5563,stroke:#1f2937,stroke-width:3px,stroke-dasharray: 5 5,color:#ffffff,font-weight:bold;

    subgraph "1. Sources de Donnees (Open Data)"
        S1[("📊 URSSAF - Acoss")]:::source
        S3[("🏢 Base SIRENE")]:::source
        S2(("🌐 API France Travail")):::source
    end

    subgraph "2. Ingestion Hybride (Batch & Streaming)"
        Bot["🤖 Bots Python (Cron Jobs)"]:::ingest
        StreamBot["🤖 Bot Python (Ecoute Continue)"]:::ingest
        Redpanda["🦝 Redpanda (Event Streaming)"]:::stream
    end

    subgraph "3. Data Lakehouse (Couche Stockage)"
        MinIO[("🪣 MinIO S3 (Fichiers Bruts)")]:::storage
        Iceberg["🧊 Apache Iceberg (Gouvernance)"]:::storage
    end

    subgraph "4. Traitement & ML (Couche Compute)"
        Spark["⚡ PySpark (Batch & Streaming)"]:::compute
    end

    subgraph "5. Moteur Analytique (Monde OLAP)"
        Duck["🦆 DuckDB (Moteur Zero-ETL)"]:::serving
    end

    subgraph "6. Backend & Securite (Monde OLTP)"
        API["⚙️ API NestJS (Hexagonal)"]:::api
        PG[("🐘 PostgreSQL (Utilisateurs/RBAC)")]:::api
        Vault["🛡️ HashiCorp Vault (Secrets)"]:::api
    end

    subgraph "7. Restitution (Frontend)"
        UI["🎨 Angular (Dashboard BI)"]:::front
    end

    subgraph "8. Gouvernance & MLOps"
        Doc["📚 Docsify (Doc centralisee)"]:::doc
    end

%% Flux Ingestion
    S1 -->|Extraction mensuelle| Bot
    S3 -->|Telechargement CSV massif| Bot
    Bot -->|Ingestion Raw| MinIO

    S2 -->|Appel API temps reel| StreamBot
    StreamBot -->|Push Event| Redpanda
    Redpanda -->|Consommation flux continu| Spark

%% Lakehouse
    MinIO -->|Lecture Schema on Read| Iceberg
    Iceberg -->|Lecture historique| Spark
    Spark -->|Ecriture Parquet synchronisee| Iceberg
    Spark -.->|Entrainement Modele NLP| Spark

%% API comme Chef d'Orchestre
    UI -->|Requetes HTTP / REST| API
    API -->|Authentification & ORM Prisma| PG
    API -.->|Recuperation des tokens| Vault
    API -->|Requetes SQL Connector| Duck

%% Moteur Analytique
    Iceberg -->|Lectures natives| Duck

%% Documentation
    Doc -.->|Documente| API
    Doc -.->|Documente| UI
    Doc -.->|Documente| Spark
```

## 🎯 Purpose of this repository

Instead of scattering our documentation across multiple repositories, this dedicated space allows us to:
1. Maintain a single source of truth for our global data models (MCD/MLD) and sequence diagrams.
2. Document our infrastructure setup (VPS, Docker Swarm/Compose).
3. Host our CI/CD guidelines and GitOps strategies.

## ⚖️ License
This project is licensed under the MIT License.