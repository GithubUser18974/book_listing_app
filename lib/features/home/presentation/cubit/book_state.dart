part of 'book_cubit.dart';

abstract class BookState extends Equatable {
  final int currentPage;
  final String? currentSearchQuery;
  final bool hasReachedMax;

  const BookState({
    this.currentPage = 1,
    this.currentSearchQuery,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {
  const BookLoading({
    super.currentPage = 1,
    super.currentSearchQuery,
    super.hasReachedMax = false,
  });
}

class BookLoaded extends BookState {
  final List<Book> books;
  final bool isCached;

  const BookLoaded({
    required this.books,
    super.hasReachedMax = false,
    super.currentPage,
    super.currentSearchQuery,
    this.isCached = false,
  });

  BookLoaded copyWith({
    List<Book>? books,
    bool? hasReachedMax,
    bool? isCached,
  }) {
    return BookLoaded(
      books: books ?? this.books,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isCached: isCached ?? this.isCached,
    );
  }

  @override
  List<Object?> get props => [books, hasReachedMax, isCached];
}

class BookPaginating extends BookState {
  final List<Book> books;
  final bool isCached;

  const BookPaginating({
    required this.books,
    super.hasReachedMax,
    super.currentPage,
    super.currentSearchQuery,
    this.isCached = false,
  });

  BookPaginating copyWith({
    List<Book>? books,
    bool? hasReachedMax,
    bool? isCached,
  }) {
    return BookPaginating(
      books: books ?? this.books,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isCached: isCached ?? this.isCached,
    );
  }

  @override
  List<Object?> get props => [books, hasReachedMax, isCached];
}

class BookError extends BookState {
  final String message;

  const BookError(this.message);

  @override
  List<Object?> get props => [message];
}
