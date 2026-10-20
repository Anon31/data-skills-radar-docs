# 🌳 Conventions GitOps & Workflow

Pour garantir un historique propre, lisible et prêt pour l'intégration continue (CI/CD), ce projet respecte des standards stricts de versioning.

## 🏗️ 1. Architecture des Branches

Nous utilisons un Git Flow simplifié adapté à ce projet.

*   **`master`** : Branche de **production**. Code stable, testé et déployable.
*   **`develop`** : Branche d'**intégration**. C'est ici que les fonctionnalités sont fusionnées.

**Format des branches éphémères :** `type/contexte/description-courte` (en kebab-case)
*Exemples : `feat/dashboard/job-trends`, `fix/ui/map-responsiveness`, `chore/setup/angular-config`.*

## 🧪 2. Convention des Commits

Ce projet respecte le standard [Conventional Commits](https://www.conventionalcommits.org/).
Structure : `type(scope): description` (en minuscules).

| Type | Usage | Exemple concret |
| :--- | :--- | :--- |
| **feat** | Nouvelle fonctionnalité | `feat(map): ajout de la cartographie Leaflet` |
| **fix** | Correction de bug | `fix(duckdb): résolution de la fuite mémoire WASM` |
| **docs** | Documentation | `docs(wiki): ajout des conventions GitOps` |
| **style** | Formatage, CSS, Linting | `style(ui): harmonisation des couleurs du thème` |
| **refactor** | Amélioration code | `refactor(store): optimisation des signals Angular` |
| **chore** | Maintenance/Config | `chore(deps): mise à jour de Tailwind CSS` |

## 🏷️ 3. Catalogue des Labels GitHub (Issues & PRs)

Les tickets (Issues) et Merge Requests sont catégorisés avec les labels officiels du projet :

*   `bug` : Something isn't working.
*   `chore` : Changes to the build process or auxiliary tools.
*   `cicd` : Changes to our CI configuration files and scripts.
*   `docs` : Improvements or additions to documentation.
*   `duplicate` : This issue or pull request already exists.
*   `feature` : New feature or enhancement.
*   `fix` : Bug fix for the user or logic.
*   `major` : For major versions.
*   `question` : Further information is requested.
*   `refactor` : Code change that neither fixes a bug nor adds a feature.
*   `style` : Formatting, missing semi colons, etc.
*   `test` : Adding missing tests or correcting existing tests.