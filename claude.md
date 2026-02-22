# Home Compta

Application Rails de gestion comptable domestique avec formulaire de saisie de données et possibilité de générer, afficher et imprimer des états comptables. Sauvegarde en base de données. L'application devra être responsive (tablette et mobile).

## Technologies

- Rails 7.1.6
- Ruby 3.2.2
- PostgreSQL
- Hotwire
- Tailwind CSS
- Stimulus (si nécessaire)
- Déploiement via Render

## Authentification

L'application est mono-utilisateur. Authentification simple avec Devise (un seul compte, pas d'inscription publique). Le compte administrateur sera créé via `seeds.rb` (email et mot de passe par défaut à définir).

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
- **Category** : nom (string), type d'opération (débit ou crédit).
- **Subcategory** : nom (string), référence vers Category (`belongs_to :category`).
- **Operation** : montant (decimal, précision 2), date de paiement (date), observation (string, 80 caractères max), date de création (timestamp automatique), référence vers Category (`belongs_to :category`), référence vers Subcategory (`belongs_to :subcategory`).

---

## Seed (données pré-chargées)

Le fichier `db/seeds.rb` devra créer :

1. Le compte utilisateur par défaut (email / mot de passe à définir).
2. Les 5 catégories listées ci-dessus avec leur type (débit ou crédit).
3. Toutes les sous-catégories associées à chaque catégorie.

---

## Landing page

- Bouton vers le formulaire de saisie des dépenses / ingresos.
- Bouton vers le formulaire de création de nouvelles catégories et sous-catégories (voir section dédiée ci-dessous).
- Bouton vers le formulaire d'extraction de comptes (dépenses ou ingresos).
- Affichage des 10 dernières opérations créées (catégorie, sous-catégorie, montant, date de paiement, observation).
- Affichage du **solde global** (total crédits − total débits).

---

## Formulaire de création de catégories et sous-catégories

Ce formulaire permet d'ajouter de nouvelles catégories ou sous-catégories.

Champs :
- **Catégorie** : nom de la catégorie (texte).
- **Sous-catégorie** : nom de la sous-catégorie (texte), rattachée à une catégorie existante (menu déroulant).
- **Type** : choix entre « Dépense » (débit) et « Ingresos » (crédit).
- **Commentaire** : champ texte libre.

Les catégories et sous-catégories peuvent être **modifiées** ou **supprimées** uniquement si aucune opération n'y est rattachée. Si des opérations existent, afficher un message d'erreur explicite.

---

## Formulaire de création d'une opération (dépense / ingreso)

- **Catégorie** : menu déroulant. Si « Ingresos » est sélectionné, l'opération est automatiquement un crédit (+), sinon un débit (−).
- **Sous-catégorie** : menu déroulant dépendant de la catégorie sélectionnée (relation parent-enfant, rechargement dynamique via Hotwire/Stimulus).
- **Montant** : champ numérique (décimal, 2 chiffres après la virgule).
- **Date de paiement** : champ date.
- **Observation** : champ texte (80 caractères maximum).
- **Bouton de validation**.

Comportement :
- La **date de création** est enregistrée automatiquement.
- Chaque enregistrement est classé en base de données par **date de paiement**.
- Après création, affichage de la fiche de l'opération (page show) avec les boutons suivants :
  - « Nouvelle opération » (retour au formulaire de saisie vierge).
  - « Modifier » (édition de l'opération).
  - « Supprimer » (avec confirmation avant suppression).
  - « Accueil » (retour à la landing page).

---

## Affichage / extraction des comptes

L'utilisateur dispose de **filtres combinables** pour consulter les opérations :

- **Année** : menu déroulant (sélection obligatoire). Les années sont générées dynamiquement à partir des opérations existantes en base.
- **Mois** : possibilité de sélectionner un seul mois ou plusieurs mois au sein de l'année choisie.
- **Catégorie** : possibilité de sélectionner une ou plusieurs catégories.
- **Sous-catégorie** : possibilité de sélectionner une ou plusieurs sous-catégories.

> **Toutes les combinaisons de filtres doivent être possibles.**

### Rendu de l'extraction

- Présentation sous forme de **tableau HTML structuré** (style tableur amélioré avec Tailwind CSS).
- Chaque ligne du tableau est **cliquable** pour afficher le détail complet de l'opération.
- Le tableau affiche :
  - **Total par catégorie**.
  - **Total par mois**.
  - **Total général**.
  - **Solde** (crédits − débits) pour la période filtrée.
- Bouton **« Imprimer »** (impression via le navigateur).

#### Front-end
Design : appliquer design front-end identique à /Users/pierrenoelgauthier/documents/png/check_my_tension

Ne pas faire de commit GIT