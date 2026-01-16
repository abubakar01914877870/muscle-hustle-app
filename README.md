# Muscle Hustle - Flutter Mobile App

A cross-platform mobile fitness tracking application built with Flutter, featuring offline-first architecture and seamless background synchronization.

## Features

### Offline-First Architecture
- ✅ **Instant app launch** - All data cached locally
- ✅ **Works without internet** - Full functionality offline
- ✅ **Background sync** - Automatic data synchronization when online
- ✅ **Handles server cold-start** - No waiting for free-tier server wake-up

### Core Features
- 🔐 **Authentication** - JWT-based secure login/registration
- 💪 **Workout Tracking** - Schedule and log workouts
- 🏋️ **Exercise Library** - Comprehensive exercise database
- 📊 **Progress Tracking** - Weight, measurements, photos
- 🥗 **Diet Plans** - 7-day meal planning
- 📈 **Charts & Analytics** - Visualize your fitness journey

## Technology Stack

### Mobile Framework
- **Flutter** 3.38.7 - Cross-platform UI framework
- **Dart** 3.10.7 - Programming language

### State Management
- **Riverpod** 2.6.1 - Reactive state management
- **Riverpod Annotations** - Code generation for providers

### Local Database
- **Drift** 2.28.2 - Type-safe SQLite wrapper
- **SQLite3** - Local data storage
- 8 tables: Users, Workouts, Exercises, Progress, Diet Plans, Sync metadata

### Networking
- **Dio** 5.7.0 - HTTP client with retry logic
- **JSON Serialization** - API data handling

### Background Processing
- **WorkManager** 0.5.2 - Battery-efficient background sync
- **Connectivity Plus** 6.1.5 - Network status monitoring

### UI & Visualization
- **FL Chart** 0.70.2 - Beautiful charts for progress tracking
- **Cached Network Image** 3.4.1 - Efficient image loading
- **Shimmer** 3.0.0 - Loading placeholders
- **Lottie** 3.3.2 - Smooth animations

### Security
- **Flutter Secure Storage** 9.2.4 - Encrypted token storage
- **JWT Decoder** 2.0.1 - Token validation

## Project Structure

```
lib/
├── core/
│   ├── constants/          # API URLs, app constants
│   ├── theme/              # App theme, colors, text styles
│   ├── utils/              # Helper functions
│   └── network/            # HTTP client configuration
├── data/
│   ├── models/             # Data models
│   ├── repositories/       # Repository pattern
│   ├── local/              # Drift database
│   └── remote/             # API clients
├── domain/
│   ├── entities/           # Business entities
│   └── usecases/           # Business logic
├── presentation/
│   ├── auth/               # Login, register screens
│   ├── home/               # Dashboard
│   ├── workouts/           # Workout screens
│   ├── exercises/          # Exercise screens
│   ├── progress/           # Progress tracking
│   ├── diet/               # Diet plan screens
│   ├── profile/            # User profile
│   └── widgets/            # Reusable widgets
└── services/
    ├── auth_service.dart   # Authentication logic
    ├── sync_service.dart   # Background sync
    └── storage_service.dart # Secure storage
```

## Getting Started

### Prerequisites
- Flutter SDK 3.38.7 or higher
- Dart 3.10.7 or higher
- Android Studio (for Android development)
- Xcode (for iOS development - optional)

### Installation

1. **Clone the repository**
   ```bash
   cd "/Users/abubakarsiddique/ALL Project Gym/muscle_hustle_app"
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   # Run in Chrome (fastest for testing)
   flutter run -d chrome

   # Run on Android emulator
   flutter run

   # Run on physical device
   flutter run -d <device_id>
   ```

## Development

### Code Generation

When you modify database schema or add new models:

```bash
# Watch mode (auto-generates on file changes)
dart run build_runner watch

# One-time build
dart run build_runner build --delete-conflicting-outputs
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires Mac)
flutter build ios --release
```

## Backend API

The app connects to the Muscle Hustle Flask backend:
- **Base URL**: `https://muscle-hustle.onrender.com`
- **API Version**: `/api/v1`

### API Endpoints (To be implemented)
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/register` - User registration
- `GET /api/v1/workouts` - Get workouts
- `GET /api/v1/exercises` - Get exercises
- `POST /api/v1/progress` - Log progress
- `GET /api/v1/diet-plans/weekly` - Get 7-day diet plan

## Offline-First Architecture

### How It Works

1. **App Launch** → Loads data from local SQLite database (instant)
2. **User Actions** → Saved to local database immediately
3. **Background** → Sync service checks connectivity
4. **When Online** → Uploads pending changes, downloads updates
5. **Conflict Resolution** → Server timestamp wins

### Sync Strategy

- **Timestamp-based sync** - Only fetch changes since last sync
- **Pending changes queue** - Retry failed uploads
- **Optimistic updates** - UI updates immediately
- **Background sync** - WorkManager handles periodic sync

## Configuration

### Update API Base URL

Edit `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl = 'https://your-server.com';
```

### Customize Theme

Edit `lib/core/theme/app_theme.dart`:

```dart
static const Color primary = Color(0xFF6366F1); // Your brand color
```

## Troubleshooting

### Build Errors

```bash
# Clean build cache
flutter clean

# Get dependencies
flutter pub get

# Regenerate code
dart run build_runner build --delete-conflicting-outputs
```

### Database Issues

```bash
# Delete app data and reinstall
flutter clean
flutter run
```

## Roadmap

- [x] Project setup and architecture
- [x] Database schema
- [x] Login screen UI
- [ ] REST API implementation (Flask backend)
- [ ] Authentication flow
- [ ] Workout tracking
- [ ] Exercise library
- [ ] Progress tracking with photos
- [ ] Diet plan viewer
- [ ] Background sync
- [ ] Charts and analytics
- [ ] Push notifications
- [ ] iOS support

## Contributing

This is a hobby project. Feel free to fork and customize for your needs!

## License

MIT License

## Contact

For questions or suggestions, please open an issue in the repository.

---

**Built with ❤️ using Flutter**
