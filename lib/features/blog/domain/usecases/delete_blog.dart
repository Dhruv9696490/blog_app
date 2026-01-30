import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlog implements UseCase<List<Blog>, String> {
  final BlogRepository blogRepository;
  DeleteBlog(this.blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(String blogId) async {
    return await blogRepository.deleteBlog(blogId);
  }
}
