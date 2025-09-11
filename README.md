# RAS Plomberie - Site Web avec Administration Supabase

Site web professionnel pour RAS Plomberie avec système d'administration intégré et synchronisation en temps réel via Supabase.

## 🚀 Fonctionnalités

- **Site web responsive** avec design moderne
- **Mode administration** avec édition en temps réel
- **Synchronisation multi-postes** via Supabase
- **Base de données PostgreSQL** pour toutes les modifications
- **Système de contact** avec sauvegarde automatique
- **Gestion des couleurs** et du contenu
- **Interface d'administration** intuitive

## 📋 Prérequis

- Node.js (version 16 ou supérieure)
- Compte Supabase
- Base de données PostgreSQL (via Supabase)

## 🛠️ Installation

### 1. Cloner le projet
```bash
git clone [votre-repo]
cd ras-plomberie
```

### 2. Installer les dépendances
```bash
npm install
```

### 3. Configuration Supabase

#### a) Créer un projet Supabase
1. Allez sur [supabase.com](https://supabase.com)
2. Créez un nouveau projet
3. Notez votre URL et clé API

#### b) Configurer les variables d'environnement
Copiez le fichier `supabase-config.env` vers `.env` et remplissez les valeurs :

```bash
cp supabase-config.env .env
```

Modifiez le fichier `.env` :
```env
VITE_SUPABASE_URL=https://votre-projet.supabase.co
VITE_SUPABASE_ANON_KEY=votre_cle_anonyme_supabase
DATABASE_URL=postgresql://postgres:[mot-de-passe]@db.[projet].supabase.co:5432/postgres
```

### 4. Configuration de la base de données

#### a) Exécuter la migration
```bash
npm run db:migrate
```

#### b) Ou exécuter manuellement le script SQL
Connectez-vous à votre base de données Supabase et exécutez le contenu du fichier `database-schema.sql`.

### 5. Démarrer le serveur de développement
```bash
npm run dev
```

Le site sera accessible sur `http://localhost:5173`

## 🔧 Utilisation

### Mode Administration

1. **Activer le mode admin** : Cliquez 3 fois rapidement sur le titre "RAS" en haut à gauche
2. **Mot de passe** : `admin123` (ou laissez vide)
3. **Éditer le contenu** : Cliquez sur n'importe quel texte pour le modifier
4. **Modifier les images** : Cliquez sur les images pour les changer
5. **Sauvegarder** : Utilisez le bouton "💾 Sauvegarder" ou Ctrl+S

### Fonctionnalités d'administration

- **Édition de texte** : Cliquez sur n'importe quel texte pour le modifier
- **Gestion des images** : Cliquez sur les images pour les remplacer
- **Modification des couleurs** : Utilisez le panneau d'administration
- **Gestion du contact** : Modifiez téléphone et adresse
- **Suppression d'éléments** : Clic droit pour supprimer
- **Ajout de sections** : Bouton "Ajouter une section"

### Synchronisation

- **Temps réel** : Les modifications sont synchronisées instantanément sur tous les postes
- **Sauvegarde automatique** : Toutes les 60 secondes en mode admin
- **Fallback** : Si Supabase n'est pas disponible, utilise localStorage

## 📊 Structure de la base de données

### Tables principales

- `site_colors` : Couleurs du site
- `site_content` : Contenu éditable
- `site_images` : Images du site
- `contact_info` : Informations de contact
- `services` : Services proposés
- `testimonials` : Témoignages clients
- `contact_requests` : Demandes de contact

### Relations

- Toutes les tables ont des timestamps automatiques
- Système de versioning avec `updated_at`
- Index optimisés pour les performances

## 🔄 Scripts disponibles

```bash
# Développement
npm run dev

# Build de production
npm run build

# Prévisualisation du build
npm run preview

# Migration de la base de données
npm run db:migrate

# Reset complet de la base de données
npm run db:reset
```

## 🎨 Personnalisation

### Couleurs
Les couleurs sont gérées via CSS variables et la base de données :
- `--primary-blue` : Couleur principale
- `--secondary-blue` : Couleur secondaire
- `--accent-blue` : Couleur d'accent
- `--dark-blue` : Couleur sombre

### Contenu
Tout le contenu est éditable via l'interface d'administration :
- Textes
- Images
- Liens
- Informations de contact

## 🚨 Dépannage

### Problèmes courants

1. **Supabase non connecté**
   - Vérifiez les variables d'environnement
   - Vérifiez la connexion internet
   - Le site fonctionne en mode localStorage en fallback

2. **Erreurs de base de données**
   - Vérifiez que la migration a été exécutée
   - Vérifiez les permissions de la base de données

3. **Mode admin ne s'active pas**
   - Cliquez 3 fois rapidement sur "RAS"
   - Vérifiez la console pour les erreurs

### Logs
Les logs sont disponibles dans la console du navigateur (F12).

## 📱 Responsive Design

Le site est entièrement responsive et s'adapte à :
- Desktop (1200px+)
- Tablet (768px - 1199px)
- Mobile (< 768px)

## 🔒 Sécurité

- Mode admin protégé par mot de passe
- Validation côté client et serveur
- Gestion des erreurs robuste
- Fallback sécurisé vers localStorage

## 📈 Performance

- Chargement asynchrone des données
- Mise en cache intelligente
- Optimisation des images
- Code minifié en production

## 🤝 Contribution

1. Fork le projet
2. Créez une branche feature
3. Committez vos changements
4. Poussez vers la branche
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 📞 Support

Pour toute question ou problème :
- Email : contact@ras-plomberie.fr
- Téléphone : 06 22 16 74 57

---

**RAS Plomberie** - Votre expert en plomberie, chauffage et climatisation depuis plus de 15 ans.
