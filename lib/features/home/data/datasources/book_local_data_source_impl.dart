import 'dart:convert';

import 'package:book_listing_app/features/home/data/datasources/book_local_data_source.dart';
import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/book_model.dart';

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final SharedPreferences sharedPreferences;
  static String _cachedBooksKey(int page) => 'CACHED_BOOKS_$page';

  BookLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheBooks(List<Book> books, int page) async {
    final booksJson = books
        .map(
          (book) => jsonEncode(
            book.toJson(),
          ),
        )
        .toList();

    await sharedPreferences.setStringList(
      _cachedBooksKey(page),
      booksJson,
    );
  }

  @override
  Future<Either<Exception, List<Book>>> getCachedBooks(int page) async {
    try {
      final cachedBooksJson = sharedPreferences.getStringList(
        _cachedBooksKey(page),
      );
      if (cachedBooksJson == null) {
        return Left(
          Exception(
            'No cached books found',
          ),
        );
      }
      final books = cachedBooksJson
          .map(
            (bookJson) => BookModel.fromJson(
              json.decode(bookJson),
            ),
          )
          .toList();
      return Right(books);
    } catch (e) {
      return Left(
        Exception(
          'Failed to load cached books: $e',
        ),
      );
    }
  }
}
