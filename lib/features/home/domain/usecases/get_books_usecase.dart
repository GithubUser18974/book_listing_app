import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:book_listing_app/features/home/domain/repositories/book_repository.dart';
import 'package:dartz/dartz.dart';

class GetBooksUseCase {
  final BookRepository repository;

  GetBooksUseCase(this.repository);

  Future<Either<Exception, BookResponse>> call({
    required int page,
    String? searchQuery,
  }) async {
    return await repository.getBooks(
      page: page,
      searchQuery: searchQuery,
    );
  }
}
