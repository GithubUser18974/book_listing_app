# Book Listing App

A Flutter application that lists books with features like search, pagination, and offline caching.

## Architecture

The application follows Clean Architecture principles with the following layers:

### 1. Presentation Layer
- **Cubits**: State management using Flutter Bloc
  - `BookCubit`: Manages book listing state and operations
- **Screens**: UI components
  - `BookListScreen`: Main screen displaying book list with search and pagination
- **Widgets**: Reusable UI components
  - `BookListItem`: Individual book item display
  - `BookListItemShimmer`: Loading state placeholder

### 2. Domain Layer
- **Entities**: Core business objects
  - `Book`: Book entity with properties and JSON serialization
  - `BookResponse`: Response wrapper for book list with cache status
- **Use Cases**: Business logic
  - `GetBooksUseCase`: Fetches books from repository
  - `GetCachedBooksUseCase`: Retrieves cached books
  - `CacheBooksUseCase`: Caches books locally
- **Repository Interfaces**: Abstract data operations
  - `BookRepository`: Defines book-related operations

### 3. Data Layer
- **Repositories**: Implementation of repository interfaces
  - `BookRepositoryImpl`: Implements book repository operations
- **Data Sources**: Data providers
  - `BookRemoteDataSource`: Interface for remote data operations
  - `BookLocalDataSource`: Interface for local data operations
  - `BookRemoteDataSourceImpl`: Implements remote data operations
  - `BookLocalDataSourceImpl`: Implements local data operations

## Features

### Book Listing
- Displays books in a scrollable list
- Implements pagination for loading more books
- Shows shimmer loading effect during data fetching
- Handles empty states and error cases

### Search Functionality
- Real-time search with debouncing
- Searches through book titles and authors
- Maintains search state during pagination

### Caching
- Caches book data locally using SharedPreferences
- Shows cached data when offline
- Indicates when data is from cache

## Dependencies

- **State Management**: `flutter_bloc: ^8.1.4`
- **HTTP Client**: `http: ^1.3.0`
- **Image Caching**: `cached_network_image: ^3.4.1`
- **Functional Programming**: `dartz: ^0.10.1`
- **Dependency Injection**: `get_it: ^8.0.3`
- **Equality Comparison**: `equatable: ^2.0.5`
- **Local Storage**: `shared_preferences: ^2.2.2`
- **Network Status**: `connectivity_plus: ^5.0.2`
- **Environment Variables**: `flutter_dotenv: ^5.1.0`
- **Internationalization**: `intl: ^0.19.0`
- **Loading Effects**: `shimmer: ^3.0.0`
- **Custom Fonts**: `google_fonts: ^6.1.0`
- **Responsive UI**: `flutter_screenutil: ^5.9.3`

## Project Structure

```
lib/
├── common/                    # Shared utilities and constants
│   ├── constants/            # Application constants
│   │   ├── app_constants.dart
│   │   └── theme_constants.dart
│   ├── services/             # Shared services
│   │   ├── network_service.dart
│   │   └── storage_service.dart
│   └── utils/                # Utility functions
│       ├── date_utils.dart
│       └── string_utils.dart
├── core/                     # Core functionality
│   └── di/                   # Dependency injection
│       ├── di_container.dart
│       └── service_locator.dart
├── features/                 # Feature-specific code
│   └── home/                 # Home feature
│       ├── data/             # Data layer implementation
│       │   ├── datasources/  # Data sources
│       │   │   ├── book_local_data_source.dart
│       │   │   └── book_remote_data_source.dart
│       │   ├── models/       # Data models
│       │   │   └── book_model.dart
│       │   └── repositories/ # Repository implementations
│       │       └── book_repository_impl.dart
│       ├── domain/           # Domain layer
│       │   ├── entities/     # Business entities
│       │   │   └── book.dart
│       │   ├── repositories/ # Repository interfaces
│       │   │   └── book_repository.dart
│       │   └── usecases/     # Business logic
│       │       ├── get_books_usecase.dart
│       │       ├── get_cached_books_usecase.dart
│       │       └── cache_books_usecase.dart
│       └── presentation/      # UI layer
│           ├── cubit/        # State management
│           │   ├── book_cubit.dart
│           │   └── book_state.dart
│           ├── screens/      # Screens
│           │   └── book_list_screen.dart
│           └── widgets/      # Reusable widgets
│               ├── book_list_item.dart
│               └── book_list_item_shimmer.dart
└── main.dart                 # Application entry point
```

## Data Flow

1. **Initial Load**:
   ```
   UI → BookCubit → GetBooksUseCase → BookRepository → RemoteDataSource → API
   ```

2. **Search**:
   ```
   UI → BookCubit → GetBooksUseCase → BookRepository → RemoteDataSource → API
   ```

3. **Pagination**:
   ```
   UI → BookCubit → GetBooksUseCase → BookRepository → RemoteDataSource → API
   ```

4. **Caching**:
   ```
   BookCubit → CacheBooksUseCase → BookRepository → LocalDataSource → SharedPreferences
   ```

5. **Offline Access**:
   ```
   UI → BookCubit → GetCachedBooksUseCase → BookRepository → LocalDataSource → SharedPreferences
   ```

## Error Handling

The application implements comprehensive error handling:
- Network errors are caught and displayed to the user
- Empty states are handled gracefully
- Loading states are shown during data fetching
- Cache misses are handled with appropriate fallbacks

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Modify file  '[app_constants.dart](lib/common/constants/app_constants.dart)' with your API configuration
4. Run the application:
   ```bash
   flutter run
   ```

