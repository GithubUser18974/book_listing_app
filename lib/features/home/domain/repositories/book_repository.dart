import 'package:dartz/dartz.dart';
import 'package:book_listing_app/features/home/domain/entities/book.dart';

abstract class BookRepository {
  Future<Either<Exception, List<Book>>> getBooks({
    required int page,
    String? searchQuery,
  });

  Future<Either<Exception, List<Book>>> getCachedBooks();
  Future<void> cacheBooks(List<Book> books);
} 