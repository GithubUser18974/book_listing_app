import 'package:book_listing_app/features/home/domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.authors,
    required super.summaries,
    super.coverImage,
    super.subjects = const [],
    super.languages = const [],
    super.downloadUrl,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as int,
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>?)
              ?.map((author) => author['name'] as String)
              .toList() ??
          [],
      coverImage: json['formats']?['image/jpeg'] as String?,
      summaries: (json['summaries'] as List<dynamic>?)
              ?.map((subject) => subject as String)
              .toList() ??
          [],
      subjects: (json['subjects'] as List<dynamic>?)
              ?.map((subject) => subject as String)
              .toList() ??
          [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((language) => language as String)
              .toList() ??
          [],
      downloadUrl: json['formats']?['text/html'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors
          .map((e) => {
                'name': e,
              })
          .toList(),
      'summaries': summaries,
      'subjects': subjects,
      'languages': languages,
      'formats': {
        'text/html': downloadUrl,
        'image/jpeg': coverImage,
      },
    };
  }
}
