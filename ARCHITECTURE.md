# 🏗️ Firebase Integration Architecture

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                       │
│  ┌────────────┐         ┌──────────────┐                    │
│  │ LoginPage  │────────▶│ RegisterPage │                    │
│  └─────┬──────┘         └──────┬───────┘                    │
│        │                       │                             │
│        └───────────┬───────────┘                             │
│                    ▼                                         │
│          ┌──────────────────┐                                │
│          │  AuthNotifier    │ (Riverpod StateNotifier)      │
│          │  (AuthProvider)  │                                │
│          └────────┬─────────┘                                │
└───────────────────┼──────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│          ┌──────────────────┐                                │
│          │  AuthRepository  │ (Abstract Interface)           │
│          │   (Interface)    │                                │
│          └────────┬─────────┘                                │
│                   │                                          │
│          ┌────────▼─────────┐                                │
│          │   UserEntity     │ (Pure Dart Class)              │
│          └──────────────────┘                                │
└───────────────────┼──────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│          ┌──────────────────────┐                            │
│          │ AuthRepositoryImpl   │ (Implementation)           │
│          └──────────┬───────────┘                            │
│                     │                                        │
│                     ▼                                        │
│          ┌──────────────────────┐                            │
│          │ AuthRemoteDataSource │                            │
│          └──────────┬───────────┘                            │
│                     │                                        │
│          ┌──────────▼───────────┐                            │
│          │     UserModel        │ (JSON Serialization)       │
│          └──────────────────────┘                            │
└───────────────────┼──────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────┐
│                    FIREBASE SERVICES                         │
│  ┌──────────────────┐      ┌──────────────────┐             │
│  │  Firebase Auth   │      │ Cloud Firestore  │             │
│  │                  │      │                  │             │
│  │ • Email/Password │      │ • users/         │             │
│  │ • User Sessions  │      │   {userId}       │             │
│  └──────────────────┘      └──────────────────┘             │
└─────────────────────────────────────────────────────────────┘
```

## File Structure

```
lib/
├── main.dart                              # App entry point + Firebase init
├── firebase_options.dart                  # Generated by FlutterFire CLI
│
├── core/
│   ├── errors/
│   │   ├── failures.dart                  # Failure classes (domain)
│   │   └── exceptions.dart                # Exception classes (data)
│   ├── utils/
│   │   └── validators.dart                # Form validators
│   └── providers/
│       └── firebase_providers.dart        # Firebase instance providers
│
└── features/
    └── auth/
        ├── data/                          # External data handling
        │   ├── models/
        │   │   └── user_model.dart        # UserEntity + JSON methods
        │   ├── datasources/
        │   │   └── auth_remote_datasource.dart  # Firebase API calls
        │   └── repositories/
        │       └── auth_repository_impl.dart    # Repository implementation
        │
        ├── domain/                        # Business logic (pure Dart)
        │   ├── entities/
        │   │   └── user_entity.dart       # User entity (no dependencies)
        │   └── repositories/
        │       └── auth_repository.dart   # Repository interface
        │
        └── presentation/                  # UI layer
            ├── providers/
            │   ├── auth_provider.dart              # State management
            │   └── auth_repository_provider.dart   # DI providers
            └── pages/
                ├── login_page.dart
                └── register_page.dart
```

## Key Concepts

### 1. **Separation of Concerns**
- **Presentation**: UI and user interactions
- **Domain**: Business logic and entities
- **Data**: External data sources and models

### 2. **Dependency Injection (Riverpod)**
- Firebase instances provided via `Provider`
- Repository provided via `Provider`
- Auth state managed via `StateNotifierProvider`

### 3. **Error Handling**
- **Exceptions** thrown in data layer
- **Failures** returned in domain layer
- **Either<Failure, Success>** pattern (fpdart)

### 4. **Data Flow**

**Login Flow:**
```
User taps Login
    ↓
LoginPage calls AuthNotifier.login()
    ↓
AuthNotifier calls AuthRepository.login()
    ↓
AuthRepositoryImpl calls AuthRemoteDataSource.signIn()
    ↓
AuthRemoteDataSource calls Firebase Auth
    ↓
Firebase returns User
    ↓
DataSource fetches user data from Firestore
    ↓
Returns UserModel → converted to UserEntity
    ↓
Repository returns Either<Failure, UserEntity>
    ↓
AuthNotifier updates state
    ↓
UI rebuilds with new state
```

## Benefits of This Architecture

✅ **Testable**: Each layer can be tested independently
✅ **Maintainable**: Clear separation makes changes easier
✅ **Scalable**: Easy to add new features
✅ **Flexible**: Can swap Firebase for another backend
✅ **Type-safe**: Strong typing throughout
✅ **Error handling**: Consistent error handling pattern

## Dependencies

- **flutter_riverpod**: State management & DI
- **firebase_core**: Firebase initialization
- **firebase_auth**: Authentication
- **cloud_firestore**: Database
- **fpdart**: Functional programming (Either type)
