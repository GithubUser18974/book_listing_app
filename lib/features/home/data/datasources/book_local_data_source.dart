import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:dartz/dartz.dart';

abstract class BookLocalDataSource {
  Future<void> cacheBooks(List<Book> books, int page);
  Future<Either<Exception, List<Book>>> getCachedBooks(int page);
}
