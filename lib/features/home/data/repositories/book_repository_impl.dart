import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:book_listing_app/common/constants/app_constants.dart';
import 'package:book_listing_app/common/services/network_service.dart';
import 'package:book_listing_app/features/home/data/models/book_model.dart';
import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:book_listing_app/features/home/domain/repositories/book_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookRepositoryImpl implements BookRepository {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  final NetworkService networkService;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  BookRepositoryImpl({
    required this.client,
    required this.sharedPreferences,
    required this.networkService,
  });

  Future<Either<Exception, List<Book>>> _makeRequest({
    required int page,
    String? searchQuery,
    int retryCount = 0,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        if (searchQuery != null && searchQuery.isNotEmpty)
          'search': searchQuery,
      };

      final uri = Uri.parse(AppConstants.baseUrl + AppConstants.booksEndpoint)
          .replace(queryParameters: queryParams);

      final response = await client.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'] as List<dynamic>;
        final books = results
            .map((book) => BookModel.fromJson(book as Map<String, dynamic>))
            .toList();

        // Cache the books
        await cacheBooks(books);

        return Right(books);
      } else {
        return Left(Exception('Failed to load books: ${response.statusCode}'));
      }
    } on SocketException catch (e) {
      if (retryCount < maxRetries) {
        // Wait before retrying
        await Future.delayed(retryDelay);
        return _makeRequest(
          page: page,
          searchQuery: searchQuery,
          retryCount: retryCount + 1,
        );
      }
      // If all retries failed, try to get cached data
      final cachedResult = await getCachedBooks();
      return cachedResult.fold(
        (failure) => Left(Exception('Network error: ${e.message}. Please check your internet connection.')),
        (books) => Right(books),
      );
    } on TimeoutException catch (e) {
      if (retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return _makeRequest(
          page: page,
          searchQuery: searchQuery,
          retryCount: retryCount + 1,
        );
      }
      final cachedResult = await getCachedBooks();
      return cachedResult.fold(
        (failure) => Left(Exception('Request timed out: ${e.message}')),
        (books) => Right(books),
      );
    } catch (e) {
      final cachedResult = await getCachedBooks();
      return cachedResult.fold(
        (failure) => Left(Exception('Error: ${e.toString()}')),
        (books) => Right(books),
      );
    }
  }

  @override
  Future<Either<Exception, List<Book>>> getBooks({
    required int page,
    String? searchQuery,
  }) async {
    try {
      // Check network connectivity first
      final isConnected = await networkService.isConnected();
      if (!isConnected) {
        return await getCachedBooks();
      }

      return await _makeRequest(page: page, searchQuery: searchQuery);
    } catch (e) {
      final cachedResult = await getCachedBooks();
      return cachedResult.fold(
        (failure) => Left(Exception('Error: ${e.toString()}')),
        (books) => Right(books),
      );
    }
  }

  @override
  Future<Either<Exception, List<Book>>> getCachedBooks() async {
    try {
      final cachedBooksJson = sharedPreferences.getStringList('cached_books');
      if (cachedBooksJson == null || cachedBooksJson.isEmpty) {
        return Left(Exception('No cached books found'));
      }

      final books = cachedBooksJson
          .map((bookJson) => BookModel.fromJson(json.decode(bookJson)))
          .toList();

      return Right(books);
    } catch (e) {
      return Left(Exception('Error loading cached books: ${e.toString()}'));
    }
  }

  @override
  Future<void> cacheBooks(List<Book> books) async {
    try {
      final booksJson = books
          .map((book) => json.encode((book as BookModel).toJson()))
          .toList();
      await sharedPreferences.setStringList('cached_books', booksJson);
    } catch (e) {
      // Silently fail caching if there's an error
      print('Error caching books: ${e.toString()}');
    }
  }
}
