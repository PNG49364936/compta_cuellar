# Home Compta

Application Rails de gestion comptable domestique avec formulaire de saisie de données et possibilité de générer, afficher et imprimer des états comptables. Sauvegarde en base de données. L'application est responsive (tablette et mobile).

## Technologies

- Rails 7.1.6
- Ruby 3.2.2
- SQLite (développement) — migration vers PostgreSQL/Neon prévue pour déploiement Render
- Hotwire (Turbo + Stimulus)
- Tailwind CSS v4 (via tailwindcss-rails)
- Importmap (pas de Node.js/npm)
- Devise 5.0.2 (authentification)
- Déploiement prévu via Render

## Authentification

L'application est mono-utilisateur. Authentification avec Devise (un seul compte, pas d'inscription publique — :registerable désactivé). Le compte administrateur est créé via `seeds.rb` :
- Email : pngauthier@hotmail.fr
- Mot de passe : Alba2023@@@

## Devise monétaire

Tous les montants sont en euros (€).

---

## Organisation des opérations

Les opérations sont classées par **catégories** et **sous-catégories**. Chaque opération est soit un **débit (−)** soit un **crédit (+)**.

### Catégories de dépenses (débit)

**Catégorie 1 — Piso**
Sous-catégories : Comunidad, Gas, Agua, Electricidad, IBI, Seguros, Mantenimiento, Otros gastos.

**Catégorie 2 — Cochera**
Sous-catégories : Comunidad, Agua, Electricidad, IBI, Seguros, Mantenimiento, Otros gastos.

**Catégorie 3 — Madre**
Sous-catégories : Logopeda, Peluquería, Podólogo, Bollos, Begoña, Otros gastos.

**Catégorie 4 — Residencia**
Sous-catégories : Frais résidence, Otros gastos.

### Catégorie de revenus (crédit)

**Catégorie 5 — Ingresos**
Sous-catégories : Pensión, Transferencias, Otros ingresos.

> **Règle :** Les catégories 1 à 4 sont des débits (−). La catégorie 5 est un crédit (+).

---

## Modèle de données

- **User** : email, mot de passe (géré par Devise).
- **Category** : nom (string), type d'opération (debit ou credit). Scopes : `debits`, `credits`. Méthodes : `debit?`, `credit?`.
- **Subcategory** : nom (string), référence vers Category (`belongs_to :category`). Suppression protégée si opérations rattachées.
- **Operation** : montant (decimal, precision 10, scale 2), date de paiement (date), observation (string, 80 caractères max), timestamps. `belongs_to :category`, `belongs_to :subcategory`. `default_scope { order(payment_date: :desc) }`. Méthode `signed_amount`.

---

## Seed (données pré-chargées)

Le fichier `db/seeds.rb` crée :

1. Le compte utilisateur (pngauthier@hotmail.fr / Alba2023@@@).
2. Les 5 catégories avec leur type (debit ou credit).
3. Les 26 sous-catégories associées.

Utilise `find_or_create_by!` pour être idempotent.

---

## Structure des pages

### Landing page (DashboardController#index)

- Solde global (total crédits − total débits) avec montants DM Mono.
- 3 boutons d'action : Nouvelle opération, Catégories, Comptes.
- 10 dernières opérations (catégorie, sous-catégorie, montant, date).

### Formulaire de création de catégories et sous-catégories (CategoriesController)

- Liste des catégories regroupées par type (débit/crédit) avec sous-catégories en pills.
- Ajout de catégorie inline (nom + type).
- Ajout de sous-catégorie inline sous chaque catégorie.
- Suppression protégée : impossible si des opérations sont rattachées (message d'erreur explicite).

### Formulaire de création d'une opération (OperationsController)

- **Catégorie** : menu déroulant.
- **Sous-catégorie** : menu déroulant dynamique via Stimulus (`subcategory_select_controller.js`), rechargé via fetch `/subcategories_for_category/:id`.
- **Montant** : champ numérique (DM Mono).
- **Date de paiement** : champ date (défaut = aujourd'hui).
- **Observation** : texte libre (80 caractères max).
- Après création → page show avec boutons : Nouvelle opération, Modifier, Supprimer (avec confirmation), Retour extraction (si vient de l'extraction), Accueil.

### Extraction des comptes (ExtractionsController)

**Formulaire de filtres (method: GET pour compatibilité Turbo) :**
- **Année** : menu déroulant.
- **Mois** : cases à cocher avec "Tous les mois" (coché par défaut). Géré par Stimulus (`extraction_filter_controller.js`).
- **Catégories** : séparées en deux pavés visuels :
  - **Pavé Dépenses** (bordure gauche rouge) : Piso, Cochera, Madre, Residencia.
  - **Pavé Revenus** (bordure gauche verte) : Ingresos.
- **Sous-catégories** : apparaissent dynamiquement sous chaque catégorie cochée, avec "Toutes les sous-catégories" coché par défaut.
- Si aucune catégorie cochée → toutes les opérations affichées.

**Résultats :**
- Résumé : total débits, total crédits, solde.
- Total par catégorie.
- Total par mois.
- Tableau des opérations (desktop) / Cartes (mobile) — cliquables vers le détail.
- Bouton « Imprimer » (Stimulus `print_controller.js`).
- Bouton « Retour à l'extraction » sur la page détail (paramètre `from_extraction` dans l'URL).

---

## Design system

Design identique au projet `/Users/pierrenoelgauthier/documents/png/check_my_tension`.

- **Palette** : forest (#1a3a2e), sage (#7aad8f), cream (#f7f3ec), coral (#e05c4b), amber (#d4933a).
- **Typographie** : Playfair Display (titres), Source Serif 4 (texte), DM Mono (montants).
- **Composants** : cards avec shadow, badges débit/crédit, boutons avec hover elevation, flash messages stylisés, animations fadeUp/slideDown, texture grain SVG.
- **CSS** : fichier `app/assets/stylesheets/custom.css` (~700 lignes).

## Responsive

- **Mobile (≤768px)** : menu hamburger (Stimulus `mobile_nav_controller.js`), grids en 1 colonne, tableau extraction remplacé par cartes, zones tactiles checkboxes agrandies.
- **Petit mobile (≤480px)** : padding réduit, boutons pleine largeur empilés, solde compact.
- **Print** : masque header/nav/boutons, fond blanc, couleurs débit/crédit préservées.

## Stimulus controllers

- `subcategory_select_controller.js` : rechargement dynamique des sous-catégories dans le formulaire opération.
- `extraction_filter_controller.js` : gestion des cases à cocher mois/catégories/sous-catégories dans l'extraction.
- `print_controller.js` : impression via `window.print()`.
- `mobile_nav_controller.js` : menu hamburger mobile.

## Routes principales

```
root → dashboard#index
resources :operations (CRUD complet)
resources :categories (CRUD) avec nested subcategories (create, destroy)
get extractions → extractions#index
get extractions/results → extractions#results
get subcategories_for_category/:category_id → subcategories#for_category (JSON)
devise_for :users
```

---

Ne pas faire de commit GIT
