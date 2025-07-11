# Pomodoro App

Une application de gestion du temps basée sur la méthode Pomodoro, développée avec **Flutter**, **Supabase** et les **notifications locales**, optimisée pour **desktop** (Windows/Linux/macOS).

---

##  Fonctionnalités

- Authentification utilisateur via Supabase  
- Enregistrement des sessions (focus, pause courte, pause longue) dans Supabase  
- Redimensionnement et gestion de la fenêtre sur desktop avec `window_manager`  
- Notifications locales (fin de session) avec `flutter_local_notifications`  
- Historique de sessions enregistré et consultable  
- Interface sombre & responsive  

---

## Installation

### Pré-requis

- [Flutter SDK](https://flutter.dev/docs/get-started/install) `>=3.1.0`
- [Supabase project](https://supabase.io)
- Visual Studio 

### Dépendances

Installe les packages Flutter nécessaires :

```bash
flutter pub get
```

### Lancer l'application sur desktop (Windows)

```bash
flutter run -d windows
```


## Build de l'application (Windows)

```bash
build/windows/runner/Release/pomodoro.exe
```

## Auteur

Thomas Iafrate
