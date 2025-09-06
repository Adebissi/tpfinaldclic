
# 🌍 Benin Culture Hub

**Benin Culture Hub** est une application mobile développée avec **Flutter** pour célébrer et explorer la richesse de la culture béninoise. Elle propose une découverte des événements culturels, une timeline historique interactive et une galerie d'œuvres d'art. Compatible avec **Android** et **iOS**, elle utilise **Firebase** pour la gestion des données.

📌 **Lien du dépôt** : https://github.com/Adebissi/tpfinaldclic*

---

## 🚀 Installation

### Prérequis
Avant de commencer, assurez-vous d'avoir les outils suivants :
- **Flutter SDK** : Version 3.x ou supérieure (`flutter doctor` pour vérifier).
- **Android Studio** ou **Xcode** : Configuré avec les SDK pour Android ou iOS.
- **Java 8** : Nécessaire pour les builds Android (configurez `JAVA_HOME` si besoin, ex. : `export JAVA_HOME=/path/to/jdk8`).
- **Compte Firebase** : Pour Firestore et Storage.

### Étapes d'installation
1. **Cloner le dépôt** :
   ```bash
   git clone [Lien vers le dépôt Git]
   cd beninculturehub
   ```

2. **Installer les dépendances** :
   ```bash
   flutter pub get
   ```

3. **Configurer Firebase** :
   - Créez un projet sur la [Firebase Console](https://console.firebase.google.com/).
   - Activez **Firestore**
   - Téléchargez :
     - `google-services.json` (Android) → Placez-le dans `android/app/`.
     - `GoogleService-Info.plist` (iOS) → Placez-le dans `ios/Runner/`.
   - Exécutez `flutterfire configure` pour générer `lib/firebase_options.dart` (si FlutterFire CLI est installé).

4. **Configurer les permissions** :
   - **Android** (`android/app/src/main/AndroidManifest.xml`) :
     ```xml
     <uses-permission android:name="android.permission.CAMERA" />
     <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
     <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
     <uses-feature android:name="android.hardware.camera" android:required="true" />
     ```
   - **iOS** (`ios/Runner/Info.plist`) :
     ```xml
     <key>NSCameraUsageDescription</key>
     <string>Accès à la caméra pour capturer des photos d'œuvres d'art.</string>
     <key>NSPhotoLibraryAddUsageDescription</key>
     <string>Permission pour sauvegarder des photos dans votre bibliothèque.</string>
     <key>NSPhotoLibraryUsageDescription</key>
     <string>Accès à la bibliothèque pour afficher des images.</string>
     ```

5. **Configurer l'icône de l'application** (optionnel) :
   - Placez `logo.png` dans `assets/images/`.
   - Mettez à jour `pubspec.yaml` :
     ```yaml
     flutter:
       assets:
         - assets/images/logo.png
     flutter_launcher_icons:
       android: true
       ios: true
       image_path: "assets/images/logo.png"
     ```
   - Exécutez :
     ```bash
     flutter pub run flutter_launcher_icons:main
     ```

6. **Lancer l'application** :
   - Vérifiez les appareils connectés : `flutter devices`
   - Lancez sur Android : `flutter run --device-id [ID de l'appareil]`
   - Lancez sur iOS : `flutter run --device-id [ID du simulateur]`
   - Générez un APK : `flutter build apk --release`
   - Générez un App Bundle : `flutter build appbundle --release`

---

## 📱 Utilisation

### Navigation
L'application utilise une **BottomNavigationBar** pour naviguer entre les sections :
- 🏠 **Accueil** : Vue générale avec un banner et des teasers.
- 🎉 **Événements** : Liste des événements culturels.
- 📜 **Histoire** : Timeline interactive des périodes historiques.
- 🖼️ **Galerie** : Grille d'œuvres d'art.

### Fonctionnalités principales
1. **Accueil** :
   - Affiche un banner promotionnel (ex. : "Festival Vodun").
   - Cliquez sur les teasers ("Histoire du Dahomey", "Bronzes du Bénin") pour naviguer.

2. **Événements** :
   - 🔍 Recherchez par titre ou description.
   - 📍 Filtrez par localisation.
   - ➕ Ajoutez un événement via l'icône "+" (formulaire avec prise de photo).
   - Cliquez sur un événement pour voir les détails (image, description, favoris, partage).

3. **Histoire** :
   - ⏳ Parcourez une timeline horizontale des événements historiques.
   - ➕ Ajoutez un événement historique via l'icône "+".
   - Cliquez pour voir les détails (image, période, description).
   - 🎓 Testez vos connaissances avec le bouton "Quiz" (fonctionnalité à implémenter).

4. **Galerie** :
   - 🖼️ Explorez une grille 2x2 d'œuvres d'art.
   - ➕ Ajoutez une œuvre via l'icône "+" (formulaire avec caméra).
   - Cliquez pour zoomer sur une œuvre (titre, artiste, description).

5. **Ajout de contenu** :
   - 📸 Utilisez la caméra pour capturer des photos (via l'icône "+" ou caméra).
   - Remplissez les champs (titre, description, lieu, etc.) et enregistrez dans Firestore.



### Notes importantes
- Les images sont stockées localement (chemin enregistré dans Firestore).
- Une image par défaut (`default_event.jpg`) est utilisée si aucune photo n'est fournie.
- Vérifiez que les permissions de caméra et stockage sont accordées.

---

## 🛠️ Dépendances principales
- `cloud_firestore` : Gestion des données en temps réel.
- `camera` : Capture de photos.
- `path_provider`, `permission_handler` : Gestion des fichiers et permissions.
- `photo_view` : Zoom sur les images dans la galerie.
- `flutter_launcher_icons` : Génération des icônes d'application.

