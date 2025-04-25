import 'package:equatable/equatable.dart';

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