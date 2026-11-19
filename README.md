# 🎯 Data Skills Radar - Documentation Centrale

[![Accès au Portail Web](https://img.shields.io/badge/📖_Portail_Web-Cliquez_ici-181717?style=for-the-badge&logo=github&color=007ec6)](https://docs.dataskills.thomasnoel.dev/#/)

Welcome to the centralized documentation repository for the **Data Skills Radar** project.
This repository contains the Architecture Decision Records (ADRs), system designs, scientific protocols, and operational runbooks (MCO) for the entire Decision Support System (DSS / SID).

> **🇫🇷 Language Policy:** All internal documentation, architectural schemas, guides, and Git commit messages are written in **French** to align with the academic and business context of this project (French labor market Open Data).

## 🏗️ Ecosystem Architecture

The **Data Skills Radar** project is split into 4 micro-repositories to ensure clear separation of concerns:

- 🎨 **[Frontend UI (`data-skills-radar-app`)](https://github.com/Anon31/data-skills-radar-app):** Angular 22 (Zoneless, Signals, `httpResource`) + Tailwind CSS v4 + PrimeNG 22 + Apache ECharts application acting as the Business Intelligence dashboard (`https://app.dataskills.thomasnoel.dev`).
- ⚙️ **[Backend API (`data-skills-radar-api`)](https://github.com/Anon31/data-skills-radar-api):** NestJS 12 modular application coupling PostgreSQL 16 (Prisma 7 OLTP), HashiCorp Vault 1.15 (Shamir & AppRole Zero-Trust), and DuckDB In-Process (Zero-ETL OLAP) (`https://api.dataskills.thomasnoel.dev`).
- 🐘 **[Data Lakehouse (`data-skills-radar-lakehouse`)](https://github.com/Anon31/data-skills-radar-lakehouse):** Python 3.12 / PySpark / SciPy infrastructure for Big Data ingestion (Redpanda + OAuth2 bots) and Medallion processing (`Bronze → Silver → Gold`) on OVHcloud Object Storage S3 (`Gravelines 1-AZ`).
- 📖 **Documentation (This repository):** Powered by Docsify and containerized with Nginx Alpine (`https://docs.dataskills.thomasnoel.dev`) to serve as the unified technical portal.

```mermaid
graph TD
    %% PALETTE DE COULEURS VIBRANTES
    classDef source fill:#ef4444,stroke:#b91c1c,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef ingest fill:#3b82f6,stroke:#1d4ed8,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef stream fill:#ec4899,stroke:#be185d,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef storage fill:#f59e0b,stroke:#b45309,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef compute fill:#8b5cf6,stroke:#6d28d9,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef serving fill:#10b981,stroke:#047857,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef api fill:#f97316,stroke:#c2410c,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef front fill:#06b6d4,stroke:#0e7490,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef doc fill:#4b5563,stroke:#1f2937,stroke-width:3px,stroke-dasharray: 5 5,color:#ffffff,font-weight:bold;

    subgraph "1. Sources de Donnees (Quintuor Open Data)"
        S1[("📊 URSSAF - Acoss\n(Effectifs & Masse Salariale Y)")]:::source
        S3[("🏢 INSEE Base SIRENE V4\n(Stock Parquet 2 Go & API)")]:::source
        S4[("🌍 OCDE & Rapports IA\n(Indice Capacites CGj)")]:::source
        S2(("🌐 APIs France Travail\n(Offres v2, ROME 4.0, ROMEO)")):::source
    end

    subgraph "2. Ingestion Hybride Lambda (Python)"
        Bot["🤖 Bots Python (Batch)\nColumn Pruning & Throttling"]:::ingest
        StreamBot["🤖 Producteur Python (OAuth2)\nCollecte Continue"]:::ingest
        Redpanda["🦝 Redpanda (Docker sans JVM)\nTopic : raw.job.offers"]:::stream
    end

    subgraph "3. Data Lakehouse Cloud (OVH Object Storage S3 - Gravelines 1-AZ)"
        OVHS3[("☁️ OVH Object Storage S3\ndsr-bronze-s3 | dsr-silver-s3 | dsr-gold-s3")]:::storage
        Iceberg["🧊 Apache Parquet & Iceberg\n(Architecture Medallion ACID)"]:::storage
    end

    subgraph "4. Traitement, NLP & Statistiques (Couche Compute)"
        Spark["⚡ PySpark & SciPy\nScore SDSS, Score IA (X) & Tests Shapiro/Kruskal"]:::compute
    end

    subgraph "5. Moteur Analytique (Monde OLAP)"
        Duck["🦆 DuckDB (In-Process Zero-ETL)\nColumn Pruning & Predicate Pushdown"]:::serving
    end

    subgraph "6. Backend & Securite Zero-Trust (Monde OLTP - VPS OVH)"
        API["⚙️ API NestJS (Modulaire)\nGuards JWT & RBAC"]:::api
        PG[("🐘 PostgreSQL 16 & Prisma 7\n(Utilisateurs / Tunnel SSH)")]:::api
        Vault["🛡️ HashiCorp Vault 1.15\n(Shamir & AppRole M2M)"]:::api
    end

    subgraph "7. Restitution & Reverse Proxy (Frontend)"
        UI["🎨 Angular 22 Zoneless\n(Signals, PrimeNG 22, ECharts)\nNginx SSL Zero-CORS"]:::front
    end

    subgraph "8. Gouvernance, CI/CD & Docs-as-Code"
        Doc["📚 Portail Docsify & GitHub Actions\n(docs.dataskills.thomasnoel.dev)"]:::doc
    end

    %% Flux Ingestion Batch & Streaming
    S1 -->|Series trimestrielles NA38/NA88| Bot
    S3 -->|Stock Parquet & Delta API| Bot
    S4 -->|Matrice metiers SOC/ISCO| Bot
    Bot -->|Archivage Raw Append-Only| OVHS3

    S2 -->|Flux Offres & Competences| StreamBot
    StreamBot -->|Push Event| Redpanda
    Redpanda -->|Consommation Streaming| Spark

    %% Raffinage Medallion Lakehouse
    OVHS3 -->|Gouvernance des tables| Iceberg
    Iceberg -->|Lecture Bronze / Silver| Spark
    Spark -->|Ecriture Parquet Silver & Gold| Iceberg

    %% Moteur Analytique Zero-ETL
    Iceberg -->|Lecture directe Couche Gold (dsr-gold-s3)| Duck

    %% API comme Chef d'Orchestre
    UI -->|HTTPS /api/v1 (Zero-CORS)| API
    API -->|Pool natif pg & Prisma 7| PG
    API -.->|Auth AppRole (RoleID/SecretID) en RAM| Vault
    API -->|Requetes SQL Analytiques| Duck

    %% Gouvernance & Documentation
    Doc -.->|Documente & Deploie (GHCR / SSH)| API
    Doc -.->|Documente & Deploie (GHCR / SSH)| UI
    Doc -.->|Documente ADR & Protocole Statistique| Spark
```

## 🎯 Purpose of this Repository

Instead of scattering our documentation across multiple repositories, this dedicated space allows us to:
1. Maintain a single source of truth for our global data models (MCD/MLD), Architecture Decision Records (`ADR-001` to `ADR-008`), domain glossary, and statistical protocols.
2. Document our sovereign cloud infrastructure on **OVHcloud Gravelines** (VPS-3 Ubuntu 26.04 LTS, 3 S3 buckets `dsr-bronze-s3` / `dsr-silver-s3` / `dsr-gold-s3`, HashiCorp Vault Shamir/AppRole, SSH tunnels, Nginx SSL reverse proxy).
3. Host our CI/CD pipelines, GitHub Rulesets governance, and operational runbooks (MCO).

## ⚖️ License
This project is licensed under the MIT License.
