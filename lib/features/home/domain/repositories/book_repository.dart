import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:dartz/dartz.dart';

abstract class BookRepository {
  Future<Either<Exception, BookResponse>> getBooks({
    required int page,
    String? searchQuery,
  });
}
