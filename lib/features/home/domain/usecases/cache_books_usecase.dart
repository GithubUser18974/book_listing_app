import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:book_listing_app/features/home/domain/repositories/book_repository.dart';

class CacheBooksUseCase {
  final BookRepository repository;

  CacheBooksUseCase(this.repository);

  Future<void> call(List<Book> books) async {
    await repository.cacheBooks(books);
  }
} 