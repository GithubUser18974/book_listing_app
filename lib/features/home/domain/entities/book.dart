import 'package:equatable/equatable.dart';

class BookResponse {
  final List<Book> books;
  final bool isCache;

  BookResponse({
    required this.books,
    required this.isCache,
  });
}

class Book extends Equatable {
  final int id;
  final String title;
  final List<String> authors;
  final String? coverImage;
  final String? summary;
  final List<String> subjects;
  final List<String> languages;
  final String? downloadUrl;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.coverImage,
    this.summary,
    this.subjects = const [],
    this.languages = const [],
    this.downloadUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'cover_image': coverImage,
      'summary': summary,
      'subjects': subjects,
      'languages': languages,
      'download_url': downloadUrl,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        authors,
        coverImage,
        summary,
        subjects,
        languages,
        downloadUrl,
      ];
}
