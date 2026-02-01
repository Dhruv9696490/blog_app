import 'dart:typed_data';

import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/blog.dart';

abstract interface class BlogRepository{
  Future<Either<Failure,
      Blog>> uploadBlog({
      required Uint8List image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics,
});
Future<Either<Failure,
      Blog>> updateBlog({
      required String id,
      required Uint8List? image,
      required String? imageUrl,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics,
});

  Future<Either<Failure,List<Blog>>> getAllBlogs( );
  Future<Either<Failure,List<Blog>>> deleteBlog(String blogId);
}