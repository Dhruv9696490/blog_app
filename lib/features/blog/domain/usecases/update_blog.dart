
import 'dart:typed_data';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateBlog implements UseCase<Blog, UpdateBlogParam> {
  final BlogRepository blogRepository;
  UpdateBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(UpdateBlogParam params) {
    return blogRepository.updateBlog(
      id: params.id,
      image: params.image ,
      imageUrl: params.imageUrl ?? "",
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class UpdateBlogParam {
  final String id;
  final Uint8List? image;
  final String? imageUrl;
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;
  UpdateBlogParam(
    this.id,
    this.image,
    this.imageUrl,
    this.title,
    this.content,
    this.posterId,
    this.topics,
  );
}
