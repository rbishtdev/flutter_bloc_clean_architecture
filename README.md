# Flutter BLoC Clean Architecture (Offline-First Todo App)

A production-grade Flutter application demonstrating **Clean
Architecture**, **BLoC state management**, and an **offline-first
synchronization strategy** using SQLite and REST APIs.

This project is designed as a **real-world reference architecture** for
scalable Flutter applications.

------------------------------------------------------------------------

## ✨ Features

-   📦 Clean Architecture (Domain / Data / Presentation)
-   🔁 Offline-first data handling
-   💾 SQLite local cache (source of truth)
-   🌐 REST API integration (JSONPlaceholder)
-   🔄 Auto sync when internet is restored
-   ⚡ Optimistic UI updates
-   🧩 BLoC pattern (pure events & states)
-   🔌 Dependency Injection with Injectable + GetIt
-   📡 Connectivity monitoring
-   🧪 Testable architecture
-   🚀 Production-ready structure

------------------------------------------------------------------------

## 🧠 Architecture Overview

    UI (Flutter Widgets)
       ↓
    BLoC
       ↓
    UseCases
       ↓
    Repository
       ↓
    Local DB  ← SOURCE OF TRUTH
       ↓
    Remote API (sync only)

> Local database is the single source of truth.\
> Remote API is used only for synchronization.

------------------------------------------------------------------------

## 📁 Project Structure

    lib/
     ├── app.dart
     ├── main.dart
     │
     ├── core/
     │    ├── di/
     │    ├── data/
     │    │     ├── local/
     │    │     └── remote/
     │    ├── errors/
     │    ├── network/
     │    └── utils/
     │
     └── features/
          └── todo/
               ├── domain/
               │     ├── entities/
               │     ├── repositories/
               │     └── usecases/
               │
               ├── data/
               │     ├── models/
               │     ├── local/
               │     ├── remote/
               │     └── repositories/
               │
               └── presentation/
                     ├── blocs/
                     └── pages/

------------------------------------------------------------------------

## 🗃 Database Schema

``` sql
CREATE TABLE todos(
  id INTEGER PRIMARY KEY,
  userId INTEGER,
  title TEXT,
  completed INTEGER,
  is_synced INTEGER,
  is_deleted INTEGER
)
```

------------------------------------------------------------------------

## ▶️ Setup Instructions

### 1. Clone the repository

``` bash
git clone https://github.com/yourusername/flutter_bloc_clean_architecture.git
cd flutter_bloc_clean_architecture
```

### 2. Install dependencies

``` bash
flutter pub get
```

### 3. Generate DI code

``` bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the app

``` bash
flutter run
```

### 5. Flutter & dart version used
- Flutter 3.35.1 & dart 3.9.0
------------------------------------------------------------------------

## 🧩 BLoC Pattern Implementation

This project uses **flutter_bloc** to manage state.

-   Events represent user or system actions (LoadTodos, AddTodo,
    UpdateTodo, DeleteTodo, SyncTodos).
-   States represent UI states (Loading, Loaded, Error).
-   The Bloc acts as the middle layer between UI and business logic.

Flow:

    UI → Event → Bloc → UseCase → Repository → Local/Remote → State → UI

The UI never directly accesses repositories or databases.

------------------------------------------------------------------------

## 🔄 Offline Support Strategy

The application follows an **offline-first** approach:

-   SQLite is the **single source of truth**.
-   All reads are from the local database.
-   Writes are saved locally first.
-   API calls are used only to sync data in the background.
-   When the network is restored, pending changes are synced
    automatically.

### Sync Flow

    Local DB changes
         ↓
    Marked as unsynced
         ↓
    Connectivity restored
         ↓
    Background sync triggered

This guarantees that the app works fully even without internet.

------------------------------------------------------------------------

## 🧠 Design Decisions & Assumptions

-   Local database is always trusted over remote data.
-   Remote API is treated as a synchronization service.
-   Soft delete is used instead of hard delete until sync is complete.
-   Domain layer never depends on Flutter or data frameworks.
-   BLoC owns orchestration logic, repository owns sync logic.

------------------------------------------------------------------------

## ⚠️ Challenges & Solutions

### Challenge 1: Handling offline CRUD

**Solution:** Implemented optimistic local writes and background sync.

### Challenge 2: API failures breaking UI

**Solution:** All network calls are wrapped in best-effort sync logic.

### Challenge 3: Sync conflicts

**Solution:** Local database is treated as source of truth.

### Challenge 4: Connectivity API changes

**Solution:** Adapted logic to handle list-based connectivity results.

------------------------------------------------------------------------

## 🔄 Offline-First Strategy Summary

Operation   Behavior
  ----------- ----------------------------------
Read        From SQLite
Add         Insert locally → sync later
Update      Update locally → sync later
Delete      Soft delete locally → sync later
Sync        Auto runs when network restores

------------------------------------------------------------------------

## 🌐 API

Using JSONPlaceholder:

    GET    /todos
    POST   /todos
    PUT    /todos/{id}
    DELETE /todos/{id}

------------------------------------------------------------------------

## 🔌 Dependency Injection

Implemented using:

-   get_it
-   injectable

All dependencies are resolved automatically at runtime.

------------------------------------------------------------------------

## ⚙️ Tech Stack

Category           Tech
  ------------------ ---------------------
State Management   flutter_bloc
Local Storage      sqflite
Network            dio
DI                 injectable + get_it
Functional         dartz
Connectivity       connectivity_plus
Architecture       Clean Architecture

------------------------------------------------------------------------

## 🧪 Testing Strategy

-   Unit tests for use cases
-   Bloc event/state tests
-   Repository sync tests

------------------------------------------------------------------------

## 🎯 Highlight

> My Flutter app follows an offline-first Clean Architecture approach
> where SQLite is the single source of truth and the API is only used
> for synchronization.

------------------------------------------------------------------------

## 🚀 Future Improvements

-   Background worker
-   Pagination
-   Authentication module
-   Search
-   Sync progress UI

------------------------------------------------------------------------

## 🧑‍💻 Author

**Rajendra Singh Bisht**\
Flutter \| Clean Architecture \| BLoC \| Offline-First Systems

🔗 GitHub: https://github.com/rbishtdev

🔗 LinkedIn: https://www.linkedin.com/in/r-bisht/

------------------------------------------------------------------------

## 📄 License

MIT License

------------------------------------------------------------------------

⭐ If you found this useful, please star the repository!
