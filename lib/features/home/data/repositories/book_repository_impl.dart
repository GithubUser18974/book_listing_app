import 'dart:async';

import 'package:book_listing_app/common/services/network_service.dart';
import 'package:book_listing_app/features/home/data/datasources/book_local_data_source.dart';
import 'package:book_listing_app/features/home/data/datasources/book_remote_data_source.dart';
import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:book_listing_app/features/home/domain/repositories/book_repository.dart';
import 'package:dartz/dartz.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;
  final BookLocalDataSource localDataSource;
  final NetworkService networkService;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  BookRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkService,
  });

  @override
  Future<Either<Exception, BookResponse>> getBooks({
    required int page,
    String? searchQuery,
  }) async {
    try {
      final isConnected = await networkService.isConnected();
      if (!isConnected) {
        final books = await getCachedBooks(page);
        return books.map(
          (books) => BookResponse(
            books: books,
            isCache: true,
          ),
        );
      }

      final result = await remoteDataSource.getBooks(
        page: page,
        searchQuery: searchQuery,
      );

      return await result.fold((e) async {
        final cachedResult = await getCachedBooks(page);
        return cachedResult.fold(
          (failure) => Left(
            Exception('Error: ${e.toString()}'),
          ),
          (books) => Right(BookResponse(
            books: books,
            isCache: true,
          )),
        );
      }, (books) async {
        if (searchQuery?.isNotEmpty != true && result.isRight()) {
          await cacheBooks(books, page);
        }

        return Right(BookResponse(
          books: books,
          isCache: false,
        ));
      });
    } catch (e) {
      final cachedResult = await getCachedBooks(page);
      return cachedResult.fold(
        (failure) => Left(
          Exception('Error: ${e.toString()}'),
        ),
        (books) => Right(BookResponse(
          books: books,
          isCache: true,
        )),
      );
    }
  }

  Future<Either<Exception, List<Book>>> getCachedBooks(int page) async {
    return await localDataSource.getCachedBooks(page);
  }

  Future<void> cacheBooks(List<Book> books, int page) async {
    await localDataSource.cacheBooks(books, page);
  }
}
