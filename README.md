# Book Listing App

A Flutter application that allows users to browse and search books from the Project Gutenberg library using the Gutendex API.

## Features

- Browse books with infinite scrolling
- Search books by title or author
- View book details including cover image, title, authors, and summary
- Expandable book summaries
- Offline caching support
- Responsive design for different screen sizes
- Dark mode support

## Technical Requirements

The application is built using:

- Flutter SDK
- Clean Architecture
- Cubit for state management
- Dependency Injection with GetIt
- HTTP for API calls
- SharedPreferences for local caching
- CachedNetworkImage for image loading and caching
- ScreenUtil for responsive design
- Google Fonts for typography

## Getting Started

### Prerequisites

- Flutter SDK (version 3.6.0 or higher)
- Dart SDK (version 3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android SDK / iOS development tools

### Installation

1. Clone the repository:
git clone <repository-url>
cd book_listing_app
```

2. Install dependencies:
flutter pub get
```

3. Run the app:
flutter run
```

## Project Structure

The project follows Clean Architecture principles:

```
lib/
├── common/
│   └── constants/
│       ├── app_constants.dart
│       └── theme_constants.dart
├── features/
│   └── home/
│       ├── data/
│       │   ├── models/
│       │   │   └── book_model.dart
│       │   └── repositories/
│       │       └── book_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── book.dart
│       │   └── repositories/
│       │       └── book_repository.dart
│       └── presentation/
│           ├── cubit/
│           │   ├── book_cubit.dart
│           │   └── book_state.dart
│           ├── screens/
│           │   └── book_list_screen.dart
│           └── widgets/
│               └── book_list_item.dart
└── main.dart
```

## Design Decisions

1. **Clean Architecture**: The project follows Clean Architecture principles to separate concerns and make the codebase more maintainable and testable.

2. **Cubit for State Management**: Cubit was chosen over other state management solutions for its simplicity and effectiveness in managing the book listing state.

3. **Offline Support**: The app implements offline caching using SharedPreferences to store book data locally, allowing users to access previously loaded books without an internet connection.

4. **Responsive Design**: The UI is built using ScreenUtil to ensure consistent layout across different screen sizes and orientations.

5. **Error Handling**: Comprehensive error handling is implemented throughout the app to provide a smooth user experience even when errors occur.


