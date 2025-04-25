import 'package:book_listing_app/features/home/domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.authors,
    super.coverImage,
    super.summary,
    super.subjects = const [],
    super.languages = const [],
    super.downloadUrl,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final formats = json['formats'] as Map<String, dynamic>?;
    final imageUrl = formats?['image/jpeg'] as String?;
    final downloadUrl = formats?['text/html'] as String?;

    return BookModel(
      id: json['id'] as int,
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>?)
              ?.map((author) => author['name'] as String)
              .toList() ??
          [],
      coverImage: imageUrl,
      summary: json['subjects']?.first as String?,
      subjects: (json['subjects'] as List<dynamic>?)
              ?.map((subject) => subject as String)
              .toList() ??
          [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((language) => language as String)
              .toList() ??
          [],
      downloadUrl: downloadUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'coverImage': coverImage,
      'summary': summary,
      'subjects': subjects,
      'languages': languages,
      'downloadUrl': downloadUrl,
    };
  }
} 