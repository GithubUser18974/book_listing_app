import 'package:flutter/material.dart';

abstract class AppConstants {
  static const String baseUrl = 'https://gutendex.com';
  static const String booksEndpoint = '/books';
  static const Size designSize = Size(360, 690);
  static const int defaultPageSize = 20;
  static const int maxLinesForSummary = 6;
  static const String placeholderImage =
      'https://via.placeholder.com/150x200?text=No+Cover';

  // Error messages
  static const String networkError =
      'Network error occurred. Please check your internet connection.';
  static const String genericError =
      'Something went wrong. Please try again later.';
  static const String noBooksFound = 'No books found.';
  static const String searchHint = 'Search books by title or author...';
}
