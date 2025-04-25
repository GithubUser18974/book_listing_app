# Book Listing App

A Flutter application that allows users to browse and search books from the Project Gutenberg library using the Gutendex API.

## Features

- Browse books with infinite scrolling
- Search books by title or author with debouncing (500ms delay)
- View book details including cover image, title, authors, and summary
- Expandable book summaries (only shows "Show More" when text exceeds 3 lines)
- Offline caching support
- Responsive design for different screen sizes
- Dark mode support
- Network error handling with automatic retries
- DNS resolution error handling
- Automatic fallback to cached data when offline

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
- Debouncer for search optimization
- Connectivity Plus for network state monitoring

## Getting Started

### Prerequisites

- Flutter SDK (version 3.6.0 or higher)
- Dart SDK (version 3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android SDK / iOS development tools

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd book_listing_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
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

6. **Search Optimization**: 
   - Implemented debouncing (500ms delay) to prevent excessive API calls while typing
   - Search triggers automatically as the user types
   - Previous searches are cancelled if the user types again within the delay period

7. **Text Overflow Handling**:
   - Book summaries are limited to 3 lines by default
   - "Show More" button only appears when the text actually exceeds 3 lines
   - Text is properly truncated with ellipsis when it's too long

8. **Network Resilience**:
   - Automatic retry mechanism for failed requests
   - Graceful handling of DNS resolution errors
   - Fallback to cached data when network requests fail
   - Clear indication when showing cached data

## Testing

To run the tests:
```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
