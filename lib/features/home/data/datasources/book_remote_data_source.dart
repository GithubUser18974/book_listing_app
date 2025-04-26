import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:dartz/dartz.dart';

abstract class BookRemoteDataSource {
  Future<Either<Exception, List<Book>>> getBooks({
    required int page,
    String? searchQuery,
  });
} 