import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:book_listing_app/features/home/domain/repositories/book_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final BookRepository repository;
  int currentPage = 1;
  String? currentSearchQuery;
  bool hasReachedMax = false;

  BookCubit({required this.repository}) : super(BookInitial());

  Future<void> loadInitialBooks() async {
    emit(BookLoading());
    currentPage = 1;
    hasReachedMax = false;
    currentSearchQuery = null;

    final result = await repository.getBooks(page: currentPage);
    result.fold(
      (failure) => emit(BookError(failure.toString())),
      (books) => emit(BookLoaded(books: books)),
    );
  }

  Future<void> searchBooks(String query) async {
    emit(BookLoading());
    currentPage = 1;
    hasReachedMax = false;
    currentSearchQuery = query;

    final result = await repository.getBooks(
      page: currentPage,
      searchQuery: query,
    );
    result.fold(
      (failure) => emit(BookError(failure.toString())),
      (books) => emit(BookLoaded(books: books)),
    );
  }

  Future<void> loadMoreBooks() async {
    if (hasReachedMax) return;

    final currentState = state;
    if (currentState is BookLoaded) {
      final result = await repository.getBooks(
        page: currentPage + 1,
        searchQuery: currentSearchQuery,
      );

      result.fold(
        (failure) => emit(BookError(failure.toString())),
        (newBooks) {
          if (newBooks.isEmpty) {
            hasReachedMax = true;
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            currentPage++;
            emit(
              currentState.copyWith(
                books: [...currentState.books, ...newBooks],
                hasReachedMax: false,
              ),
            );
          }
        },
      );
    }
  }

  Future<void> loadCachedBooks() async {
    emit(BookLoading());
    final result = await repository.getCachedBooks();
    result.fold(
      (failure) => emit(BookError(failure.toString())),
      (books) => emit(BookLoaded(books: books, isCached: true)),
    );
  }
}
