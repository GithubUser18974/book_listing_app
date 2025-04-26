import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:book_listing_app/features/home/domain/usecases/get_books_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final GetBooksUseCase getBooksUseCase;

  BookCubit({
    required this.getBooksUseCase,
  }) : super(BookInitial()) {
    loadInitialBooks();
  }

  Future<void> loadInitialBooks() async {
    emit(BookLoading(
      currentPage: 1,
      hasReachedMax: false,
      currentSearchQuery: null,
    ));

    await _getData();
  }

  Future<void> searchBooks(String query) async {
    emit(BookLoading(
      currentPage: 1,
      hasReachedMax: false,
      currentSearchQuery: query,
    ));
    _getData();
  }

  Future<void> reload() async {
    emit(BookLoading(
      currentPage: 1,
      hasReachedMax: false,
      currentSearchQuery: state.currentSearchQuery,
    ));
    _getData();
  }

  Future<void> loadMoreBooks() async {
    if (state.hasReachedMax) return;

    final currentState = state;
    if (currentState is BookLoaded) {
      emit(BookPaginating(
        books: currentState.books,
        hasReachedMax: false,
        currentPage: currentState.currentPage,
        currentSearchQuery: currentState.currentSearchQuery,
        isCached: currentState.isCached,
      ));

      final result = await getBooksUseCase(
        page: state.currentPage + 1,
        searchQuery: state.currentSearchQuery,
      );

      result.fold(
        (failure) => emit(BookLoaded(
          books: [...currentState.books],
          hasReachedMax: currentState.hasReachedMax,
          currentPage: currentState.currentPage,
          currentSearchQuery: currentState.currentSearchQuery,
          isCached: currentState.isCached,
        )),
        (booksResponse) {
          if (booksResponse.books.isEmpty) {
            emit(BookLoaded(
              books: [...currentState.books, ...booksResponse.books],
              hasReachedMax: true,
              currentPage: currentState.currentPage + 1,
              currentSearchQuery: currentState.currentSearchQuery,
              isCached: booksResponse.isCache,
            ));
          } else {
            emit(BookLoaded(
              books: [...currentState.books, ...booksResponse.books],
              hasReachedMax: false,
              currentPage: currentState.currentPage + 1,
              currentSearchQuery: currentState.currentSearchQuery,
              isCached: booksResponse.isCache,
            ));
          }
        },
      );
    }
  }

  Future<void> _getData() async {
    final result = await getBooksUseCase(
      page: state.currentPage,
    );
    result.fold(
      (failure) => emit(
        BookError(
          failure.toString(),
        ),
      ),
      (bookResponse) {
        emit(
          BookLoaded(
            books: bookResponse.books,
            currentSearchQuery: state.currentSearchQuery,
            hasReachedMax: false,
            currentPage: state.currentPage,
            isCached: bookResponse.isCache,
          ),
        );
      },
    );
  }
}
