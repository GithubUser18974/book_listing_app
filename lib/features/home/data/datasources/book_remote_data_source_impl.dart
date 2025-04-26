import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:book_listing_app/common/constants/app_constants.dart';
import 'package:book_listing_app/features/home/data/datasources/book_remote_data_source.dart';
import 'package:book_listing_app/features/home/data/models/book_model.dart';
import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final http.Client client;

  BookRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<Either<Exception, List<Book>>> getBooks({
    required int page,
    String? searchQuery,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        if (searchQuery != null) 'q': searchQuery,
      };
      final uri = Uri.parse(
        AppConstants.baseUrl + AppConstants.booksEndpoint,
      ).replace(
        queryParameters: queryParams,
      );

      log("Fetching ${uri.toString()}");

      final response = await client.get(uri).timeout(
        const Duration(seconds: 25),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'] as List<dynamic>;
        final books = results
            .map(
              (book) => BookModel.fromJson(book as Map<String, dynamic>),
            )
            .toList();
        return Right(books);
      } else {
        return Left(Exception('Failed to load books'));
      }
    } catch (e) {
      return Left(Exception('Failed to load books: $e'));
    }
  }
}
