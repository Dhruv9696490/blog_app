import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updateAt,
    super.posterName
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at':  updateAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: (map['id'] ?? '').toString(),
      posterId: (map['poster_id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      content: (map['content'] ?? '').toString(),
      imageUrl: (map['image_url'] ?? '').toString(),
      topics: List<String>.from(map['topics'] ?? []),
      updateAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at'].toString()),
      posterName: (map['profiles']?['name'] ?? '').toString(),
    );
  }


  BlogModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    DateTime? updateAt,
    String? posterName,
  }) {
    return BlogModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updateAt: updateAt ?? this.updateAt,
      posterName: posterName ?? this.posterName,
    );
  }
}
