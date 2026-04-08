# AC Trophies

Visualisation de la progression des trophées PlayStation sur la franchise Assassin's Creed au fil du temps.

Deux courbes :
- **Trophées disponibles** - augmente à chaque sortie de jeu ou DLC
- **Trophées obtenus** - augmente à chaque trophée gagné

## Prérequis

- Ruby 4.0+
- Bundler
- Un token NPSSO PlayStation (voir plus bas)

## Installation

```sh
bundle install
bin/rails db:create db:migrate db:seed
```

## Configuration

Copier `.env.example` vers `.env` et y renseigner son token NPSSO :

```sh
cp .env.example .env
```

Le token NPSSO se récupère en se connectant sur https://ca.account.sony.com/api/v1/ssocookie. Il expire au bout d'environ 60 jours.

## Utilisation

### Synchroniser les trophées

```sh
bin/rails sync_trophies
```

Récupère les trophées obtenus via l'API PlayStation et les stocke en base.

### Voir le graphique

```sh
bin/rails s
```

Puis ouvrir http://localhost:3000.

### Exporter en HTML statique

```sh
bin/rails export
```

Génère `docs/index.html`, un fichier autonome hébergeable sur GitHub Pages.

## Données des jeux

Les jeux, DLCs, dates de sortie et nombres de trophées sont définis dans `config/games.yml`. Chaque entrée est identifiée par son `psn_communication_id` (champ `npCommunicationId` de l'API PlayStation).

Pour ajouter un jeu ou corriger des données, modifier ce fichier puis relancer `bin/rails db:seed`.
