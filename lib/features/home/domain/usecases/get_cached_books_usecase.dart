import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:book_listing_app/features/home/domain/repositories/book_repository.dart';
import 'package:dartz/dartz.dart';

class GetCachedBooksUseCase {
  final BookRepository repository;

  GetCachedBooksUseCase(this.repository);

  Future<Either<Exception, List<Book>>> call() async {
    return await repository.getCachedBooks();
  }
} 