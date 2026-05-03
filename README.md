# 💬 TeenChat

A modern teen-focused social chat web application built with Flutter, featuring a **Frutiger Aero** aesthetic — glassmorphism, vibrant gradients, smooth animations, and a floating navigation bar.

---

## ✨ Features

- **Check-in** — Log your feelings to track your mood on a calendar
- **Feed** — Browse and interact with posts from peers
- **Post** — Create and share posts with tags
- **Find Friends** — Discover and connect with other users
- **Profile** — Manage your username, personal info, posts, and favorites
- **Frutiger Aero UI** — Glassmorphism cards, animated transitions, and polished micro-interactions

---

## Prerequisites

Make sure you have the following installed before running the app:

| Tool | Version | Download |
|------|---------|----------|
| **Flutter SDK** | `^3.x` (Dart SDK `^3.11.5`) | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| **Dart SDK** | Included with Flutter | — |
| **Chrome** *(for web)* | Latest | [google.com/chrome](https://www.google.com/chrome/) |
| **Android Studio** *(for Android emulator)* | Latest | [developer.android.com/studio](https://developer.android.com/studio) |
| **Xcode** *(for iOS, macOS only)* | Latest | Mac App Store |

> **Verify your Flutter setup** by running:
> ```bash
> flutter doctor
> ```
> All checkmarks should be green for your target platform.

---

## Getting Started

### 1. Clone the repository

```bash
git clone <https://github.com/Ni-Kyu/TeenChatAppUI.git>
cd flutter_application_1
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

#### Web (Chrome) — Recommended for quick preview
```bash
flutter run -d chrome
```

#### Android (emulator or physical device)
```bash
flutter run -d android
```

#### Windows desktop
```bash
flutter run -d windows
```

#### List all available devices
```bash
flutter devices
```

---

## Dependencies

| Package | Purpose |
|---------|---------|
| `connectivity_plus` | Detect online/offline status |
| `uuid` | Generate unique IDs for posts & comments |
| `flutter_animate` | Smooth micro-animations |

---

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models
│   ├── post.dart
│   ├── comment.dart
│   ├── user_profile.dart
│   ├── peer_profile.dart
│   └── mood_entry.dart
├── screens/               # Full-page screens
│   ├── home_screen.dart
│   ├── feed_screen.dart
│   ├── post_screen.dart
│   ├── profile_screen.dart
│   └── find_friends_screen.dart
├── state/                 # App state management
├── theme/                 # Color palette & theme tokens
└── widgets/               # Reusable UI components
```

---

## Running Tests

```bash
flutter test
```

---

## Build for Production

#### Android APK
```bash
flutter build apk --release
```

#### Web
```bash
flutter build web --release
```

#### Windows
```bash
flutter build windows --release
```
