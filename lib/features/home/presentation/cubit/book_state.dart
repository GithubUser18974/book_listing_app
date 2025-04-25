part of 'book_cubit.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<Book> books;
  final bool hasReachedMax;
  final bool isCached;

  const BookLoaded({
    required this.books,
    this.hasReachedMax = false,
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

class BookError extends BookState {
  final String message;

  const BookError(this.message);

  @override
  List<Object?> get props => [message];
} 